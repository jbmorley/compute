//
//  ContentView.swift
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

enum Sheet {
    case settings
}

extension Sheet: Identifiable {
    public var id: Sheet { self }
}

struct ContentView: View {

    @ObservedObject var manager: Manager
    @State var sheet: Sheet?

    func sheet(sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return SettingsView(manager: manager)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("http://\(manager.address ?? "unknown"):8080")
                    .padding()
                Spacer()
            }
            .navigationTitle("Compute")
            .navigationBarItems(leading: Button("Settings", action: {
                sheet = .settings
            }))
            .sheet(item: $sheet, content: self.sheet)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
