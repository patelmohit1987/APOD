//
//  APODRequest+ResponseFactory.swift
//  APOD
//
//  Created by Patel, Mohit on 10/08/22.
//

import Foundation
import Moya

extension APODRequest {
    /**
    Function to generate and return the response callback for handling the response of APOD API
     
     - parameter successCallback: Success callback on response parsing
     - parameter failureCallback: Failure callback on response parsing
 */
    func responseCallbacksForGetOnDemandType(successCallback: @escaping ((Any?) -> Void), failureCallback: @escaping ((Error) -> Void)) -> NetworkResponse {
        let responseCallbacks: NetworkResponse = (dataCallback: {(data) in
            
            guard let jsonData = data as? Data else {
                successCallback(nil)
                return
            }
            do {
                let model = try JSONDecoder().decode(APODResponseModel.self, from: jsonData)
                successCallback(model)
            } catch let error {
                failureCallback(error)
            }
        }, errorCallback: {(error) in
            failureCallback(error)
        })
        return responseCallbacks
    }
}
