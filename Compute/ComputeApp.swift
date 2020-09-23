//
//  ComputeApp.swift
//  Compute
//
// Copyright (c) 2020 Jason Morley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import SwiftUI

func getIPAddress() -> String? {
       var address: String?
       var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
       if getifaddrs(&ifaddr) == 0 {
           var ptr = ifaddr
           while ptr != nil {
               defer { ptr = ptr?.pointee.ifa_next }

               let interface = ptr?.pointee
               let addrFamily = interface?.ifa_addr.pointee.sa_family
               if addrFamily == UInt8(AF_INET) /* || addrFamily == UInt8(AF_INET6) */ {

                     if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {
                       var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                       getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                       address = String(cString: hostname)
                    }
               }
           }
           freeifaddrs(ifaddr)
       }
        return address
   }

//// Return IP address of WiFi interface (en0) as a String, or `nil`
//func getWiFiAddress() -> String? {
//    var address : String?
//
//    // Get list of all interfaces on the local machine:
//    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//    if getifaddrs(&ifaddr) == 0 {
//
//        // For each interface ...
//        var ptr = ifaddr
//        while ptr != nil {
//            defer { ptr = ptr?.pointee.ifa_next }
//
//            let interface = ptr?.pointee
//
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface?.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // Check interface name:
//                if let name = String.fromCString(interface.ifa_name) where name == "en0" {
//
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.memory.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String.fromCString(hostname)
//                }
//            }
//        }
//        freeifaddrs(ifaddr)
//    }
//
//    return address
//}

class Server {

    var server: HTTPServer

    init() {

        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentsURL = URL(string: documentsDirectory)!
        let folderURL = documentsURL.appendingPathComponent("Folder")
        do {
            try FileManager.default.createDirectory(atPath: folderURL.absoluteString,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            print("Failed to create directory with error \(error)")
        }

        server = HTTPServer()
        server.setConnectionClass(DAVConnection.self)
        server.setPort(8080)
        server.setType("_http._tcp.")
        server.setDocumentRoot(documentsDirectory)

        if let address = getIPAddress() {
            print("IP address = \(address)")
        }

        do {
            try server.start()
            print("Successfully started server!")
        } catch {
            print("Failed to start server with error \(error)")
        }
    }

}

class Manager: ObservableObject {

    var address: String?

    init() {
        start()
    }

    func start() {
        UIApplication.shared.isIdleTimerDisabled = true
        address = getIPAddress()
    }

    func stop() {
        UIApplication.shared.isIdleTimerDisabled = false
    }

}

@main
struct ComputeApp: App {

    var controller = Server()
    var manager = Manager()

    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
        }
    }
}
