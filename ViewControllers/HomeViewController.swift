//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 19/12/2025.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            let authSB = UIStoryboard(name: "Auth", bundle: nil)
            let authVC = authSB.instantiateViewController(withIdentifier: "SignInViewController")
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            window?.rootViewController = authVC
        } catch {
            showErrorAlert(title: "Error", message: "Something went wrong, please try again", actionTitle: "Ok")
        }
        
    }

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Confirm logout", message: "Are you sure?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
