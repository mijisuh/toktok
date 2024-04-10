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
    var total: Int = 1

    init(step: Int, total: Int) {
        super.init(frame: .zero)
        
        self.step = step
        self.total = total
        
        self.isUserInteractionEnabled = false
        self.value = self.maximumValue / Float(total) * Float(step)
        self.setThumbImage(UIImage.init(), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bound: CGRect) -> CGRect {
        return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: trackLineHeight))
    }
}
