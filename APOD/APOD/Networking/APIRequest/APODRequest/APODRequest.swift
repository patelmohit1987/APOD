//
//  APODRequest.swift
//  APOD
//
//  Created by Patel, Mohit on 10/08/22.
//

import Foundation
import Moya

enum APODRequest {
    case getPickOfDay(queryParameters: [String: String])
}

extension APODRequest: TargetType {
    var sampleData: Data {
        return Data()
    }
    
    var baseURL: URL {
        return URL(string: EnvironmentProvider.baseURL)!
    }
    
    var path: String {
        return EnvironmentProvider.RequestPath.getPicOfDay.rawValue
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getPickOfDay(queryParameters: let queryParam):
            return.requestParameters(parameters: queryParam, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return EnvironmentProvider.defautHeaders
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}

extension APODRequest: NetworkRequest {
    
    /**
     Function to execute network request defined by the type of `UserProfileRequest` self instance
     
     - parameter successCallback: Success response callback to be called on request completion
     - parameter failureCallback: Failure response callback to be called on request completion
     */
    func executeRequest(successCallback: @escaping ((Any?) -> Void), failureCallback: @escaping ((Error) -> Void)) {
        let responseCallbacks: NetworkResponse = responseCallbacksForGetOnDemandType(successCallback: successCallback, failureCallback: failureCallback)
        
        request(target: self, responseCallback: responseCallbacks)
    }
    
}
