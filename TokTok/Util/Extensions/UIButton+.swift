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
        button.setBackgroundColor(.primary?.withAlphaComponent(0.9), for: .highlighted)
        button.setBackgroundColor(.primary?.withAlphaComponent(0.3), for: .disabled)
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        return button
    }
    
    static var link: UIButton {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12.0)
        
        var configuration = UIButton.Configuration.plain()
        configuration.image = Icon.link.image?.withConfiguration(imageConfig)
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .secondaryLabel
        configuration.contentInsets = .zero
        
        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .fill
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
