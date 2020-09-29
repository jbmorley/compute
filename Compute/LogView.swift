//
//  LogView.swift
//  Compute
//
//  Created by Jason Barrie Morley on 29/09/2020.
//

import SwiftUI

struct LogView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var log: Log

    var body: some View {
        NavigationView {
            List {
                ForEach(log.events.reversed()) { event in
                    Text(event.description)
                }
            }
            .navigationBarTitle("Logs", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

}
