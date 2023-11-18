//
//  PutDocumentOperation+JSONSerialization.swift
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

/// An extension containing functions related to use of the `JSONSerialization` framework.
extension PutDocumentOperation {
    /// Returns a `Bool` indicating whether or not the
    /// value for self.body is serializable as valid JSON
    /// using `JSONSerialization`.
    public func validate() -> Bool {
        return JSONSerialization.isValidJSONObject(body)
    }
    /// Attempts to serialize the value for self.body as JSON using `JSONSerialization`.
    public func serialise() throws {
        data = try JSONSerialization.data(withJSONObject: body)
    }
}
