//
//  BackgroundView.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 14.01.2023.
//

import UIKit

final class BackgroundView: UIView {
    
    //MARK: - Private properties -
    
    private var textLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have any questions yet"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🧐"
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    //MARK: - Setup -
    
    private func setup() {
        backgroundColor = .clear
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.addArrangedSubviews(emojiLabel, textLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 130),
        ])
    }
}
