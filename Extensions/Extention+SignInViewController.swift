//
//  Extention+SignInViewController.swift
//  ChatApp
//
//  Created by Yevheniia Kolkova on 3/29/2026.
//

import Foundation
import UIKit


extension SignInViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "chatapp" {
            performSegue(withIdentifier: "goToCreateAccount", sender: nil)
        }
        
        return false
    }
}
