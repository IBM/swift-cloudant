//
//  ViewLikeOperation.swift
//  SwiftCloudant
//
//  Created by Rhys Short on 06/07/2016.
//
//  Copyright © 2016, 2019 IBM Corp. All rights reserved.
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
 Denotes an operation that performs actions on a view.
 Some operations are not strictly a view externally, but internally
 they are effectively a view and have similar parameters.
 */
public protocol ViewOperation : CouchDatabaseOperation {
    associatedtype ViewParameter
    
    /**
     Should the result rows be returning in `descending by key` order for this request.
     
     - `true` if the result rows should be returned in `descending by key` order
     - `false` if the result rows should **not** be ordered in `descending by key` order
     - `nil` no preference, server defaults will apply.
     */
    var descending: Bool? { get }
    
    /**
     The key from which result rows should start from.
     */
    var startKey: ViewParameter? { get }
    
    /**
     Used in conjunction with startKey to further restrict the starting row for
     cases where two documents emit the same key. Specifying the doc ID allows
     the view to return result rows from the specified start key and document.
     */
    var startKeyDocumentID: String? { get }
    
    /**
     Stop the view returning result rows when the specified key is reached.
     */
    var endKey: ViewParameter? { get }
    
    /**
     Used in conjunction with endKey to further restrict the ending row for cases
     where two documents emit the same key. Specifying the doc ID allows the view
     to return result rows up to the specified end key and document.
     */
    var endKeyDocumentID: String? { get }
    
    /**
     Include result rows with the specified `endKey`.
     */
    var inclusiveEnd: Bool? { get }
    
    /**
     Return only result rows that match the specified key.
     */
    var key: ViewParameter? { get }
    
    /**
     Return only result rows that match the specified keys.
     */
    var keys: [ViewParameter]? { get }
    
    /**
     Limit the number of result rows returned from the view.
     */
    var limit: UInt? { get }
    
    /**
     The number of rows to skip in the view results.
     */
    var skip: UInt? { get }
    
    /**
     Include the full content of documents in the view results.
     */
    var includeDocs: Bool? { get }
    
    /**
     Include informaion about conflicted revisions in the response.
     */
    var conflicts: Bool? { get }
    
    /**
     Configures the view request to allow the return of stale results. This allows the view to return
     immediately rather than waiting for the view index to build. When this parameter is omitted (i.e. with the 
     default of `stale=nil`) the server will not return stale results.
     
     - SeeAlso: `Stale` for descriptions of the available values for allowing stale views.
     */
    var stale: Stale? { get }
    
    /**
     Determines if the last seqeunce number from which the view was updated should be included in 
     the response
     */
    var includeLastUpdateSequenceNumber: Bool? { get }
    
    /**
     A handler to run for each row retrieved by the view.
     
     - parameter row: dictionary of the JSON data from the view row
     */
    var rowHandler: (([String: Any]) -> Void)? { get }
    
}
