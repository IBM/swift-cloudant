//
//  URLSessionTask.swft
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 8/29/23.
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
 A class which encapsulates HTTP requests. This class allows requests to be transparently retried.
 */
internal class URLSessionTask {
    internal let request: URLRequest
    internal var inProgressTask: URLSessionDataTask
    internal let session: URLSession
    internal var remainingRetries: UInt = 10
    internal var remainingBackOffRetries: UInt = 3
    internal let delegate: InterceptableSessionDelegate
    
    //This  is for caching before delivering the response to the delegate in the event a 401/403 is
    // encountered.
    internal var response: HTTPURLResponse? = nil
    // Caching of the data before being delivered to the delegate in the event of a 401/403 response.
    internal var data: Data? = nil

    public var state: Foundation.URLSessionTask.State {
        get {
            return inProgressTask.state
        }
    }

    /**
     Creates a URLSessionTask object
     - parameter session: the NSURLSession it should use when making HTTP requests.
     - parameter request: the HTTP request to make
     - parameter inProgressTask: The NSURLSessionDataTask that is performing the request in NSURLSession.
     - parameter delegate: The delegate for this task.
     */
    init(session: URLSession, request: URLRequest, inProgressTask:URLSessionDataTask, delegate: InterceptableSessionDelegate) {
        
        self.request = request
        self.session = session
        self.delegate = delegate
        self.inProgressTask = inProgressTask
    }

    /**
     Resumes a suspended task
     */
    public func resume() {
        inProgressTask.resume()
    }

    /**
     Cancels the task.
     */
    public func cancel() {
        inProgressTask.cancel()
    }
}
