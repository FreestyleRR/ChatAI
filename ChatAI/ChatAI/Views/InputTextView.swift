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
    private let defaultTextViewHeight: CGFloat = 34
    private var heightConstraint: NSLayoutConstraint?
    private let fontSize: CGFloat = 15
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        textView.backgroundColor = .systemBackground
        textView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = fontSize
        textView.tintColor = .systemRed
        textView.layer.masksToBounds = true
        
        textView.showsVerticalScrollIndicator = true
        textView.showsHorizontalScrollIndicator = false
        
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.smartDashesType = .no
        textView.smartInsertDeleteType = .no
        textView.smartQuotesType = .no
        textView.spellCheckingType = .no
        textView.returnKeyType = .send
        
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        var config = UIButton.Configuration.gray()
        config.cornerStyle = .capsule
        config.background.backgroundColor = .link
        
        let imageConfig = UIImage.SymbolConfiguration(scale: .medium)
        let image = UIImage(systemName: "arrow.up", withConfiguration: imageConfig)
        
        let button = UIButton(configuration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Question"
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var text: String { textView.text }
    public var onSendTapped: CommandWith<String> = .nop
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .systemGray6
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
            
            sendButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: (fontSize + 2) * 2),
            sendButton.widthAnchor.constraint(equalToConstant: (fontSize + 2) * 2),
            
            placeholderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 14),
            placeholderLabel.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant:  -14),
        ])
    }
    
    private func checkTextView() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        if heightConstraint?.constant == textView.contentSize.height { return }
        
        let isConstraintActive = heightConstraint.flatMap { $0.isActive } ?? false

        if isConstraintActive == false {
            heightConstraint = textView.heightAnchor.constraint(equalToConstant: textView.frame.height)
            heightConstraint?.isActive = true
            textView.isScrollEnabled = true
        } else {
            if textView.numberOfLines < inputLinesScrollThreshold {
                heightConstraint?.constant = textView.contentSize.height
            }
        }
        textView.layoutIfNeeded()
    }
    
    //MARK: - Helpers -
    
    private func resetTextView() {
        textView.text.removeAll()
        heightConstraint?.constant = defaultTextViewHeight
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
        checkTextView()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendButtonTap()
            return false
        }
        return true
    }
}
