//
//  MainVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

enum Message {
    case question(_ question: String)
    case answer(_ answer: String)
}

final class MainVC: UIViewController {
    var viewModel: MainVM!
    
    private var messages = [Message]()
    
    //MARK: - Lazy properties -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.registerNib(cellType: QuestionCell.self)
        tableView.registerNib(cellType: AnswerCell.self)
        
        return tableView
    }()
    
    private lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.onSendTapped = CommandWith<String> { [weak self] in self?.sendQuestion($0) }
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
        setupNavBar()
        setupConstraints()
        setupGesture()
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    private func setupConstraints() {
        view.addSubviews(tableView, inputTextView, bottomSpacerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
    
    private func setupNavBar() {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped)
        )
        navigationItem.rightBarButtonItem = item
        navigationItem.title = "Chat AI"
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Network -
    
    private func sendQuestion(_ question: String) {
        messages.insert(.question(question), at: 0)
        tableView.reloadData()
        
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    self?.messages.insert(.answer(answer), at: 0)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.messages.insert(.answer(error), at: 0)
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func settingsButtonTapped() {
        print("tapp")
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource -

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messages[indexPath.row] {
        case .question(let question):
            guard let cell: QuestionCell = tableView.dequeCell(for: indexPath) else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.configure(with: question)
            return cell
        case .answer(let answer):
            guard let cell: AnswerCell = tableView.dequeCell(for: indexPath) else {
                return UITableViewCell()
            }
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.configure(with: answer)
            return cell
        }
    }
}
