//
//  LogView.swift
//  Compute
//
//  Created by Jason Barrie Morley on 29/09/2020.
//

import SwiftUI

struct LogView: View {

    @ObservedObject var log: Log

    var body: some View {
        List {
            ForEach(log.events.reversed()) { event in
                Text(event.description)
            }
        }
        .navigationBarTitle("Logs", displayMode: .inline)
    }

}
