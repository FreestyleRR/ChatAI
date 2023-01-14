//
//  UIStackView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 14.01.2023.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
