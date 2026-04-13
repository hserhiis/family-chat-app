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
    
    

    @IBAction func profileButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToProfile", sender: nil)
    }
}
