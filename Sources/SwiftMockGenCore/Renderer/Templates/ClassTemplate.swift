//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

func applyClassTemplate(name: String,
                        identifier: String,
                        accessControlLevelDescription: String,
                        attribute: String,
                        initParams: [VariableModel],
                        entities: [String]) -> String {
    
    let params = initParams
        .map { (element: VariableModel) -> String in
            if let val = processDefaultVal(typeName: element.type), !val.isEmpty {
                return "\(element.name): \(element.type) = \(val)"
            }
            
            var prefix = ""
            if element.isClosureVariable {
                prefix = String.escaping + " "
            }
            return "\(element.name): \(prefix)\(element.type)"
        }
        .joined(separator: ", ")
    // Besides the default init, we want to provide an empty init block (unless the default init is empty)
    // since vars do not need to be set via init (since they all have get/set; see VariableTemplate for more detail)
    let extraInitBlock = !initParams.isEmpty ? "\(accessControlLevelDescription)init() {}" : ""
    let paramsAssign = initParams.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n")
    let result = """
    \(attribute)
    \(accessControlLevelDescription)class \(name): \(identifier) {
        \(extraInitBlock)
        \(accessControlLevelDescription)init(\(params)) {
            \(paramsAssign)
        }
        \(entities.joined(separator: "\n"))
    }
    """
    return result
}
