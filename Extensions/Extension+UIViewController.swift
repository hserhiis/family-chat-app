//
//  Extension+UIViewController.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 28/01/2026.
//

import UIKit


extension UIViewController {
    func showErrorAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func navigateToHome() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navVC = UINavigationController(rootViewController: homeVC)
        let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first {$0.isKeyWindow}
        window?.rootViewController = navVC
    }
    
    func getValidatedUser(username: UITextField?, email: UITextField, password: UITextField) -> User? {
        
        let username = username?.text?.nilIfEmpty
        let password = password.text ?? ""
        let email = email.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if let error = AuthValidator.validateAuth(username: username, password: password, email: email) {
            showErrorAlert(title: error.errorDescription.title, message: error.errorDescription.message, actionTitle: "Ok")
            return nil
        }

        return User(username: username, email: email, password: password)
    }
    
    func setupAttributedString(text: String, attributedText: String, key: String, textView: UITextView) {
        
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: Font.caption])
        attributedString.addAttribute(.link, value: "chatapp://\(key)", range: (attributedString.string as NSString).range(of: attributedText))
        
        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.secondary, .font: Font.linkLabel]
    }
    
    func showActivityIndicator() {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let activityIndicator = LoadingView(frame: frame)
        
        view.addSubview(activityIndicator)
        
        activityIndicator.tag = 20260100
    }
    
    func removeActivityIndicator() {
        if let activityIndicator = view.viewWithTag(20260100) {
            activityIndicator.removeFromSuperview()
        }
    }
}
