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
        
        setup()
        
        return true
    }
    
    private func setup() {
        startApp()
        setupNetworkManager()
    }
    
    private func startApp() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let coordinator = MainCoord(window: window)
        coordinator.start()
    }
    
    private func setupNetworkManager() {
        NetworkManager.shared.setup()
    }
}
