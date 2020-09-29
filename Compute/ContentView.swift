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

enum Sheet {
    case settings
    case logs
}

extension Sheet: Identifiable {
    public var id: Sheet { self }
}

struct ContentView: View {

    @ObservedObject var manager: Manager
    @ObservedObject var bluetooth: BluetoothManager
    @State var sheet: Sheet?

    init(manager: Manager) {
        self.manager = manager
        self.bluetooth = manager.bluetoothManager
    }

    func sheet(sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return SettingsView(manager: manager)
                .eraseToAnyView()
        case .logs:
            return LogView(log: manager.log)
                .eraseToAnyView()
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("WebDAV")) {
                        HStack {
                            Text("Address")
                            Spacer()
                            Text("http://\(manager.address ?? "unknown"):8080")
                        }
                    }
                    Section(header: Text("Bluetooth")) {
                        HStack {
                            Text("Status")
                            Spacer()
                            Text(bluetooth.state.description)
                        }
                        HStack {
                            Text("Scanning")
                            Spacer()
                            Text(bluetooth.isScanning ? "True" : "False")
                        }
                        HStack {
                            Text("Devices")
                            Spacer()
                            Text("Found \(bluetooth.peripherals.count)")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Compute")
            .navigationBarItems(leading: Button("Settings") {
                sheet = .settings
            }, trailing: Button("Logs") {
                sheet = .logs
            })
            .sheet(item: $sheet, content: self.sheet)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
