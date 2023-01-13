//
//  Message.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import Foundation

struct Message {
    let text: String
    let time: String
    let isQuestion: Bool
    
    init(text: String, time: String, isQuestion: Bool = true) {
        self.text = text
        self.time = time
        self.isQuestion = isQuestion
    }
}
