//
//  UIViewController+Extension.swift
//  APOD
//
//  Created by Patel, Mohit on 13/08/22.
//

import Foundation
import UIKit
extension UIViewController {
    /**
     Show alert view
     - parameter title: title of alert
     - parameter message: message of alert
     - parameter actionTitles: List of action button titles(ex : "OK","Cancel" etc)
     - parameter style: Style of the buttons
     - parameter actions: actions respective to each actionTitles
     - parameter preferredActionIndex: Index of the button that need to be shown in bold. If nil is passed then it takes cancel as default button.
     */
    
    public func showAlert(title: String?, message: String?, actionTitles: [String?], style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?], preferredActionIndex: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        self.present(alert, animated: true, completion: nil)
    }
}
