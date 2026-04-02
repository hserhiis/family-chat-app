//
//  SignInViewController.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 31/12/2025.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var createAccountTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var activeTextField: UITextField?
    
    private var keyboardManager: KeyboardManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.clipsToBounds = true
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager = KeyboardManager(scrollView: scrollView, in: self)
    }
    
    private func setupViews() {
        setupAttributedString(
            text: "Don't have an account? Create an account here.",
            attributedText: "Create an account here.",
            key: "createAccount",
            textView: createAccountTextView
        )
        
        createAccountTextView.textAlignment = .center
        createAccountTextView.delegate = self
        createAccountTextView.isEditable = false
        createAccountTextView.isScrollEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func clearFields() {
        passwordTextField.text = ""
        emailTextField.text = ""
    }

    @IBAction func signinButtonTapped(_ sender: Any) {
        
        if let validatedUser = self.getValidatedUser(username: nil, email: emailTextField, password: passwordTextField) {
            let email = validatedUser.email
            let password = validatedUser.password
            
            self.showActivityIndicator()
            
            AuthService.shared.startSigninProcess(password: password, email: email) { [weak self] result in
                
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    
                    self.removeActivityIndicator()

                    switch result {
                    case .success:
                        self.clearFields()
                        self.navigateToHome()
                        
                    case .failure(let error):
                        let details = error.errorDescription
                        self.showErrorAlert(title: details.title, message: details.message, actionTitle: "Ok")
                    }
                }
            }
        }
    }

}


