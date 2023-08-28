//  JSONOperation.swift
//
//  JSONOperation.swift
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
    Marks an operation as a JSON Operation. It will provide response
    processing for operations.
 */
public protocol JSONOperation: CouchOperation {
    
    /**
     The Json type that is expected. This should only be a type that can be returned from `NSJSONSeralization`
    */
    associatedtype Json
    
    /**
     Sets a completion handler to run when the operation completes.
     
     - parameter response: - The full deseralised JSON response.
     - parameter httpInfo: - Information about the HTTP response.
     - parameter error: - ErrorProtocol instance with information about an error executing the operation.
     */
    var completionHandler: ((Json?, HTTPInfo?, Swift.Error?) -> Void)? { get }
}
