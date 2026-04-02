//
//  CreateAccountViewController.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 25/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinAccountTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var activeTextField: UITextField?
    
    private var keyboardManager: KeyboardManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager = KeyboardManager(scrollView: scrollView, in: self)
    }
    
    private func setupViews() {
        
        setupAttributedString(
            text: "Already have an account? Sign in here.",
            attributedText: "Sign in here.",
            key: "signin",
            textView: signinAccountTextView
        )
        
        signinAccountTextView.textAlignment = .center
        signinAccountTextView.delegate = self
        signinAccountTextView.isEditable = false
        signinAccountTextView.isScrollEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    private func clearFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        if let user = self.getValidatedUser(username: usernameTextField, email: emailTextField, password: passwordTextField) {
            
            let username = user.username
            let email    = user.email
            let password = user.password
            
            self.showActivityIndicator()
            
            AuthService.shared.startSignupProcess(username: username, password: password, email: email) { [weak self] result in

                DispatchQueue.main.async {
                    guard let self = self else {return}
                    
                    self.removeActivityIndicator()
                    
                    switch result {
                    case .success:
                        print("Success")
                        self.clearFields()
                        self.navigateToHome()
                        
                    case .failure(let error):
                        print("Failure")
                        let details = error.errorDescription
                        self.showErrorAlert(title: details.title, message: details.message, actionTitle: "Ok")
                    }
                }
            }
        }
    }
}
