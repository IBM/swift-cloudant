//
//  RequestBuilder.swift
//  SwiftCloudant
//
//  Created by Rhys Short on 03/03/2016.
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
 A class which builds `NSURLRequest` objects from `HTTPRequestOperation` objects.
 */
class OperationRequestBuilder {

    enum Error: Swift.Error {
        case URLGenerationFailed
    }

    /**
     The operation this builder will turn into a HTTP object.
     */
    let operation: HTTPRequestOperation

    /**
     Creates an OperationRequestBuilder instance.

     - parameter operation: the operation that the request will be built from.
     */
    init(operation: HTTPRequestOperation) {
        self.operation = operation
    }

    /**
     Builds the NSURLRequest from the operation in the property `operation`
     */
    func makeRequest() throws -> URLRequest {
        guard let components = NSURLComponents(url: operation.rootURL, resolvingAgainstBaseURL: false)
        else {
            throw Error.URLGenerationFailed
        }

        var path = ""
        if let subPath = components.path {
            path = "\(subPath)\(operation.httpPath)"
        } else {
            path = operation.httpPath
        }
        components.path = path
        var queryItems: [URLQueryItem] = []

        if let _ = components.queryItems {
            queryItems.append(contentsOf: components.queryItems!)
        }
        
        queryItems.append(contentsOf: operation.queryItems)
        components.queryItems = queryItems

        guard let url = components.url
        else {
            throw Error.URLGenerationFailed
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = CouchDBClient.defaultConfig.clientTimeoutInterval
        request.httpMethod = operation.httpMethod

        if let body = operation.httpRequestBody {
            request.httpBody = body
            request.setValue(operation.httpContentType, forHTTPHeaderField: "Content-Type")
        }

        return request
    }

}
