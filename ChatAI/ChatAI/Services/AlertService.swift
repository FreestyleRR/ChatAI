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
    
    func showAlert(
        title: String = "Error",
        msg: String? = "",
        from: UIViewController? = nil,
        leftBtnTitle: String? = "Ok",
        leftBtnStyle: UIAlertAction.Style = .default,
        rightBtnTitle: String? = nil,
        rightBtnStyle: UIAlertAction.Style = .default,
        completion: ClosureWith<Bool>? = nil
    ) {
        guard let root = getTopController(from: from) else { return }
        
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: leftBtnTitle, style: leftBtnStyle) { _ in
            alertVC.dismiss(animated: true, completion: nil)
            completion?(false)
        }
        alertVC.addAction(ok)
        
        if let alertRightBtnTitle = rightBtnTitle {
            let action = UIAlertAction(title: alertRightBtnTitle, style: rightBtnStyle) { _ in
                alertVC.dismiss(animated: true, completion: nil)
                completion?(true)
            }
            alertVC.addAction(action)
            alertVC.preferredAction = action
        }
        DispatchQueue.main.async {
            root.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTextField(
        title: String? = "Insert your API key",
        message: String? = nil,
        leftBtnTitle: String = "Cancel",
        rightBtnTitle: String = "Ok",
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
        let ok = UIAlertAction(title: leftBtnTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(ok)
        
        let rightButtonAction = UIAlertAction(title: rightBtnTitle, style: .default) { _ in
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
