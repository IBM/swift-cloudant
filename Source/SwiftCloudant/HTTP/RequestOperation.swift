// RequestOperation.swift
//  
//  SwiftCloudant
//
//  Created by Emily Doran on 8/24/23.
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

// TODO rename to something that makes a little more swift sense.
/**
 Designates an operation which provides data to perform a HTTP Request.
 */
internal protocol HTTPRequestOperation   {

    /**
     The root of url, e.g. `example.cloudant.com`
     */
    var rootURL: URL { get }
    
    /**
     The path of the url e.g. `/exampledb/document1/`
     */
    var httpPath: String { get }
    /**
     The method to use for the HTTP request e.g. `GET`
     */
    var httpMethod: String { get }
    /**
     The query items to use for the request
     */
    var queryItems: [URLQueryItem] { get }
    
    /**
     The body of the HTTP request or `nil` if there is no data for the request.
     */
    var httpRequestBody: Data? { get }
    
    /**
     The content type of the HTTP request payload. This is guranteed to be called
     if and only if `httpRequestBody` is not `nil`
     */
    var httpContentType: String { get }
    
    /**
     Provides the `InterceptableSession` to use when making HTTP requests.
     */
    var session: InterceptableSession { get }
    
    /**
     A function that is called when the operation is completed.
     */
    func completeOperation()
    /**
     A function to process the response from a HTTP request.

     - parameter data: The data returned from the HTTP request or nil if there was an error.
     - parameter httpInfo: Information about the HTTP response.
     - parameter error: A type representing an error if one occurred or `nil`
     */
    func processResponse(data: Data?, httpInfo: HTTPInfo?, error: Error?);

    var isCancelled: Bool { get }
}
