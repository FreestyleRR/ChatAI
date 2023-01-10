//
//  AppDelegate.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkManager.shared.setup()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let coordinator = MainCoord(window: window)
        coordinator.start()
        
        return true
    }
}

