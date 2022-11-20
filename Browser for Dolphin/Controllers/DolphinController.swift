//
//  DolphinController.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import AppKit

final class DolphinController {
    
    static let shared = DolphinController()
    
    weak var viewModel: ViewModel?
    
    private let dolphinBundleID = "org.dolphin-emu.dolphin"
    private var recentlyLaunchedGame = false
    
    var dolphinApp: NSRunningApplication? {
        NSWorkspace.shared.runningApplications.first(where: { $0.bundleIdentifier == dolphinBundleID })
    }
    var dolphinIsRunning: Bool {
        dolphinApp != nil && dolphinApp?.isTerminated != true
    }
    
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didLaunchApplicationNotification, object: nil, queue: nil) { notification in
            let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
            if app?.bundleIdentifier == self.dolphinBundleID {
                self.viewModel?.objectWillChange.send()
            }
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didTerminateApplicationNotification, object: nil, queue: nil) { notification in
            let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
            if app?.bundleIdentifier == self.dolphinBundleID {
                NSApplication.shared.activate(ignoringOtherApps: true) // Foreground the app
                self.viewModel?.objectWillChange.send()
            }
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.activeSpaceDidChangeNotification, object: nil, queue: nil) { _ in
            guard !self.recentlyLaunchedGame, UserDefaults.standard.bool(forKey: UserDefaults.Key.foregroundOnActiveSpaceChanged), NSWorkspace.shared.frontmostApplication?.bundleIdentifier == self.dolphinBundleID else { return }
            
            NSApplication.shared.activate(ignoringOtherApps: true) // Foreground the app
        }
    }
    
    func launch(_ game: Game) {
        recentlyLaunchedGame = true
        if let dolphinURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: dolphinBundleID) {
            NSWorkspace.shared.open([game.fileURL], withApplicationAt: dolphinURL, configuration: NSWorkspace.OpenConfiguration())
        } else {
            NSWorkspace.shared.open(game.fileURL)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.recentlyLaunchedGame = false
        }
    }
    
    func quit() {
        dolphinApp?.terminate()
    }
    
}
