//
//  NetworkReachablityManager.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//

import Foundation
import Alamofire
class ReachabilityManager
{
    //shared instance
    static let shared = ReachabilityManager()
    
    func isNetworkAvailable() -> Bool {
        guard let reachabilityManager = NetworkReachabilityManager() else {
            return true
        }
        return reachabilityManager.isReachable
    }
}
