//
//  UIButton+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/04.
//

import UIKit

extension UIButton {
    static var rounded: UIButton {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        button.setBackgroundColor(.primary, for: .normal)
        button.setBackgroundColor(.primary?.withAlphaComponent(0.8), for: .highlighted)
        button.setBackgroundColor(.primary?.withAlphaComponent(0.3), for: .disabled)
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        return button
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color!.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
