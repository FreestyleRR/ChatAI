//
//  MainVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

class MainVC: UIViewController {
    var viewModel: MainVM!
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Typing here..."
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubview(textField)
        
        
//        NSLayoutConstraint.activate([
//            textField.
//        ])
    }
    
    
}
