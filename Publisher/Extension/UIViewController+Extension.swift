//
//  UIViewController+Extension.swift
//  Publisher
//
//  Created by Yi-Chin Hsu on 2021/10/12.
//

import UIKit

// MARK: - Alert -
extension UIViewController {
    
    func showAlert(alertText : String, alertMessage : String) {
        
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
