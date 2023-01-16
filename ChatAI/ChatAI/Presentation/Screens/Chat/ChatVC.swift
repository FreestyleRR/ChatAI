//
//  ChatVC.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import UIKit

final class ChatVC: UIViewController {
    var viewModel: ChatVM!
    
    //MARK: - Private properties -
    
    private var messages = [Message]()
    
    private var currentTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date())
    }
    
    //MARK: - Lazy properties -
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 25
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.showsHorizontalScrollIndicator = false
        tableView.registerNib(cellType: MessageCell.self)
        return tableView
    }()
    
    private lazy var inputTextView: InputTextView = {
        let textView = InputTextView()
        textView.onSendTapped = CommandWith<String> { [weak self] in self?.sendQuestion($0) }
        return textView
    }()
    
    private lazy var bottomSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
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
        setupBackground()
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
    
    private func setupBackground() {
        let view = BackgroundView()
        view.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundView = view
    }
    
    //MARK: - Network -
    
    private func sendQuestion(_ question: String) {
        if question.isEmpty { return }
        
        let questionMessage = Message(text: question, time: currentTime)
        messages.insert(questionMessage, at: 0)
        insertNewCell()
        
        if Constants.key.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                
                let answerMessage = Message(
                    text: "You need to paste your OpenAI API key. In the right corner, tap the gear and set your key.",
                    time: self.currentTime,
                    isQuestion: false
                )
                self.messages.insert(answerMessage, at: 0)
                self.insertNewCell()
            }
            return
        }
        
        viewModel.sendQuestion(question) { result in
            switch result {
            case .success(let answer):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let answerMessage = Message(text: answer, time: self.currentTime, isQuestion: false)
                    self.messages.insert(answerMessage, at: 0)
                    self.insertNewCell()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    let answerMessage = Message(text: error, time: self.currentTime, isQuestion: false)
                    self.messages.insert(answerMessage, at: 0)
                    self.insertNewCell()
                }
            }
        }
    }
    
    //MARK: - Update cells -
    
    private func insertNewCell() {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
    }
    
    //MARK: - Actions -
    
    @objc private func settingsButtonTapped() {
        AlertService.shared.showAlertWithTextField { Constants.key = $0 }
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource -

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.count > 0 { tableView.backgroundView = nil }
        return messages.count
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
