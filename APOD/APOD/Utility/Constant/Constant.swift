//
//  Constant.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import Foundation

struct APIJSONKeys {
    static let date = "date"
    static let thumbs = "thumbs"
    static let api_key = "api_key"
    static let video = "video"
}

struct DateFormat {
    static let API_DATE_FORMAT = "yyyy-MM-dd"
}

struct StringLiterals {
    static let thumb_true = "true"
    static let fail = "Fail!"
    static let alertTitle_Fail = "Fail!"
    static let alertMessage = "Fail to fetch picture at this time."
    static let alertButton_OK = "OK"
}
