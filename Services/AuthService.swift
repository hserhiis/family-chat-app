//
//  AuthService.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 3/7/2026.
//

import FirebaseAuth
import FirebaseDatabase


class AuthService {
    
    static let shared = AuthService()
    
    private let databaseUrl: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "FirebaseURL") as? String else {
            fatalError("FIREBASE_URL not found in Info.plist")
        }
        return url
    }()
    
    private var dbRef: DatabaseReference {
        return Database.database(url: databaseUrl).reference()
    }
    
    private func authenticateUser(username: String?, email: String, password: String, completion: @escaping (ValidationError?) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                if let authError = AuthErrorCode(rawValue: error._code)?.code {
                    switch authError {
                    case .emailAlreadyInUse:
                        completion(.emailInUse)
                    case .invalidEmail:
                        completion(.invalidEmail)
                    default:
                        return
                    }
                }
            }
            
            guard let result = result else {return}
            
            let userId = result.user.uid
            
            var userValue: [String: Any] = [
                "id": userId,
                "email": email
            ]
            
            if let username = username {
                userValue["username"] = username
            }
            
            self.dbRef.child("users").child(userId).setValue(userValue)
            
            if let username = username {
                self.dbRef.child("usernames").child(username).setValue(userValue)
            }
            completion(nil)
        }
    }
    
    func startSignupProcess(username: String?, password: String, email: String, completion: @escaping (Result<Void, ValidationError>) -> Void) {
        
        if let username = username {
            dbRef.child("usernames").child(username).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    completion(.failure(.usernameInUse))
                } else {
                    self.authenticateUser(username: username, email: email, password: password) { result in
                        self.handleAuth(result: result, completion: completion)
                    }
                }
            }) { error in
                print(error.localizedDescription)
                completion(.failure(.signupFailed))
            }
        } else {
            authenticateUser(username: nil, email: email, password: password) { result in
                self.handleAuth(result: result, completion: completion)
            }
        }
    }
    
    func startSigninProcess(password: String, email: String, completion: @escaping(Result<Void, ValidationError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            
            guard let self = self else { return }
            
            if let error = error {
                if let authError = AuthErrorCode(rawValue: error._code)?.code {
                    switch authError {
                    case .emailAlreadyInUse:
                        completion(.failure(.emailInUse))
                    case .invalidEmail:
                        completion(.failure(.invalidEmail))
                    default:
                        return
                    }
                }
            }
            
            guard let result = result else {return}
            
            completion(.success(()))
        }
    }
}

extension AuthService {
    private func handleAuth(result: ValidationError?, completion: @escaping (Result<Void, ValidationError>) -> Void) {
        guard result != nil else {
            completion(.success(()))
            return
        }
        
        switch result {
        case .emailInUse:
            completion(.failure(.emailInUse))
        case .invalidEmail:
            completion(.failure(.invalidEmail))
        default:
            completion(.failure(.signupFailed))
        }
    }
}
