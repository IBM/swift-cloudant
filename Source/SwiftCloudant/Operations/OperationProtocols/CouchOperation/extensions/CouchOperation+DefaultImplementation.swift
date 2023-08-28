//
//  CouchOperation+DefaultImplementation.swift
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

public extension CouchOperation {
    /**
     Calls the completion handler for the operation with the specified error.
     Subclasses need to override this to call the completion handler they have defined.
     */
    func callCompletionHandler(error: Swift.Error) {
        self.callCompletionHandler(response: nil, httpInfo: nil, error: error)
    }
    
    // default implementation of serialise, does nothing.
    func serialise() throws { return }
    
    // default implementation, does nothing.
    func processResponse(json: Any) { return }
    
    var contentType: String { return "application/json" }
    
    var data: Data? { return nil }
    
    var parameters: [String: String] { return [:] }
    
    var method: String { return "GET" }
    
    func validate() -> Bool { return true }
}
