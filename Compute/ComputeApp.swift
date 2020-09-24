//
//  ComputeApp.swift
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

class Manager: ObservableObject {

    var address: String?
    var server = Server()
    let documentsDirectory = UIApplication.shared.documentsUrl
    let bookmarksDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("bookmarks")
    let rootDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("root")

    var locations: [URL] {
        let locations = try? FileManager.default.contentsOfDirectory(at: bookmarksDirectory,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [.skipsHiddenFiles])
        return locations ?? []
    }

    init() {
        do {
            try start()
        } catch {
            print("Failed to start server with error \(error)")
        }
    }

    func start() throws {
        UIApplication.shared.isIdleTimerDisabled = true
        address = UIDevice.current.address
        let fileManager = FileManager.default
        try fileManager.ensureDirectoryExists(at: bookmarksDirectory)
        try fileManager.ensureDirectoryExists(at: rootDirectory)
        try fileManager.emptyDirectory(at: rootDirectory)
        try linkLocations()
        try server.start(root: rootDirectory)
        print("Listening on http://\(address ?? "unknown"):8080...")
    }

    /**
    Link all the locations to the root of the WebDAV server.
    */
    func linkLocations() throws {
        let locations = self.locations
        for location in locations {
            let resolvedLocation = try URL.resolveBookmark(at: location)
            let basename = resolvedLocation.lastPathComponent
            try FileManager.default.createSymbolicLink(at: rootDirectory.appendingPathComponent(basename),
                                                       withDestinationURL: resolvedLocation)
        }
    }

    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
        server.stop()
    }

    func addLocation(_ location: URL) throws {
        self.objectWillChange.send()
        try location.prepareForSecureAccess()
        let uuid = NSUUID().uuidString
        let bookmarkUrl = bookmarksDirectory.appendingPathComponent(uuid)
        let bookmarkData = try location.bookmarkData(options: .suitableForBookmarkFile,
                                                     includingResourceValuesForKeys: nil, relativeTo: nil)
        try URL.writeBookmarkData(bookmarkData, to: bookmarkUrl)
    }

    func removeLocation(_ location: URL) throws {
        self.objectWillChange.send()
        try FileManager.default.removeItem(at: location)
    }

}

@main
struct ComputeApp: App {

    var manager = Manager()

    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
        }
    }
}
