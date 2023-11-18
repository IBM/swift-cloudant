//
//  CreateTextQueryIndexOperation.swift
// 
//  SwiftCloudant
//
//  Created by Rhys Short on 18/05/2016.
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

/**
 An Operation to create a Text Query (Mango) Index.
 
 Usage Example:
 ```
 let index = CreateTextQueryIndexOperation(databaseName: "exampledb",
            name: "example",
            fields: [TextIndexField(name:"food", type: .string),
            defaultFieldAnalyzer: "english",
            defaultFieldEnabled:  true,
            selector:["type": "food"],
            designDocumentID: "examples"){ (response, httpInfo, error) in
    if let error = error {
        // handle the error
    } else {
        // Check the status code for success.
    }
 }
 client.add(operation: index)
 */
public class CreateTextQueryIndexOperation: CouchDatabaseOperation, MangoOperation, JSONOperation {
    
    public var operationDelegate: CouchOperationDelegate?

    /**
     Creates the operation.
     
     - parameter databaseName : The name of the database where the index should be created.
     - parameter name : The name of the index, if `nil` the server will generate a name for the index.
     - parameter fields : the fields which should be indexed, if `nil` all the fields in a document
     will be indexed.
     - parameter defaultFieldAnalyzer: The analyzer to use for the default field. The default field is
     used when using the `$text` operator in queries.
     - parameter defaultFieldAnalyzerEnabled: Determines if the default field should be enabled.
     - parameter selector: A selector which documents should match before being indexed.
     - parameter designDocumentID : the ID of the design document where the index should be saved,
     if `nil` the server will create a new design document with a generated ID.
     - parameter completionHandler: optional handler to run when the operation completes.
     */
    public init(databaseName: String,
                name: String? = nil,
                fields: [TextIndexField]? = nil,
                defaultFieldAnalyzer: String? = nil,
                defaultFieldEnabled: Bool? = nil,
                selector: [String:Any]? = nil,
                designDocumentID: String? = nil,
                completionHandler: (([String : Any]?, HTTPInfo?, Error?) -> Void)? = nil) {
        self.databaseName = databaseName
        self.completionHandler = completionHandler
        self.name = name
        self.fields = fields
        self.defaultFieldEnabled = defaultFieldEnabled
        self.defaultFieldAnalyzer = defaultFieldAnalyzer
        self.selector = selector
        self.designDocumentID = designDocumentID
    }
    
    public let databaseName: String
    public let completionHandler: ((_ response: [String : Any]?, _ httpInfo: HTTPInfo?, _ error: Error?) -> Void)?
    
    /**
     The name of the index
     */
    public let name: String?
    
    /**
     The fields to be included in the index.
     */
    public let fields: [TextIndexField]?
    
    /**
     The name of the analyzer to use for $text operator with this index.
     */
    public let defaultFieldAnalyzer: String?
    
    /**
     If the default field should be enabled for this index.
     
     - Note: If this is not enabled the `$text` operator will **always** return 0 results.
     
     */
    public let defaultFieldEnabled: Bool?
    
    /**
     The selector that limits the documents in the index.
     */
    public let selector: [String: Any]?
    
    /**
     The name of the design doc this index should be included with
     */
    public let designDocumentID: String?
    
    private var jsonData : Data?
    public  var data: Data? {
        return jsonData
    }
    
    public var method: String {
        return "POST"
    }
    
    public var endpoint: String {
        return "/\(self.databaseName)/_index"
    }
    
    public func validate() -> Bool {
        
        if let selector = selector {
            return JSONSerialization.isValidJSONObject(selector)
        }
        
        return true
    }
    
    public func serialise() throws {
        
        do {
            var jsonDict: [String: Any] = [:]
            var index: [String: Any] = [:]
            var defaultField: [String: Any] = [:]
            
            jsonDict["type"] = "text"
            
            if let name = name {
                jsonDict["name"] = name
            }
            
            if let fields = fields {
                index["fields"] = transform(fields: fields)
            }
            
            if let defaultFieldEnabled = defaultFieldEnabled {
                defaultField["enabled"] = defaultFieldEnabled
            }
            
            if let defaultFieldAnalyzer = defaultFieldAnalyzer {
                defaultField["analyzer"] = defaultFieldAnalyzer
            }
            
            if let designDocumentID = designDocumentID {
                jsonDict["ddoc"] = designDocumentID
            }
            
            if let selector = selector {
                index["selector"] = selector
            }
            
            if defaultField.count > 0 {
                index["default_field"] = defaultField
            }
            
            if index.count > 0 {
                jsonDict["index"] = index
            }
            
            self.jsonData = try JSONSerialization.data(withJSONObject:jsonDict)
            
        }
    }
}
