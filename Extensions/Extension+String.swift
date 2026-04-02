//
//  Extension+String.swift
//  ChatApp
//
//  Created by Serhii Shapovalov on 28/01/2026.
//

import Foundation

extension String {
    // Email validation (from before)
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    // Password validation
    var isValidPassword: Bool {
        // Requirements: 8+ characters, 1 uppercase, 1 lowercase, 1 number
        // Optional: Add (?=.*[$@$!%*?&]) for special characters
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    var nilIfEmpty: String? {
        return self.trimmingCharacters(in: .whitespaces).isEmpty ? nil : self
    }
}
