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

import Combine
import Foundation
import SwiftUI

@propertyWrapper public struct ModalPublished<Value: Equatable> {
    private let identifier = UUID()
    private var value: Value
    private let context: ModalPresentationContext

    public static subscript<T: ObservableObject>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].value
        }
        set {
            guard let publisher = instance.objectWillChange as? ObservableObjectPublisher else { return }

            let modalPresentationState = ModalPresentationRegistery.shared
            let identifier = instance[keyPath: storageKeyPath].identifier
            let context = instance[keyPath: storageKeyPath].context

            if isTrueValue(value: newValue) {
                modalPresentationState.openModal(
                    identifier: identifier,
                    context: context
                ) {
                    if (instance[keyPath: storageKeyPath].value as? Bool) != nil {
                        instance[keyPath: storageKeyPath].value = false as! Value
                    } else {
                        // Value is Optional<Value> so we cast it to Optional<Any> to pass a nil value to close the sheet
                        instance[keyPath: storageKeyPath].value = Any?(nilLiteral: ()) as! Value
                    }
                    publisher.send()
                } completion: {
                    instance[keyPath: storageKeyPath].value = newValue
                    publisher.send()
                }
            } else {
                modalPresentationState.closeModal(identifier: identifier, context: context)
                instance[keyPath: storageKeyPath].value = newValue
                publisher.send()
            }
        }
    }

    @available(*, unavailable,
               message: "@Published can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public init(wrappedValue: Value, context: ModalPresentationContext = "Shared") {
        value = wrappedValue
        self.context = context
    }
}
