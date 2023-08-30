//
//	Sort.swift
//  
//  SwiftCloudant
//
//  Created by Jason Swann` on 8/30/23.
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
 Specfies how a field should be sorted
 */
public struct Sort {
    
    /**
     The direction of Sorting
     */
    public enum Direction: String {
        /**
         Sort ascending
         */
        case asc = "asc"
        /**
         Sort descending
         */
        case desc = "desc"
    }

    /**
     The field on which to sort
     */
    public let field: String
    
    /**
     The direction in which to sort.
     */
    public let sort: Direction?
  
    public init(field: String, sort: Direction?) {
        self.field = field
        self.sort = sort
    }
}
