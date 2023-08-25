//
//  OperationProtocols.swift
//
//  SwiftCloudant
//
//  Created by Rhys Short on 06/06/2016.
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
 Marks an operation as a Data Only operation. It will provide the data directly from the database.
 */
public protocol DataOperation: CouchOperation {
    
    /**
     Sets a completion handler to run when the operation completes.
     
     - parameter response: - The full data received from the server.
     - parameter httpInfo: - Information about the HTTP response.
     - parameter error: - ErrorProtocol instance with information about an error executing the operation.
     */
    var completionHandler: ((Data?, HTTPInfo?, Swift.Error?) -> Void)? { get }
}
