//
//  Log.swift
//  Compute
//
//  Created by Jason Barrie Morley on 29/09/2020.
//

import SwiftUI

class Log: ObservableObject {

    enum Level: Int, CustomStringConvertible {
        case debug = 0
        case info = 1
        case warning = 2
        case error = 3

        var description: String {
            switch self {
            case .debug:
                return "debug"
            case .info:
                return "info"
            case .warning:
                return "warning"
            case .error:
                return "error"
            }
        }

    }

    class Event: Identifiable, CustomStringConvertible {

        let id = UUID()
        let date = Date()
        let level: Level
        let message: String

        init(level: Level, message: String) {
            self.level = level
            self.message = message
        }

        var description: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY:mm:dd HH:MM:ss"
            return "\(dateFormatter.string(from: date)) [\(level)] \(message)"
        }

    }

    var events: [Event] = []

    func log(level: Level, message: String) {
        self.objectWillChange.send()
        let event = Event(level: level, message: message)
        events.append(event)
        print(event.description)
    }

    func debug(message: String) {
        log(level: .debug, message: message)
    }

    func info(message: String) {
        log(level: .info, message: message)
    }

    func warning(message: String) {
        log(level: .warning, message: message)
    }

    func error(message: String) {
        log(level: .error, message: message)
    }

}
