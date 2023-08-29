//
//	File.swift
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
 Configuration for `InterceptableSession`
 */
internal struct InterceptableSessionConfiguration {
    
    /**
     The maximum number of retries the session should make before returning the result of an HTTP request
     */
    internal var maxRetries: UInt
    /**
     The number of times to back off from making requests when a 429 response is encountered
     */
    internal var backOffRetries: UInt
    /**
     Should the session back off, if false the session will not back off and retry automatically.
     */
    internal var shouldBackOff: Bool
    
    /**
     The initial value to use when backing off.
    */
    internal var initialBackOff: DispatchTimeInterval
    
    internal var username: String?
    
    internal var password: String?
    
    internal var useSubfolderHostPath: Bool
    
    init(maxRetries: UInt = 10, shouldBackOff:Bool,
         backOffRetries: UInt = 3,
         initialBackOff: DispatchTimeInterval = .milliseconds(250),
         username: String? = nil,
         password: String? = nil,
         useSubfolderHostPath: Bool = false){
        
        self.maxRetries = maxRetries
        self.shouldBackOff = shouldBackOff
        self.backOffRetries = backOffRetries
        self.initialBackOff = initialBackOff
        self.username = username
        self.password = password
        self.useSubfolderHostPath = useSubfolderHostPath
    }
}
