//
//  NetworkRequest.swift
//  APOD
//  Created by Patel, Mohit on 10/08/22.

import Moya
/**
 Session for all network requests in application
 */
let AppSessionManager: Manager = {
    
    
    // Create session
    let session = Manager(configuration: URLSessionConfiguration.default)
    
    // Return Session
    return session
}()

/**
  Tuple type defined for wrapping the response received from network request
   
  - parameter dataCallback:Callback that should be called when request return in success with a data
  - parameter errorCallback:Callback that should be called when request return in error or failure
 */
typealias NetworkResponse = (dataCallback: ((Any?) -> Void)?, errorCallback: ((Error) -> Void)?)


/// Instance for `NetworkLoggerPlugin`. Use this for any network log in Moya provider requests.
let networkLoggerPlugin = NetworkLoggerPlugin(verbose: true)

/**
 Protocol declaring the methods for making Moya based API calls and get the response back
 */
protocol NetworkRequest {
    
    /**
     Method to fire network request.
     This method will create a Moya provider for the specified `TargetType` request and then fire it to fetch response. Response is returned back wrapped inside `NetworkResponseCallback` tuple.
     
     - parameter target: Instance of the concrete class implementeing `TargetType` protocol, defining request parameters.
     - parameter responseCallback: Tuple wrapping the response of network request
     
     - SeeAlso: `NetworkResponseCallback`
     */
    func request<Target: TargetType>(target: Target, responseCallback: NetworkResponse, mockResponse: Bool)
    
}

extension NetworkRequest {
    
    // MARK: - Private functions
    
    /**
     Function to actually make the API request, attempt to save to cache, and return it to the end user
     - parameter provider: Context of the provider to use to make the request
     - parameter target: Target with the details on the request options passed from the network reqest calling objects
     - parameter responseCallback: Response callback tree to respond to, to go to the calling object
     */
    private func makeRequest<Target: TargetType>(_ provider: MoyaProvider<Target>, _ target: Target, _ responseCallback: NetworkResponse, _ mockResponse: Bool = false) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                
                if !response.data.isEmpty {
                    responseCallback.dataCallback?(response.data)
                } else {
                    responseCallback.dataCallback?(nil)
                }
            case .failure(let error):
                responseCallback.errorCallback?(error)
            }
        }
        return
    }
    
    // MARK: - Public functions

    /**
     Function to make a request for each APIRequest extension object, responding to the response callback end user
     - parameter target: Target with the details on the request options passed from the network reqest calling objects
     - parameter responseCallback: Response callback tree to respond to, to go to the calling object
     */

    func request<Target: TargetType>(target: Target, responseCallback: NetworkResponse, mockResponse: Bool = false) {
        
        let provider = MoyaProvider<Target>(endpointClosure: MoyaProvider<Target>.defaultEndpointMapping,
                                            requestClosure: MoyaProvider<Target>.defaultRequestMapping,
                                            stubClosure: MoyaProvider.neverStub,
                                            callbackQueue: nil,
                                            manager: AppSessionManager,
                                            plugins: [networkLoggerPlugin],
                                            trackInflights: false)
        
        makeRequest(provider, target, responseCallback)
    }
    
    
}
