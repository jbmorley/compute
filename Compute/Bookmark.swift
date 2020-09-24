//
//  Bookmark.swift
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

import Foundation

enum BookmarkError: Error {
    case invalidIdentifier
}

class Bookmark: Identifiable, Equatable {

    static func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
        return lhs.id == rhs.id
    }

    let id: UUID
    let source: URL
    let destination: URL
    var name: String { destination.lastPathComponent }

    init(root: URL, destination: URL) throws {
        id = UUID()
        self.source = root.appendingPathComponent(id.uuidString)
        self.destination = destination
        try destination.prepareForSecureAccess()
    }

    init(source: URL) throws {
        guard let id = UUID(uuidString: source.lastPathComponent) else {
            throw BookmarkError.invalidIdentifier
        }
        self.id = id
        self.source = source
        self.destination = try URL.resolveBookmark(at: source)
    }

    func write() throws {
        let bookmarkData = try destination.bookmarkData(options: .suitableForBookmarkFile,
                                                        includingResourceValuesForKeys: nil,
                                                        relativeTo: nil)
        try URL.writeBookmarkData(bookmarkData, to: source)
    }

    func link(root: URL) throws {
        try FileManager.default.createSymbolicLink(at: root.appendingPathComponent(name),
                                                   withDestinationURL: destination)
    }

    func unlink(root: URL) throws {
        try FileManager.default.removeItem(at: root.appendingPathComponent(name))
    }

}
