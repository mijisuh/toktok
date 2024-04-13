//
//  String+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/08.
//

import UIKit

// String값을 가지고 예상되는 frame 크기를 return 하는 메소드 정의
extension String {
    func getEstimatedFrame(with font: UIFont) -> CGRect {
        let size = CGSize(width: UIScreen.main.bounds.width * 2/3 - 32.0, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [.font: font], context: nil)
        return estimatedFrame
    }
}
