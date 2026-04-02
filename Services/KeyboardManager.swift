//
//  KeyboardService.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 3/13/2026.
//

import UIKit


class KeyboardManager {
    private weak var scrollView: UIScrollView?
    private weak var viewController: UIViewController?
    private weak var activeTextField: UITextField?
    
    init(scrollView: UIScrollView, in viewController: UIViewController) {
        self.scrollView = scrollView
        self.viewController = viewController
        registerKeyboardNotifications()
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIWindow.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldsDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: nil)
    }
    
    @objc private func textFieldsDidBeginEditing(_ notification: Notification) {
        activeTextField = notification.object as? UITextField
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView?.contentInset = .zero
        scrollView?.verticalScrollIndicatorInsets = .zero
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardOffset = keyboardFrame.cgRectValue.height
        let textFieldHeight = activeTextField!.frame.height
        let totalOffset = keyboardOffset + (textFieldHeight / 2)
        scrollView?.contentInset.bottom = totalOffset
        
        scrollView?.verticalScrollIndicatorInsets.bottom = totalOffset
                
        if let activeField = activeTextField {
            let rect = activeField.convert(activeField.bounds, to: scrollView)
            scrollView?.scrollRectToVisible(rect, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
