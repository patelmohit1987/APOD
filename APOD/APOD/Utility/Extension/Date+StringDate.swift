//
//  Date+StringDate.swift
//  APOD
//
//  Created by Patel, Mohit on 12/08/22.
//

import Foundation
extension Date {
    /**
        Function to get string from date in current timezone
        - parameter format: Date format to be used
        - returns: Date object from specifed string & format.
    */
    func string(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
}
