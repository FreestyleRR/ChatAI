//
//  QuestionCell.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

final class QuestionCell: UITableViewCell {
    private var questionText: String!
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: questionText)
    }
    
    private func setup() {
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubviews(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            questionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            questionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7),
            questionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with text: String) {
        questionText = text
        
        questionLabel.text = text
    }
}

