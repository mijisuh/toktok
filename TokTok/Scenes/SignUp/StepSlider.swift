//
//  StepSlider.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit

class StepSlider: UISlider {
    var trackLineHeight: CGFloat = 2.0
    var step: Int = 0
    var width: CGFloat = 0

    init(step: Int, width: CGFloat) {
        super.init(frame: .zero)
        
        self.step = step
        self.width = width
        
        self.isUserInteractionEnabled = false
        self.maximumValue = Float(width)
        self.value = self.maximumValue / 5 * Float(step)
        self.thumbTintColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bound: CGRect) -> CGRect {
        return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: trackLineHeight))
    }
}
