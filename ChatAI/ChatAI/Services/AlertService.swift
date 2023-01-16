//
//  AlertService.swift
//  ChatAI
//
//  Created by Pavel Sharkov on 13.01.2023.
//

import UIKit

final class AlertService {
    static let shared = AlertService()
    
    private init() {}
    
    func showAlertWithTextField(
        title: String? = "Insert your API key",
        message: String? = nil,
        leftButtonTitle: String = "Cancel",
        rightButtonTitle: String = "Ok",
        text: String = "",
        placeholder: String? = "Key...",
        completion: @escaping ClosureWith<String>
    ) {
        guard let root = getTopController() else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = text
            textField.placeholder = placeholder
            
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.smartDashesType = .no
            textField.smartInsertDeleteType = .no
            textField.smartQuotesType = .no
            textField.spellCheckingType = .no
        }
        let ok = UIAlertAction(title: leftButtonTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(ok)
        
        let rightButtonAction = UIAlertAction(title: rightButtonTitle, style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                alert.dismiss(animated: true)
                completion(text)
            }
        }
        alert.addAction(rightButtonAction)
        alert.preferredAction = rightButtonAction
        
        DispatchQueue.main.async { root.present(alert, animated: true) }
    }
}
