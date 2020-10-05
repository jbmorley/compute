//
//  StatusView.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

struct StatusView: View {

    @ObservedObject var manager: Manager
    @ObservedObject var bluetooth: BluetoothManager

    @State var isShowingLogs = false

    init(manager: Manager) {
        self.manager = manager
        self.bluetooth = manager.bluetoothManager
    }

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
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
                Section(header: Text("Debug")) {
                    NavigationLink("Logs", destination: LogView(log: manager.log), isActive: $isShowingLogs)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Status", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
                    .fontWeight(.regular)
            }))
        }
    }

}
