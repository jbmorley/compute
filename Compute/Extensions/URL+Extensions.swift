//
//  URL+Utilities.swift
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

enum URLAccessError: Error {
    case bookmarkCreationFailure
    case notReadable
}

extension URL {

    static func resolveBookmark(at url: URL) throws -> URL {
        var isStale = false
        let bookmarkData = try URL.bookmarkData(withContentsOf: url)
        let url = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
        try url.prepareForSecureAccess()
        return url
    }

    func prepareForSecureAccess() throws {
        guard startAccessingSecurityScopedResource() else {
            throw URLAccessError.bookmarkCreationFailure
        }
        guard FileManager.default.isReadableFile(atPath: path) else {
            throw URLAccessError.notReadable
        }
    }

    public var lastPathComponent: String {
        assert(self.isFileURL)
        return (self.path as NSString).lastPathComponent
    }

}
