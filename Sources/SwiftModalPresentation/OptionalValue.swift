//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.

import Foundation

protocol OptionalValue {
    var isNil: Bool { get }
}

extension Optional: OptionalValue {
    var isNil: Bool {
        return self == nil
    }
}

func isTrueValue<Value>(value: Value) -> Bool {
    if let boolValue = (value as? Bool) {
        return boolValue
    } else if let maybeOptionalValue = (value as? OptionalValue) {
        return !maybeOptionalValue.isNil
    }
    return false
}
