//
//  UIViewController+.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/06.
//

import UIKit

extension UIViewController {
    @objc func didTapLeftBarButtonItem() {
        navigationController?.popViewController(animated: true)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // 노티피케이션을 추가하는 메서드
    func addKeyboardNotifications(_ keyboardWillShow: Selector, _ keyboardWillHide: Selector) {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(
            self,
            selector: keyboardWillShow,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(
            self,
            selector: keyboardWillHide,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
            return true
    }
}
