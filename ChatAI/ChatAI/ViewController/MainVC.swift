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
//        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.onSendTapped = CommandWith<String> { [weak self] in
            guard let self = self else { return }
            
            self.sendQuestion($0)
            self.outputTextView.insertText("Question: \($0)\n\n")
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
        setupGesture()
    }

    private func setupConstraints() {
        view.addSubviews(tableView, outputTextView, inputTextView, bottomSpacerView)
        
        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
//            tableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -10),
            
            outputTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            outputTextView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -10),
            
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            bottomSpacerView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            bottomSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        outputTextView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Network -
    
    private func sendQuestion(_ question: String) {
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    self?.outputTextView.insertText("Answer: " + answer + "\n\n")
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.outputTextView.insertText("Answer: " + error + "\n\n")
                }
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
