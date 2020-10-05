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
    @ObservedObject var settings: Settings

    func sheet(sheet: SettingsSheet) -> some View {
        switch sheet {
        case .filePicker:
            return FilePickerView(contentTypes: [.folder]) { destination in
                do {
                    try manager.addBookmark(to: destination)
                } catch {
                    manager.log.error(message: "failed to add bookmark with error \(error)")
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bookmarks")) {
                    ForEach(manager.bookmarks) { bookmark in
                        Text(bookmark.name)
                    }
                    .onDelete { indexSet in
                        do {
                            let bookmarksToDelete = indexSet.compactMap { index in
                                return self.manager.bookmarks[index]
                            }
                            try bookmarksToDelete.forEach { bookmark in
                                try self.manager.removeBookmark(bookmark)
                            }
                        } catch {
                            manager.log.error(message: "failed to remove bookmark with error \(error)")
                        }
                    }
                    Button("Add Location...") {
                        sheet = .filePicker
                    }
                }
                Section(header: Text("Blink Integration")) {
                    TextField("URL Key", text: $settings.blinkUrlKey)
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
