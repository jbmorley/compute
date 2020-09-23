//
//  ContentView.swift
//  Compute
//
//  Created by Jason Barrie Morley on 22/09/2020.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var manager: Manager

    var body: some View {
        Text(manager.address ?? "")
            .padding()
    }
}
