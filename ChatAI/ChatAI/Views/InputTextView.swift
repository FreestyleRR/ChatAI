//
//  InputTextView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 11.01.2023.
//

import UIKit

final class InputTextView: UIView {
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .tertiarySystemFill
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    private var sendButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .capsule
        config.background.backgroundColor = .link
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Typing here..."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupConstraints() {
        addSubviews(separatorView, textView, sendButton, placeholderLabel)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -7),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 34),
            sendButton.widthAnchor.constraint(equalToConstant: 34),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.leadingAnchor, constant:  -10),
        ])
    }
    
    @objc private func sendButtonAction() {
        print("Tapp...")
    }
    
}
