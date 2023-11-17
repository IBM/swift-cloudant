//
//  CouchOperation.swift
//  
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 8/25/23.
//  Copyright © 2023 IBM Corporation. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software distributed under the
//  License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
//  either express or implied. See the License for the specific language governing permissions
//  and limitations under the License.
//


import Foundation

/**
 A protocol that denotes an operation which can be run agasint a CouchDB instance.
 */
public protocol CouchOperation {
    
    /// An optional delegate to recieve operation execution and lifecycle events.
    var operationDelegate: CouchOperationDelegate? { get set }
    
    /**
     The CouchDB API endpoint to call, for example `/exampleDB/document1/` or `/_all_dbs`
     */
    var endpoint: String { get }
    
    /**
     The HTTP method to use when making the API call.
     */
    var method: String { get }
    
    /**
     Dictionary of query parameters, `Key` is the parameter name and `Value` is the
     value to use for that parameter. E.g. ["rev": "1-revisionhash"].
     */
    var parameters: [String: String] { get }
    
    /**
     The data to send to the CouchDB endpoint.
     */
    var data: Data? { get }
    
    
    /**
     The content type of the data to send to the CouchDB endpoint. This is guaranteed to be called
     if and only if `data` is not `nil`
     */
    var contentType: String { get }
    
    /**
     Calls the completionHandler for this operation.
     
     - parameter response: The response received from the server, this should be one of the following types,
    an `Array`/`NSArray`, `Dictionary`/`NSDictionary` or Data.
     - parameter httpInfo: Information about the HTTP response.
     - parameter error: The error that occurred, or nil if the request was made successfully.
    */
    func callCompletionHandler(response: Any?, httpInfo: HTTPInfo?, error: Swift.Error?)
    
    /**
     This method is called from the
     `processResponse(data: Data?, httpInfo: HttpInfo?, error: ErrorProtocol?)` method,
     it will contain the deserialized json response in the event the request returned with a
     2xx status code.
     
     Provides a hook to process the json response
     
     - parameter json: Desearalised json, this will either be an Array or a Dictionary.
     
     - Note: This should be overridden to trigger other handlers such as a handler for each row of
     a returned view.
     */
    func processResponse(json: Any)
    
    
    /**
     Processes the response from CouchDB. This is required to call the following
     methods in the lifecycle of the function when the given circumstances arise:
     
     * callCompletionHandler(error:) when the processing of the response has completed with an error.
     * callCompletionHandler(response:httpInfo:error:) when the processing of the response has completed.
     * processResponse(json:) when a 2xx response code was received and the response is a JSON response.
       This allows an operation to provide additional processing of the JSON.
     */
    func processResponse(data: Data?, httpInfo: HTTPInfo?, error: Swift.Error?)
    
    /**
     Validates the operation has been set up correctly, subclasses should override but call and
     use the result of the super class implementation.
     */
    func validate() -> Bool
    
    /**
     This should be used to serialise any data into the format expected by the CouchDB/Cloudant
     endpoint.
     
     - throws: An error in the event of a failure to serialise.
     - note: This is guaranteed to be  called after `validate() -> Bool` and before the
     `HTTPRequestOperation` properties are computed.
     */
    func serialise() throws
}
