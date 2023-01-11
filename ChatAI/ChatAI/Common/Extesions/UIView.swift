//
//  UIView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 11.01.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
