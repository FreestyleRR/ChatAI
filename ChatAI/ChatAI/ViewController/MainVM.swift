//
//  MainVM.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import Foundation

final class MainVM {
    private let coordinator: MainCoord
    private let networkManager: NetworkManager
    
    init(_ coordinator: MainCoord) {
        self.coordinator = coordinator
        networkManager = NetworkManager.shared
    }
    
    //MARK: - Network -
    
    func sendQuestion(_ question: String, completion: @escaping (Result<String, Error>) -> Void) {
        networkManager.getResponse(input: question) { result in
            switch result {
            case .success(let answer):
                completion(.success(answer))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
