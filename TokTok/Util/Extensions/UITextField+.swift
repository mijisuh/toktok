//
//  UITextField+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit
import RxSwift
import RxCocoa

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

extension Reactive where Base : UITextField {
    var borderColorWidth : Binder<(color: UIColor, width: CGFloat)?> {
        return Binder(self.base) { textfield, colorWidth in
            textfield.layer.borderColor = colorWidth?.color.cgColor
            textfield.layer.borderWidth = colorWidth?.width ?? 0.5
        }
    }
        
    // Textfield의 edit 상태에 대한 event 전달
    var beginEditing : ControlEvent<Void> {
        return controlEvent(.editingDidBegin)
    }
    var endEditing : ControlEvent<Void> {
        return controlEvent(.editingDidEnd)
    }
    var returnPressed: ControlEvent<Void> {
        return controlEvent(.editingDidEndOnExit)
    }
}
