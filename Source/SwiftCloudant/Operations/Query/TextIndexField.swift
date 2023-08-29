//
//  TextIndexField.swift
// 
//  SwiftCloudant
//
//  Created by Emily Doran on 8/28/23.
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
  A struct to represent a field in a Text index.
 */
public struct TextIndexField {
    
    /**
     The data types for a field in a Text index.
     */
    public enum `Type` : String {
        /**
         A Boolean data type.
         */
        case boolean = "boolean"
        /**
         A String data type.
         */
        case string = "string"
        /**
         A Number data type.
         */
        case number =  "number"
    }
    
    /**
     The name of the field
    */
    public let name: String
    /**
     The type of field.
     */
    public let type: Type
  
    public init(name: String, type: Type) {
        self.name = name
        self.type = type
    }
}
