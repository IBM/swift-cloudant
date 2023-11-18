//
//  CouchOperationOutcome.swift
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

/// A class containing shared operations for all inheriting `CouchOperationOutcome` types.
public class CouchOperationOutcome: Codable {
    /// Returns an instance of type `T` from `Data`
    /// if it is possible to decode `Data` as `T`.
    public static func fromData<T>(_ data: Data) -> T? where T: Codable {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("SwiftCloudant::ERROR:: could not decode data as type: \(type(of: T.self))")
            return nil
        }
    }
    /// Attempts to return an encoded instance
    /// using `JSONEncoder` as raw `Data`.
    var encoded: Data? {
        do {
            let encoded = try JSONEncoder().encode(self)
            return encoded
        } catch {
            return nil
        }
    }
    /// Returns a prettified JSON string for use with logging
    /// or user-facing operations.
    ///
    /// - Note: if `JSONEncoder` is unable to encode
    /// an error will be returned
    var prettyfied: String {
        // setup error string
        let errString = "SwiftCloudant::ERROR:: could not prettify"
        // setup encoder with formatting
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        // attempt to prettify
        do {
            let encoded = try JSONEncoder().encode(self)
            if let prettyStr = String(data: encoded, encoding: .utf8) {
                return prettyStr
            } else {
                return errString
            }
        } catch {
            return "\(errString), error: \(error)"
        }
    }
}
