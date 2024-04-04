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
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
}
