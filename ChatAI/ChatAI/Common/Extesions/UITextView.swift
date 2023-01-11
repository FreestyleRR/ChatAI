//
//  UITextView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 11.01.2023.
//

import UIKit

extension UITextView {
    var numberOfLines: Int {
        let size = sizeFit(width: bounds.width)
        let numLines = Int(size.height / (font?.lineHeight ?? 1))
        return numLines
    }
    
    func sizeFit(width: CGFloat) -> CGSize {
        let newSize = sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return CGSize(width: width, height: newSize.height)
    }
}
