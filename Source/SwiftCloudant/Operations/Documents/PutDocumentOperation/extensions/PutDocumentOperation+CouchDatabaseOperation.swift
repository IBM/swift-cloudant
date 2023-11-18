//
//  PutDocumentOperation+CouchDatabaseOperation.swift
//
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 11/17/23.
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

/// An extension overriding default implementation functions for `CouchDatabaseOperation`.
extension PutDocumentOperation {
    // checking if implementing this
    // actually recieves the response
    // outcome for processing
    public func processResponse(data: Data?, httpInfo: HTTPInfo?, error: Error?) {
        if let error = error {
            operationDelegate?.operationDidFail(with: error)
        }
        // current understanding is that
        // operation response validation
        // is performed by `InterceptableSession`
        // so if no error, assume success
        if let data = data {
            operationDelegate?.operationDidSucceed(with: data)
        }
        // pass along info as well
        if let httpInfo = httpInfo {
            operationDelegate?.operationDidRespond(with: httpInfo)
        }
    }
}
