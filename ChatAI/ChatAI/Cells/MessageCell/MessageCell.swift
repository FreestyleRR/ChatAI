//
//  MessageCell.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

final class MessageCell: UITableViewCell {
    private var message: Message!
    
    //MARK: - Private properties -
    
    private let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 9)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var questionConstraints = [NSLayoutConstraint]()
    private var answerConstraints = [NSLayoutConstraint]()
    
    //MARK: - Life Cycle View -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        timeLabel.text = nil
        NSLayoutConstraint.deactivate(questionConstraints)
        NSLayoutConstraint.deactivate(answerConstraints)
        configure(with: message)
    }
    
    //MARK: - Setup -
    
    private func setup() {
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.addSubview(messageView)
        messageView.addSubviews(messageLabel, timeLabel)
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 5),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -7),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -4),
            
            timeLabel.widthAnchor.constraint(equalToConstant: 30),
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -3),
        ])
        
        let leadingConstraintQuestion = messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50)
        let trailingConstraintQuestion = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        questionConstraints.append(leadingConstraintQuestion)
        questionConstraints.append(trailingConstraintQuestion)
        
        let leadingConstraintAnswer = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        let trailingConstraintAnswer = messageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50)
        answerConstraints.append(leadingConstraintAnswer)
        answerConstraints.append(trailingConstraintAnswer)
    }
    
    //MARK: - Configure -
    
    func configure(with message: Message) {
        self.message = message
        
        messageLabel.text = message.text
        timeLabel.text = message.time
        
        messageView.backgroundColor = message.isQuestion ? .systemGray6 : .systemGray4
        
        if message.isQuestion {
            NSLayoutConstraint.deactivate(answerConstraints)
            NSLayoutConstraint.activate(questionConstraints)
        } else {
            NSLayoutConstraint.deactivate(questionConstraints)
            NSLayoutConstraint.activate(answerConstraints)
        }
    }
}
