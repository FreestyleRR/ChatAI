//
//  Storyboard.swift
//  calculator
//
//  Created by Pavel Sharkov on 22.09.2022.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

enum Storyboard {
    
    //MARK: - Tabs -
    
    static let main = storyboard(name: "Main")
}

private func storyboard(name: String, bundle: Bundle? = nil) -> UIStoryboard {
    UIStoryboard(name: name, bundle: bundle)
}

// MARK: - UIStoryboard + instantiate -

extension UIStoryboard {
    func instantiate<T: StoryboardIdentifiable>() -> T {
        guard let controller = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Controller is nil with the identifier: \(T.storyboardIdentifier)")
        }
        return controller
    }
}

// MARK: - StoryboardIdentifiable -

extension UIViewController: StoryboardIdentifiable {}

// MARK: - StoryboardIdentifiable where Self: UIViewController -

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        String(describing: self.self)
    }
}
