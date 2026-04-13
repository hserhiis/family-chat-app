//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Yevheniia Kolkova on 4/13/2026.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.image = UIImage(systemName: "person.fill")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        containerView.layer.cornerRadius = 8
    }
    
    func presentAvatarOptions() {
        let avatarOptionSheet = UIAlertController(title: "Change Avatar", message: "Select an option.", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default) { _ in
            
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        avatarOptionSheet.addAction(photoAction)
        avatarOptionSheet.addAction(cameraAction)
        avatarOptionSheet.addAction(deleteAction)
        avatarOptionSheet.addAction(cancelAction)
        
        present(avatarOptionSheet, animated: true)
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
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: PrimaryButton) {
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
