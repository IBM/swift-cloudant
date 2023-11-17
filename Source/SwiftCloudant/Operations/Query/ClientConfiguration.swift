//
//  ClientConfiguration.swift
//
//  SwiftCloudant
//
//  Created by Jason Swann` on 11/17/23.
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
 Configures an instance of CouchDBClient.
 */
public struct ClientConfiguration {
    /**
     Should the client back off when a 429 response is encountered. Backing off will result
     in the client retrying the request at a later time.
     */
    public var shouldBackOff: Bool
    /**
     The number of attempts the client should make to back off and get a successful response
     from server.

     - Note: The maximum is hard limited by the client to 10 retries.
     */
    public var backOffAttempts: UInt

    /**
     The initial value to use when backing off.

     - Remark: The client uses a doubling back off when a 429 reponse is encountered, so care is required when selecting
     the initial back off value and the number of attempts to back off and successfully retreive a response from the server.
     */
    public var initialBackOff:DispatchTimeInterval
    
    /**
     An explicit flag to set, indicating if URL paths should be
     treated for targeting a CouchDB instance hosted on a
     subfolder, rather than root-level, or a subdomain.
     
     - Note: Default value is `false`
     */
    public var useSubfolderHostPath: Bool
    
    /**
     The number of attempts the client should make to back off and get a successful response
     from server.

     - Note: The maximum is hard limited by the client to 10 retries.
     */
    public var clientTimeoutInterval: Double
    
    /**
     Creates an ClientConfiguration
     - parameter shouldBackOff: Should the client automatically back off.
     - parameter backOffAttempts: The number of attempts the client should make to back off and
     get a successful response. Default 3.
     - parameter initialBackOff: The time to wait before retrying when the first 429 response is received,
     this value will be doubled for each subsequent back off

     */
    public init(shouldBackOff: Bool,
                backOffAttempts: UInt = 3,
                initialBackOff: DispatchTimeInterval = .milliseconds(250),
                useSubfolderHostPath: Bool = false,
                clientTimeoutInterval: Double = 10.0){
        self.shouldBackOff = shouldBackOff
        self.backOffAttempts = backOffAttempts
        self.initialBackOff = initialBackOff
        self.useSubfolderHostPath = useSubfolderHostPath
        self.clientTimeoutInterval = clientTimeoutInterval
    }
}
