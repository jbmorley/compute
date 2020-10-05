//
//  ContentView.swift
//  Compute
//
//  Copyright (c) 2020 Jason Morley
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SwiftUI

struct ContentView: View {

    enum SheetType {
        case settings
        case status
    }


    @ObservedObject var manager: Manager
    @ObservedObject var bluetooth: BluetoothManager
    @State var sheet: SheetType?

    init(manager: Manager) {
        self.manager = manager
        self.bluetooth = manager.bluetoothManager
    }

    func sheet(sheet: SheetType) -> some View {
        switch sheet {
        case .settings:
            return SettingsView(manager: manager)
                .eraseToAnyView()
        case .status:
            return StatusView(manager: manager)
                .eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                EmptyView()
            }
            .navigationTitle("Compute")
            .navigationBarItems(leading: Button("Settings") {
                sheet = .settings
            }, trailing: Button("Status") {
                sheet = .status
            })
            .sheet(item: $sheet, content: self.sheet)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ContentView.SheetType: Identifiable {
    public var id: ContentView.SheetType { self }
}
