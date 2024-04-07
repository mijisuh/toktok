//
//  SceneDelegate.swift
//  TokTok
//
//  Created by mijisuh on 2024/04/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let userDefaults = UserDefaults.standard

    var isAuthUser: Bool {
        get {
            return userDefaults.bool(forKey: "isAuthUser")
        }
        set {
            userDefaults.set(newValue, forKey: "isAuthUser")
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.backgroundColor = .systemBackground
        window?.tintColor = .black
        
        if isAuthUser {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        }
        
        window?.makeKeyAndVisible()
    }
}

