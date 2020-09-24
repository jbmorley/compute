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

    lazy var server: Server = {
        return Server(root: documentsUrl())
    }()

    var locations: [URL] {
        return (try? FileManager.default.contentsOfDirectory(at: documentsUrl(), includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])) ?? []
    }

    func documentsUrl() -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documentsDirectory)
    }

    init() {
        start()
    }

    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        address = UIDevice.current.address
        do {
            try server.start()
            print("Listening on http://\(address ?? "unknown"):8080...")
        } catch {
            print("Failed to start server with error \(error)")
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
        let bookmarkUrl = documentsUrl().appendingPathComponent(uuid)
        let bookmarkData = try location.bookmarkData(options: .suitableForBookmarkFile, includingResourceValuesForKeys: nil, relativeTo: nil)
        try URL.writeBookmarkData(bookmarkData, to: bookmarkUrl)
        let symlinkUrl = documentsUrl().appendingPathComponent("\(uuid)-symlink")
        try FileManager.default.createSymbolicLink(at: symlinkUrl, withDestinationURL: location)
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
