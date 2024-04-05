//
//  UILabel+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit

extension UILabel {
    static var large: UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }
    
    static var secondary: UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }
}
