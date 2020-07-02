//
//  Binding+Change.swift
//  myMood
//
//  Created by Marc Hein on 02.07.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
