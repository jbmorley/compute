//
//  Manager.swift
//  Compute
//
//  Created by Jason Barrie Morley on 28/09/2020.
//

import Foundation
import SwiftUI

class Manager: ObservableObject {

    var address: String?
    var log: Log
    var server: WebDAVServer
    var bluetoothManager: BluetoothManager
    var bookmarks: [Bookmark] = []
    let documentsDirectory = UIApplication.shared.documentsUrl
    let bookmarksDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("bookmarks")
    let rootDirectory = UIApplication.shared.documentsUrl.appendingPathComponent("root")

    init() {
        log = Log()
        server = WebDAVServer()
        bluetoothManager = BluetoothManager(log: log)
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

        for bookmark in bookmarks {
            try bookmark.link(root: rootDirectory)
        }

        try server.start(root: rootDirectory)
        log.info(message: "listening on http://\(address ?? "unknown"):8080...")

        log.info(message: "starting bluetooth manager")
        bluetoothManager.start()
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
