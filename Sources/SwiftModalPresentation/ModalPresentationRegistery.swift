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

public typealias ModalPresentationContext = String

struct PresentedModal {
    let identifier: UUID
    let closeCallback: () -> Void
}

class ModalPresentationRegistery {
    static let shared = ModalPresentationRegistery()

    private static var modalCloseDelay: DispatchTime {
        DispatchTime.now() + 0.25
    }

    private var presentedModalForContext = [ModalPresentationContext: PresentedModal]()

    func openModal(
        identifier: UUID,
        context: ModalPresentationContext,
        closeCallback: @escaping () -> Void,
        completion: @escaping () -> Void
    ) {
        if presentedModalForContext[context] == nil {
            presentedModalForContext[context] = PresentedModal(identifier: identifier, closeCallback: closeCallback)
            completion()
        } else {
            presentedModalForContext[context]?.closeCallback()

            /* We need some delay to allow the sheet to close. This is hacky but the only other solution is to do a custom .sheet
             and listen for onDismiss */
            DispatchQueue.main.asyncAfter(deadline: ModalPresentationRegistery.modalCloseDelay) { [weak self] in
                self?.presentedModalForContext[context] = PresentedModal(identifier: identifier, closeCallback: closeCallback)
                completion()
            }
        }
    }

    func closeModal(identifier: UUID, context: ModalPresentationContext) {
        guard presentedModalForContext[context]?.identifier == identifier else { return }

        presentedModalForContext[context] = nil
    }
}
