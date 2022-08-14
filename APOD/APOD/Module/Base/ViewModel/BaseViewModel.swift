//
//  BaseViewModel.swift
//  APOD
//
//  Created by Patel, Mohit on 13/08/22.
//

import Foundation
import UIKit
/// Protocol for communication between `BaseViewModel` and associated controller
protocol BaseViewModelDelegate: AnyObject {
    /**
     Function to show a alert message on screen
     
     - parameter title: title for the alert.
     - parameter message: message for the alert.
     - parameter actionTitles: Array of button titles for the alert updated.
     - parameter style: Array UIAlertAction styles for each action button.
     - parameter actions: Action closures for each action button tap.
     */
    func showAlertMessage(title: String,
                          message: String,
                          actionTitles: [String],
                          style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?])
}
/// View model class for Base Controller
class BaseViewModel {
    
}
