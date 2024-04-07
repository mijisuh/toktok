//
//  TabBarController.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewControllers: [UIViewController] = TabBarItem.allCases.map { item in
            let viewController = item.viewController
            viewController.tabBarItem = UITabBarItem(
                title: item.title,
                image: item.icon,
                selectedImage: item.icon
            )
            viewController.view.backgroundColor = .background
            return viewController
        }
        
        tabBar.tintColor = .highlighted
        
        self.viewControllers = viewControllers
    }
}
