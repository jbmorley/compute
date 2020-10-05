//
//  ActionMenu.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

struct ActionMenu<Content: View>: View {

    var content: () -> Content

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            content()
        }
    }

    @inlinable public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

}
