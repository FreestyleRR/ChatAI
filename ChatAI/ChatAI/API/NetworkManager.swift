//
//  NetworkManager.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import Foundation
import OpenAISwift

final class NetworkManager {
    static let shared = NetworkManager()
    
    private var client: OpenAISwift?
    
    @frozen enum Constatnts {
        static let key = ""
    }
    
    private init() {}
    
    public func setup() {
        client = OpenAISwift.init(authToken: Constatnts.key)
    }
    
    public func getResponse(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input) { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
