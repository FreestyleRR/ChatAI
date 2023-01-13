//
//  MainVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

//enum Message {
//    case question(_ question: String)
//    case answer(_ answer: String)
//}



final class MainVC: UIViewController {
    var viewModel: MainVM!
    
    private var messages = [Message]()
    
    private var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    //MARK: - Lazy properties -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        tableView.estimatedRowHeight = 25
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.registerNib(cellType: QuestionCell.self)
        tableView.registerNib(cellType: AnswerCell.self)
        tableView.registerNib(cellType: MessageCell.self)
        
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
    
    //MARK: - Setup -
    
    private func setup() {
        setupNavBar()
        setupConstraints()
        setupGesture()
        setupTableView()
    }

    private func setupConstraints() {
        view.addSubviews(tableView, inputTextView, bottomSpacerView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputTextView.topAnchor),
            
            inputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            
            bottomSpacerView.topAnchor.constraint(equalTo: inputTextView.bottomAnchor),
            bottomSpacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSpacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomSpacerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
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
        if question.isEmpty { return }
        
        if Constatnts.key.isEmpty {
            let questionMessage = Message(text: question, time: currentTime)
            let answerMessage = Message(
                text: "You need to paste your OpenAI API key. In the right corner, tap the gear and set your key.",
                time: currentTime,
                isQuestion: false
            )
            
            messages.insert(questionMessage, at: 0)
            tableView.reloadData()
            
            messages.insert(answerMessage, at: 0)
            tableView.reloadData()
            return
        } else {
            let questionMessage = Message(text: question, time: currentTime)
            messages.insert(questionMessage, at: 0)
            tableView.reloadData()
        }
        
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let answerMessage = Message(text: answer, time: self.currentTime, isQuestion: false)
                    self.messages.insert(answerMessage, at: 0)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let answerMessage = Message(text: error, time: self.currentTime, isQuestion: false)
                    self.messages.insert(answerMessage, at: 0)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func settingsButtonTapped() {
        AlertService.shared.showAlertWithTextField {
            Constatnts.key = $0
        }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource -

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MessageCell = tableView.dequeCell(for: indexPath) else {
            return UITableViewCell()
        }
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        let message = messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}
