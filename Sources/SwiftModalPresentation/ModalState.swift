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
import SwiftUI

@propertyWrapper public struct ModalState<Value>: DynamicProperty {
    private let modalPresentationState = ModalPresentationRegistery.shared

    private let identifier = UUID()
    @State private var value: Value
    private let context: ModalPresentationContext

    public var wrappedValue: Value {
        get {
            value
        }
        nonmutating set {
            if isTrueValue(value: newValue) {
                modalPresentationState.openModal(identifier: identifier, context: context) {
                    if (value as? Bool) != nil {
                        value = false as! Value
                    } else {
                        // Value is Optional<Value> so we cast it to Optional<Any> to pass a nil value to close the sheet
                        value = Any?(nilLiteral: ()) as! Value
                    }
                } completion: {
                    value = newValue
                }
            } else {
                modalPresentationState.closeModal(identifier: identifier, context: context)
                value = newValue
            }
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: {
                wrappedValue
            },
            set: {
                wrappedValue = $0
            }
        )
    }

    public init(wrappedValue: Value, context: ModalPresentationContext = "Shared") {
        value = wrappedValue
        self.context = context
    }
}
