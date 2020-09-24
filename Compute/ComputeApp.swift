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
    var bookmarks: [Bookmark] = []
    let documentsDirectory = UIApplication.shared.documentsUrl
    let bookmarksDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("bookmarks")
    let rootDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("root")

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

        bookmarks = try fileManager.contentsOfDirectory(atPath: bookmarksDirectory.path)
            .map { try Bookmark(source: bookmarksDirectory.appendingPathComponent($0)) }

        // Link the bookmarks to the WebDAV server root.
        for bookmark in bookmarks {
            try bookmark.link(root: rootDirectory)
        }

        try server.start(root: rootDirectory)
        print("Listening on http://\(address ?? "unknown"):8080...")
    }

    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
        server.stop()
    }

    func addBookmark(to destination: URL) throws {
        self.objectWillChange.send()
        let bookmark = try Bookmark(root: bookmarksDirectory, destination: destination)
        try bookmark.write()
        try bookmark.link(root: rootDirectory)
        bookmarks.append(bookmark)
    }

    func removeBookmark(_ bookmark: Bookmark) throws {
        self.objectWillChange.send()
        try bookmark.unlink(root: rootDirectory)
        try FileManager.default.removeItem(at: bookmark.source)
        bookmarks.removeAll { $0 == bookmark }
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
