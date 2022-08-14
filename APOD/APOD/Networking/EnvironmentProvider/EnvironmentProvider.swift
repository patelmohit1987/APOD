//
//  EnvironmentProvider.swift
//  APOD
//
//  Created by Patel, Mohit on 10/08/22.
//

import Foundation
struct EnvironmentProvider {
    /// base url of webservices's request
    static var baseURL = "https://api.nasa.gov"
    static var apiKey = "4ZBQVix50zRDWZdOOuKrhhWpkqcyRa4SuMbtWqKB"
    static var defautHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
    }
    
    /// Relative paths of webservices's request
    enum RequestPath: String {
        case getPicOfDay = "planetary/apod"
    }
    
    
}
