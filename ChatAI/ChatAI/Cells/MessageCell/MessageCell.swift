//
//  MessageCell.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

final class MessageCell: UITableViewCell {
    
    //MARK: - Private properties -
    
    private let messageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    //MARK: - Life Cycle View -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        timeLabel.text = nil
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
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 13),
            messageLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -5),
            
            timeLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -13),
        ])
        
        leadingConstraint = messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 8)
        leadingConstraint.isActive = true
        trailingConstraint = messageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        trailingConstraint.isActive = true
    }
    
    //MARK: - Configure -
    
    func configure(with message: Message) {
        messageLabel.text = message.text
        timeLabel.text = message.time
        
        messageView.backgroundColor = message.isQuestion ? .systemGray6 : .systemGray4
        
        if message.isQuestion {
            leadingConstraint = messageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 50)
            leadingConstraint.isActive = true
            trailingConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
            trailingConstraint.isActive = true
        } else {
            leadingConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
            trailingConstraint = messageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -50)
            leadingConstraint.isActive = true
            trailingConstraint.isActive = true
        }
        
//        leadingConstraint.constant = message.isQuestion ? 50 : 8
//        trailingConstraint.constant = message.isQuestion ? -8 : -50
    }
}
