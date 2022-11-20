//
//  BrowserForDolphinApp.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import SwiftUI
import AppKit

@main
struct BrowserForDolphinApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.openWindow) private var openWindow
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commandsReplaced {
            CommandGroup(replacing: .help) {
                Button("Show Help") {
                    openWindow(id: "help")
                }
            }
        }
        
        Window("Help", id: "help") {
            HelpView()
                .frame(minWidth: 500, maxWidth: 500)
        }
        
        Settings {
            SettingsView()
        }
    }
    
    init() {
        UserDefaults.standard.register()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
