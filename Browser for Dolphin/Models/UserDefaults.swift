//
//  UserDefaults.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import Foundation

extension UserDefaults {
    
    enum Key {
        static let useBlockyClock = "useBlockyClock"
        static let foregroundOnActiveSpaceChanged = "foregroundOnActiveSpaceChanged"
    }
    
    func register() {
        register(defaults: [
            Key.useBlockyClock: true,
            Key.foregroundOnActiveSpaceChanged: false
        ])
    }
    
}
