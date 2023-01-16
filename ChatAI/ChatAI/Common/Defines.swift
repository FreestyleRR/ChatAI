//
//  Defines.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

typealias ClosureWith<T> = (T) -> Void
typealias EmptyClosure = () -> Void

enum CommonResult {
    case success(answerMessage: String)
    case failure(errorMessage: String)
}

typealias CommonResultClosure = (CommonResult) -> Void

enum Constants {
    static var key = ""
    static var fontSize: CGFloat = 16
}

func getTopController(from: UIViewController? = nil) -> UIViewController? {
    if let controller = from {
        return controller
    } else if var controller = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first?.rootViewController {
        
        while let presented = controller.presentedViewController {
            controller = presented
        }
        return controller
    }
    return nil
}
