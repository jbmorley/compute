//
//  FileManager+Extensions.swift
//  Compute
//
//  Created by Jason Barrie Morley on 24/09/2020.
//

import Foundation

extension FileManager {

    func ensureDirectoryExists(at url: URL) throws {
        if !fileExists(atPath: url.path) {
            print("Creating directory '\(url.path)'...")
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func emptyDirectory(at url: URL) throws {
        for location in try contentsOfDirectory(atPath: url.path) {
            try removeItem(at: url.appendingPathComponent(location))
        }
    }

}
