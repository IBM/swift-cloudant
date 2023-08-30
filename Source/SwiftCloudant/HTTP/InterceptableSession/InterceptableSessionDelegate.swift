//
//	InterceptableSessionDelegate.swift
//  
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 8/29/23.
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
    A delegate for receiving data and responses from a URL task.
 */
internal protocol InterceptableSessionDelegate {
    
    /**
     Called when the response is received from the server
     - parameter response: The response received from the server
    */
    func received(response:HTTPURLResponse)
    
    /**
    Called when response data is available from the server, may be called multiple times.
     - parameter data: The data received from the server, this may be only a fraction of the data
     the server is sending as part of the response.
    */
    func received(data: Data)
    
    /**
    Called when the request has completed
     - parameter error: The error that occurred when making the request if any.
    */
    func completed(error: Swift.Error?)
}
