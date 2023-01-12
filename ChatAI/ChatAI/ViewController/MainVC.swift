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
    
    private lazy var tableView: UITableView = {
        let textView = UITableView()
        textView.backgroundColor = .systemBackground
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.onSendTapped = CommandWith<String> { [weak self] in
            guard let self = self else { return }
            
            self.sendQuestion($0)
            self.outputTextView.insertText("Me: - \($0) \n")
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
    }

    private func setupConstraints() {
        view.addSubviews(tableView, inputTextView, bottomSpacerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
            tableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor, constant: -10),
            
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            bottomSpacerView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            bottomSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func sendQuestion(_ question: String) {
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    self?.outputTextView.insertText(answer)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
