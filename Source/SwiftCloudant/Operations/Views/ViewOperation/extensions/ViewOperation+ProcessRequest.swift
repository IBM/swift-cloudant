// ViewOperation+ProcessRequest.swift
//  
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 8/24/23.
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

public extension ViewOperation {
    
    func processResponse(json: Any) {
        if let json = json as? [String: Any] {
            let rows = json["rows"] as! [[String: Any]]
            for row: [String: Any] in rows {
                self.rowHandler?(row)
            }
        }
    }
    
    var method: String {
        get {
            if keys != nil {
                return "POST"
            } else {
                return "GET"
            }
        }
    }
    
    /**
    Generates parameters for the following properties
 
    * descending
    * startKeyDocId
    * endKeyDocId
    * inclusiveEnd
    * limit
    * skip
    * includeDocs
    * conflicts
     
     
    - Note: Implementing types *have* to add parameters which use the `associatedtype` `ViewParameter`
    */
    func makeParams() -> [String : String]{
        var items: [String: String] = [:]
        
        if let descending = descending {
            items["descending"] = "\(descending)"
        }
        
        if let startKeyDocId = startKeyDocumentID {
            items["startkey_docid"] = startKeyDocId
        }
        
        if let endKeyDocId = endKeyDocumentID {
            items["endkey_docid"] = "\(endKeyDocId)"
        }
        
        if let inclusiveEnd = inclusiveEnd {
            items["inclusive_end"] = "\(inclusiveEnd)"
        }
        
        if let limit = limit {
            items["limit"] = "\(limit)"
        }
        
        if let skip = skip {
            items["skip"] = "\(skip)"
        }
        
        if let includeDocs = includeDocs {
            items["include_docs"] = "\(includeDocs)"
        }
        
        if let stale = stale {
            items["stale"] = "\(stale)"
        }
        
        if let conflicts = conflicts {
            items["conflicts"] = "\(conflicts)"
        }
        
        if let includeLastUpdateSequenceNumber = includeLastUpdateSequenceNumber {
            items["update_seq"] = "\(includeLastUpdateSequenceNumber)"
        }
        
        return items
    }
    
    func jsonValue(for key: Any) throws -> String {
        if JSONSerialization.isValidJSONObject(key) {
            let keyJson = try JSONSerialization.data(withJSONObject: key)
            return String(data: keyJson, encoding: .utf8)!
        } else if key is String {
            // we need to quote JSON primitive strings
            return "\"\(key)\""
        } else {
            // anything else we just try as stringified JSON value
            return "\(key)"
        }
    }
}
