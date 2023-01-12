//
//  MainVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

class MainVC: UIViewController {
    var viewModel: MainVM!
    
    //MARK: - Lazy properties -
    
    private lazy var outputTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemBackground
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.onSendTapped = CommandWith<String> { [weak self] in
            guard let self = self else { return }
            
            self.sendQuestion($0)
            self.outputTextView.insertText("\n" + $0)
        }
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Life Cycle VC -

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        hideKeyboard()
    }
    
    //MARK: - Setup -
    
    private func setup() {
        title = "Chat AI"
        setupConstraints()
        setupNotifications()
        setupDismissKeyboardGesture()
    }

    private func setupConstraints() {
        view.addSubviews(outputTextView, inputTextView, bottomSpacerView)
        
        NSLayoutConstraint.activate([
            outputTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            outputTextView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -10),
            
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomSpacerView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            bottomSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupDismissKeyboardGesture() {
        let gestureTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureTap)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func sendQuestion(_ question: String) {
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    self?.outputTextView.insertText(answer)
                }
            case .failure(let error):
                print(String(describing: error.localizedDescription))
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if abs(view.frame.origin.y) != abs(keyboardSize.height) {
                view.frame.origin.y = -keyboardSize.height
                UIView.animate(withDuration: 0.1) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc private func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
