//
//  CreateJSONQueryIndexOperation.swift
// 
//  SwiftCloudant
//
//  Created by Emily Doran on 8/28/23.
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
    An operation to create a JSON Query (Mango) Index.
 
    Usage example:
    ```
    let index = CreateJSONQueryIndexOperation(databaseName: "exampledb",
        designDocumentID: "examples",
        name:"exampleIndex",
        fields: [Sort(field:"food", sort: .desc)]) { (response, httpInfo, error) in
        if let error = error {
            // handle the error
        } else {
            // Check the status code for success.
        }
 
    }
 
    client.add(operation: index)
    ```
 */
public class CreateJSONQueryIndexOperation: CouchDatabaseOperation, MangoOperation, JSONOperation {
    
    /**
     Creates the operation
     - parameter databaseName : The name of the database where the index should be created.
     - parameter designDocumentID : The ID of the design document where the index should be saved,
     if set to `nil` the server will create a new design document with a generated ID.
     - parameter fields : the fields to be indexed.
     - parameter completionHandler: block to run when the operation completes.
    */
    public init(databaseName: String,
            designDocumentID: String? = nil,
                        name: String? = nil,
                      fields: [Sort],
                              completionHandler: (( [String : Any]?, HTTPInfo?, Error?) -> Void)? = nil) {
        self.databaseName = databaseName
        self.fields = fields
        self.designDocumentID = designDocumentID
        self.name = name
        self.completionHandler = completionHandler
    }
    
    public let databaseName: String
    
    public let completionHandler: (( [String : Any]?, HTTPInfo?, Error?) -> Void)?
    
    /**
     The name of the index.
     */
    public let name: String?
    
    /**
     The fields to which the index will be applied.
     */
    public let fields: [Sort]
    
    /**
     The ID of the design document that this index should be saved to. If `nil` the server will
     create a new design document with a generated ID.
     */
    public let designDocumentID: String?

    private var jsonData: Data?
    
    
    public var method: String {
        return "POST"
    }

    public var data: Data? {
        return self.jsonData
    }
    
    public var endpoint: String {
        return "/\(self.databaseName)/_index"
    }

    public func serialise() throws {
        
        var jsonDict: [String: Any] = ["type": "json"]

        var index: [String: Any] = [:]
        index["fields"] = transform(sortArray: fields)
        jsonDict["index"] = index
            
        if let name = name {
            jsonDict["name"] = name
        }

        if let designDocumentID = designDocumentID {
            jsonDict["ddoc"] = designDocumentID
        }

        jsonData = try JSONSerialization.data(withJSONObject: jsonDict)
    }
}
