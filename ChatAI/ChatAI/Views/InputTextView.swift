//
//  InputTextView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 11.01.2023.
//

import UIKit

final class InputTextView: UIView {
    
    //MARK: - Properties -
    
    public var text: String { textView.text.trimmingCharacters(in: .whitespaces) }
    public var onSendTapped: CommandWith<String> = .nop
    
    //MARK: - Lazy properties -
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.textContainerInset = .init(top: 6, left: 9, bottom: 6, right: 9)
        textView.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.contentMode = .left
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = Constants.fontSize
        textView.layer.masksToBounds = true
        textView.returnKeyType = .send
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.preferredSymbolConfigurationForImage = .init(weight: .semibold)
        let imageConfig = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "arrow.up", withConfiguration: imageConfig)
        
        let button = UIButton(configuration: config)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Question"
        label.font = UIFont.systemFont(ofSize: Constants.fontSize, weight: .regular)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    //MARK: - Setup -
    
    private func setupConstraints() {
        addSubviews(separatorView, textView, sendButton, placeholderLabel)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            textView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 6),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -7),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            sendButton.heightAnchor.constraint(equalToConstant: (Constants.fontSize - 1) * 2),
            sendButton.widthAnchor.constraint(equalToConstant: (Constants.fontSize - 1) * 2),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -33),
        ])
    }
    
    //MARK: - Helpers -
    
    private func resetTextView() {
        textView.text.removeAll()
        placeholderLabel.isHidden = false
    }
    
    //MARK: - Actions -
    
    private func sendButtonTap() {
        onSendTapped.perform(with: textView.text)
        resetTextView()
    }
    
    @objc private func sendButtonAction() {
        sendButtonTap()
    }
}

//MARK: - UITextViewDelegate -

extension InputTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendButtonTap()
            return false
        }
        return true
    }
}
