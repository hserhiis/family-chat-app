//
//  AuthValidator.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 28/01/2026.
//

import Foundation
import Firebase

struct ErrorDescription {
    let title:   String
    let message: String
}

enum ValidationError: Error {
    case emptyField(String)
    case invalidUsername
    case invalidPassword
    case invalidEmail
    case usernameInUse
    case emailInUse
    case signupFailed
    case signinFailed
    case userNotFound
    
    var errorDescription: ErrorDescription {
        switch self {
        case .emptyField(let field):
            return ErrorDescription(title: "\(field) required!", message: "Please enter a \(field.lowercased()).")
        case .invalidUsername:
            return ErrorDescription(title: "Invalid username!", message: "Username must be between 3 to 15 characters.")
        case .invalidPassword:
            return ErrorDescription(title: "Weak password!", message: "Include at least one uppercase letter and one number.")
        case .invalidEmail:
            return ErrorDescription(title: "Invalid email!", message: "Please check your email format.")
        case .usernameInUse:
            return ErrorDescription(title: "Username in Use!", message: "Please try a different username.")
        case .emailInUse:
            return ErrorDescription(title: "Email already exist!", message: "If you already registered please log in.")
        case .signupFailed:
            return ErrorDescription(title: "Signup Failed!", message: "Please try again later.")
        case .signinFailed:
            return ErrorDescription(title: "Signin failed!", message: "Something went wrong, please try again later.")
        case .userNotFound:
            return ErrorDescription(title: "User not found", message: "User is not created yet, please create an account.")
        }
    }
}

struct AuthValidator {
    static func validateAuth(username: String?, password: String, email: String) -> ValidationError? {
        
        if let username = username, !(3...15).contains(username.count) {
            return .invalidUsername
        }
        
        guard !password.isEmpty else {
            return .emptyField("Password")
        }
        
        guard !email.isEmpty else {
            return .emptyField("Email")
        }
        
        guard password.isValidPassword else {
            return .invalidPassword
        }
        
        guard email.isValidEmail else {
            return .invalidEmail
        }
        
        return nil
    }
}
