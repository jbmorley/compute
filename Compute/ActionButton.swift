//
//  ActionButton.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

struct ActionButton: View {

    var text: String
    var systemName: String
    var action: () -> Void

    init(_ text: String, systemName: String, action: @escaping () -> Void) {
        self.text = text
        self.systemName = systemName
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text).bold()
                Spacer()
                Image(systemName: systemName)
                    .imageScale(.medium)
                    .frame(width: 16, height: 16, alignment: .center)
            }
        }
    }

}
