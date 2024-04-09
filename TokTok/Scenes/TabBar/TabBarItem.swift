//
//  TabBarItem.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/07.
//

import UIKit

enum TabBarItem: CaseIterable {
    case chat
    case account
    
    var title: String {
        switch self {
        case .chat: return "채팅"
        case .account: return "계정"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .chat: return Icon.chat.image
        case .account: return Icon.account.image
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .chat: return UINavigationController(rootViewController: ChatListViewController())
        case .account: return UINavigationController(rootViewController: UIViewController())
        }
    }
}
