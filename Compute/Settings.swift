//
//  Settings.swift
//  Compute
//
//  Created by Jason Barrie Morley on 05/10/2020.
//

import SwiftUI

class Settings: ObservableObject {

    static let blinkUrlKey = "blink-url-key"
    static let blinkUsesMosh = "blink-uses-mosh"

    @AppStorage(Settings.blinkUrlKey) var blinkUrlKey: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }

    @AppStorage(Settings.blinkUsesMosh) var blinkUsesMosh: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
}
