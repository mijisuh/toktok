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

    init(step: Int) {
        super.init(frame: .zero)
        
        self.step = step
        
        self.isUserInteractionEnabled = false
        self.value = Float(self.maximumValue / 5.0) * Float(step)
        self.setThumbImage(UIImage.init(), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bound: CGRect) -> CGRect {
        return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: trackLineHeight))
    }
}
