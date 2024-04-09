//
//  UITextView+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/09.
//

import UIKit

extension UITextView {
    func setLineAndLetterSpacing(_ text: String){
        let style = NSMutableParagraphStyle()
        // 행간 세팅
        style.lineSpacing = 9.0
        let attributedString = NSMutableAttributedString(string: text)
        // 자간 세팅
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
    
    func scrollToTop() {
        setContentOffset(CGPoint.zero, animated: true)
    }
    
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
    }
}
