//
//  SettingsView.swift
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
import UniformTypeIdentifiers

extension URL: Identifiable {

    public var lastPathComponent: String {
        assert(self.isFileURL)
        return (self.path as NSString).lastPathComponent
    }

    public var id: URL {
        return self
    }
}

enum SettingsSheet {
    case filePicker
}

extension SettingsSheet: Identifiable {
    public var id: SettingsSheet { self }
}

struct SettingsView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var manager: Manager
    @State var sheet: SettingsSheet?
    @State var url: URL?

    func sheet(sheet: SettingsSheet) -> some View {
        switch sheet {
        case .filePicker:
            return FilePickerView(contentTypes: [.folder]) { url in
                do {
                    try manager.addLocation(url)
                } catch {
                    print("Failed to save location with error \(error)")
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Locations")) {
                    ForEach(manager.locations) { location in
                        HStack {
                            Text(location.lastPathComponent)
                        }
                    }
                    .onDelete { indexSet in
                        do {
                            let locations = self.manager.locations
                            let locationsToDelete = indexSet.compactMap { index in
                                return locations[index]
                            }
                            try locationsToDelete.forEach { location in
                                try self.manager.removeLocation(location)
                            }
                        } catch {
                            print("Failed to remove location with error \(error)")
                        }
                    }
                    Button("Add Location...") {
                        sheet = .filePicker
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done", action: {
                presentationMode.wrappedValue.dismiss()
            }))
            .sheet(item: $sheet, content: sheet)
        }
    }

}
