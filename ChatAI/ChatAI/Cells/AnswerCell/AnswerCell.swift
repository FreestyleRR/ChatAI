//
//  AnswerCell.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

final class AnswerCell: UITableViewCell {
    private var answerText: String!
    
    private var answerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: answerText)
    }
    
    private func setup() {
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubviews(answerLabel)
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            answerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            answerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with text: String) {
        answerText = text
        
        answerLabel.text = text
    }
}

