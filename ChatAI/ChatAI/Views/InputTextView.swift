//
//  InputTextView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 11.01.2023.
//

import UIKit

final class InputTextView: UIView {
    
    //MARK: - Properties -
    
    private let inputLinesScrollThreshold = 6
    private var heightConstraint: NSLayoutConstraint?
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textView.backgroundColor = .tertiarySystemFill
        textView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 17
        
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        textView.smartQuotesType = .no
        textView.spellCheckingType = .no
        textView.returnKeyType = .send
        
        textView.tintColor = .systemRed
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
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
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Typing here..."
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var onSendTapped: CommandWith<String> = .nop
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Setup -
    
    private func setupConstraints() {
        addSubviews(separatorView, textView, sendButton, placeholderLabel)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 9),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -7),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 34),
            sendButton.widthAnchor.constraint(equalToConstant: 34),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 14),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant:  -14),
        ])
    }
    
    private func checkTextView() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        let isConstraintActive = heightConstraint.flatMap { $0.isActive } ?? false
        
        let lineHeight = textView.font?.lineHeight ?? 1
        
        if isConstraintActive == false {
            heightConstraint = textView.heightAnchor.constraint(equalToConstant: textView.frame.height)
            heightConstraint?.isActive = true
            textView.isScrollEnabled = true
        } else {
            heightConstraint?.constant = textView.numberOfLines > inputLinesScrollThreshold
            ? lineHeight * CGFloat(inputLinesScrollThreshold) : textView.contentSize.height
        }
        textView.layoutIfNeeded()
    }
    
    //MARK: - Actions -
    
    @objc private func sendButtonAction() {
        onSendTapped.perform(with: textView.text)
        textView.text.removeAll()
    }
}

//MARK: - UITextViewDelegate -

extension InputTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkTextView()
    }
}
