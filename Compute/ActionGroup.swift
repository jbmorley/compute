//
//  ActionGroup.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

struct ActionGroup<Content: View, Footer: View>: View {

    var content: () -> Content
    var footer: Footer? = nil

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center, spacing: 4) {
                content()
            }
            footer
            .font(.footnote)
            .foregroundColor(Color.secondary)
        }
    }

    @inlinable public init(footer: Footer? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.footer = footer
        self.content = content
    }

}
