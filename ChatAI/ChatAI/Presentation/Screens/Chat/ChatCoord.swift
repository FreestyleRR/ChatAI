//
//  ChatCoord.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

final class ChatCoord {
    
    private weak var window: UIWindow?
    
    private lazy var controller: ChatVC = {
        let controller: ChatVC = Storyboard.chat.instantiate()
        controller.viewModel = ChatVM(self)
        return controller
    }()
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController(rootViewController: controller)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        root.navigationBar.scrollEdgeAppearance = appearance
        root.navigationBar.compactAppearance = appearance
        root.navigationBar.standardAppearance = appearance
        root.navigationBar.compactScrollEdgeAppearance = appearance
        return root
    }()
    
    init(window: UIWindow) {
        self.window = window
        controller.viewModel = .init(self)
    }
}

//MARK: - Navigation -

extension ChatCoord {
    func start() {
        window?.rootViewController = root
        window?.makeKeyAndVisible()
    }
}
