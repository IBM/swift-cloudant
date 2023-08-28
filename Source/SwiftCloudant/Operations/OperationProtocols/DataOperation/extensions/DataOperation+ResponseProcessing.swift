//
//  DataOperation+ResponseProcessing.swift
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

public extension DataOperation {
    func callCompletionHandler(response: Any?, httpInfo: HTTPInfo?, error: Swift.Error?) {
        self.completionHandler?(response as? Data, httpInfo, error)
    }
    
    func processResponse(data: Data?, httpInfo: HTTPInfo?, error: Swift.Error?) {
        guard error == nil, let httpInfo = httpInfo
            else {
                self.callCompletionHandler(error: error!)
                return
        }
        if httpInfo.statusCode / 100 == 2 {
            self.completionHandler?(data, httpInfo, error)
        } else {
            self.completionHandler?(data, httpInfo, Operation.Error.http(statusCode: httpInfo.statusCode, response: String(data: data!, encoding: .utf8)))
        }
    }
}
