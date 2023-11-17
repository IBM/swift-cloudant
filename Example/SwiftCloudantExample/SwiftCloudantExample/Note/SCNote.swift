//
//	SCNote.swift
//  
//  SwiftCloudant
//
//  Created by Dan Burkhardt on 11/2/23.
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
import SwiftCloudant

struct SCNote: SCStorableObject {
    var title: String
    var body: String
    var created: Int
    var lastUpdated: Int?
    var createdBy: String
    var lastUpdatedBy: String?
    
    func getJsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}