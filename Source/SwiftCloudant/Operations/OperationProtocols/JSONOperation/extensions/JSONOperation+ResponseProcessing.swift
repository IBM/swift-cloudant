//
//  JSONOperation+ResponseProcessing.swift
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

public extension JSONOperation {
    
    func callCompletionHandler(response: Any?, httpInfo: HTTPInfo?, error: Swift.Error?) {
        self.completionHandler?(response as? Json, httpInfo, error)
    }
    
    func processResponse(data: Data?, httpInfo: HTTPInfo?, error: Swift.Error?) {
        guard error == nil, let httpInfo = httpInfo
            else {
                self.callCompletionHandler(error: error!)
                return
        }
        
        do {
            if let data = data {
                let json = try JSONSerialization.jsonObject(with: data)
                if httpInfo.statusCode / 100 == 2 {
                    self.processResponse(json: json)
                    self.callCompletionHandler(response: json, httpInfo: httpInfo, error: error)
                } else {
                    let error = Operation.Error.http(statusCode: httpInfo.statusCode,
                                            response: String(data: data, encoding: .utf8))
                    self.callCompletionHandler(response: json, httpInfo: httpInfo, error: error as Error)
                }
            } else {
                let error = Operation.Error.http(statusCode: httpInfo.statusCode, response: nil)
                self.callCompletionHandler(response: nil, httpInfo: httpInfo, error: error as Error)
            }
        } catch {
            let response: String?
            if let data = data {
                response = String(data: data, encoding: .utf8)
            } else {
                response = nil
            }
            let error = Operation.Error.unexpectedJSONFormat(statusCode: httpInfo.statusCode, response: response)
            self.callCompletionHandler(response: nil, httpInfo: httpInfo, error: error as Error)
        }
    }
}
