//
//  ChatVM.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import Foundation

final class ChatVM {
    private let coordinator: ChatCoord
    private let networkManager: NetworkManager
    
    init(_ coordinator: ChatCoord) {
        self.coordinator = coordinator
        networkManager = NetworkManager.shared
    }
    
    //MARK: - Network -
    
    func sendQuestion(_ question: String, completion: @escaping CommonResultClosure) {
        networkManager.getResponse(input: question) { result in
            switch result {
            case .success(let answer):
                completion(.success(answerMessage: answer))
            case .failure(let error):
                completion(.failure(errorMessage: error))
            }
        }
    }
}
