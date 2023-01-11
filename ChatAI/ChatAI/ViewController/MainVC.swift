//
//  MainVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

class MainVC: UIViewController {
    var viewModel: MainVM!
    
    private var outputTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.isUserInteractionEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var inputTextView: InputTextView = {
        let textView = InputTextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupConstraints()
    }

    private func setupConstraints() {
        view.addSubviews(outputTextView, inputTextView)
        
        NSLayoutConstraint.activate([
            outputTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            outputTextView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor),
            
            inputTextView.topAnchor.constraint(equalTo: outputTextView.bottomAnchor),
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputTextView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
}
