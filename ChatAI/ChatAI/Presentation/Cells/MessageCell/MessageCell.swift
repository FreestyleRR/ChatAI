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
        view.layer.cornerRadius = Constants.fontSize - 1
        return view
    }()
    
    private var messageTextView: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.textContainerInset = .init(top: 6, left: 6, bottom: 6, right: 0)
        textView.font = .systemFont(ofSize: Constants.fontSize)
        return textView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: Constants.fontSize - 6)
        label.textColor = .systemGray
        return label
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
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
        messageTextView.text = nil
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
        contentView.addSubviews(messageView, activityIndicatorView)
        messageView.addSubviews(messageTextView, timeLabel)
        
        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            activityIndicatorView.trailingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: -10),
            activityIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11),
            
            messageTextView.topAnchor.constraint(equalTo: messageView.topAnchor),
            messageTextView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -1),
            
            timeLabel.widthAnchor.constraint(equalToConstant: 30),
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -5),
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
        
        messageView.backgroundColor = message.isQuestion ? .systemGray6 : .systemGray4
        messageTextView.text = message.text
        timeLabel.text = message.time
        message.isQuestion ? startAnimating() : stopAnimating()
        activityIndicatorView.isHidden = !message.isQuestion
        
        if message.isQuestion {
            NSLayoutConstraint.deactivate(answerConstraints)
            NSLayoutConstraint.activate(questionConstraints)
        } else {
            NSLayoutConstraint.deactivate(questionConstraints)
            NSLayoutConstraint.activate(answerConstraints)
        }
    }
    
    //MARK: - Animation -
    
    public func startAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
