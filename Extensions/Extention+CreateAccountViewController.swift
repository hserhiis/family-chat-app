//
//  Extention+CreateAccountViewController.swift
//  ChatApp
//
//  Created by Yevheniia Kolkova on 3/29/2026.
//

import Foundation
import UIKit

extension CreateAccountViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "chatapp" {
            dismiss(animated: true)
        }
        
        return false
    }
}
