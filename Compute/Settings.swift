//
//  Settings.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

class Settings: ObservableObject {

    static let blinkUrlKey = "blink-url-key"

    @AppStorage(Settings.blinkUrlKey) var blinkUrlKey: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    
}
