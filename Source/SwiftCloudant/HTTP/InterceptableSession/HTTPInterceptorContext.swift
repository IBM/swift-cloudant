//
//	HTTPInterceptorContext.swift
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
 The context for a HTTP interceptor.
 */
public struct HTTPInterceptorContext {
    /**
     The request that will be made, this can be modified to add additional data to the request such
     as session cookie authentication of custom tracking headers.
     */
    var request: URLRequest
    /**
     The response that was received from the server. This will be `nil` if the request errored
     or has not yet been made.
     */
    let response: HTTPURLResponse?
    /**
     A flag that signals to the HTTP layer that it should retry the request.
     */
    var shouldRetry: Bool = false
}
