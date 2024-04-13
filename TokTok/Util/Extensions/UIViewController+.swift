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
}
