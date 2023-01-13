//
//  NetworkManager.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 10.01.2023.
//

import Foundation
import OpenAISwift

enum CommonResult {
    case success(answerMessage: String)
    case failure(errorMessage: String)
}

typealias CommonResultClosure = (CommonResult) -> Void

final class NetworkManager {
    static let shared = NetworkManager()
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        client = OpenAISwift.init(authToken: Constatnts.key)
    }
    
    public func getResponse(input: String, completion: @escaping CommonResultClosure) {
        client?.sendCompletion(with: input, maxTokens: 1000) { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(answerMessage: output))
            case .failure(let error):
                completion(.failure(errorMessage: error.localizedDescription))
            }
        }
    }
}

struct ErrorResponse: Decodable, Error {
    let message: String
}
