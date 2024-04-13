//
//  UITextField+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit

extension UITextField {
    static var rounded: UITextField {
        let textField = UITextField()
        textField.layer.cornerRadius = 8.0
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.placeholderText.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16.0, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }
}
