//
//  PutDocumentOperation.swift
//  SwiftCloudant
//
//  Created by stefan kruger on 05/03/2016.
//  Copyright (c) 2016 IBM Corp.
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

/// Creates or updates a document.
///
///
/// Example using `JSONEncoder`:
///
/// ```
/// // init custom type that conforms to the `SCStorableObject` protocol
/// let var storableNote: SCNote = .init(title: "asdfasdtest new notes title",
///                                      body: "nest note body",
///                                      created: Int(createdDate),
///                                      createdBy: tempUUID)
///
/// // init the document operation using convenience initializer
/// let documentOperation: PutDocumentOperation = .init(storableObject: newNote, databaseName: targetDB)
///
/// // take delegation of operation (class must conform to `CouchOperationDelegate` protocol)
/// documentOperation.operationDelegate = self
///
/// // queue operation for execution
/// couchClient?.add(operation: createNoteOperation)
///
/// ...
///
/// // when operation executes delegate functions will receive data / info / error
/// ```
///
/// Example using `JSONSerialization`:
///
/// ```
/// let create = PutDocumentOperation(id: "example", body: ["hello":"world"], databaseName: "exampleDB") { (response, httpInfo, error) in
///    if let error = error {
///        // handle the error
///    } else {
///        // successfull request.
///    }
/// }
/// ```
///
public class PutDocumentOperation: CouchDatabaseOperation, JSONOperation {
    /// An optional delegate that should recieve data
    /// and notifications related to `CouchDatabaseOperation`
    /// state updates and operation outcomes.
    public var operationDelegate: CouchOperationDelegate?
    /// Creates the operation using JSONSerialization.
    ///
    /// - parameter id: the id of the document to create or update, or nil if the server should generate an ID.
    /// - parameter revision: the revision of the document to update, or `nil` if it is a create.
    /// - parameter body: the body of the document
    /// - parameter databaseName: the name of the database where the document will be created / updated.
    /// - parameter completionHandler: optional handler to run when the operation completes.
    ///
    public init(id: String? = nil,
                revision: String? = nil,
                body: [String: Any],
                databaseName:String,
                completionHandler: (([String : Any]?, HTTPInfo?, Error?) -> Void)? = nil) {
        self.id = id
        self.revision = revision
        self.body = body
        self.databaseName = databaseName
        self.completionHandler = completionHandler
    }
    /// Creates the operation using `JSONEncoder` with an
    /// object that conforms to protocol `SCStorableObject`.
    ///
    /// - parameter id: the id of the document to create or update, or nil if the server should generate an ID.
    /// - parameter revision: the revision of the document to update, or `nil` if it is a create.
    /// - parameter body: the body of the document
    /// - parameter databaseName: the name of the database where the document will be created / updated.
    /// - parameter completionHandler: optional handler to run when the operation completes.
    ///
    public convenience init(id: String? = nil,
                            revision: String? = nil,
                            storableObject: SCStorableObject,
                            databaseName:String,
                            completionHandler: (([String : Any]?, HTTPInfo?, Error?) -> Void)? = nil) {
        
        // TODO: eventually refactor requirement for body to init PutDocumentOperation
        // init using dummy value for body since
        // this init routine is not using JSONEncoder
        // instead of JSONSerialization
        self.init(body: ["null": "null"], databaseName: databaseName)
        
        // actually init using JSONEncoder
        do {
            // ecode from storable object
            try encodeJSON(storableObject)
        } catch {
            operationDelegate?.operationDidFail(with: error)
        }
    }
    /// The document that this operation will modify
    public let id: String?
    /// The revision of the document being updated or `nil` if this operation is creating a document.
    public let revision: String?
    /// A `JSONSerialization` representation of the JSON object processed by the operation.
    public let body: [String: Any]
    /// A raw `Data` representation of the JSON document processed by the operation.
    public internal(set) var data: Data?
    /// An optional callback function to use when handling the outcome of the operation.
    public let completionHandler: (([String : Any]?, HTTPInfo?, Error?) -> Void)?
    /// The name of the database within which the operation should be executed.
    public let databaseName: String
    /// A `String` describing the HTTP method to use in forming
    ///  the operation's "Method" URL header.
    public var method: String {
        get {
            if let _ = id {
                return "PUT"
            } else {
                return "POST"
            }
        }
    }
    /// A `String` representing the CouchDB instance's host
    /// to be used in the formation of the target `URL` for the
    /// operation's `URLRequest`.
    public var endpoint: String {
        get {
            if let id = id {
                return "/\(self.databaseName)/\(id)"
            } else {
                return "/\(self.databaseName)"
            }
        }
        
    }
    /// An array of parameters to use in the formation of the operation `URLRequest`.
    public var parameters: [String: String] {
        get {
            var items:[String:String] = [:]

            if let revision = revision {
                items["rev"] = revision
            }
            
            return items
        }
    }
}
