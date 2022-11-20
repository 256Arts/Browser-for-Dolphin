//
//  Game.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-06.
//

import Foundation

struct Game: Equatable, Identifiable {
    
    let id: String
    let name: String
    let fileURL: URL
    
    var coverURL: URL {
        GameManager.coversDirectoryURL.appending(path: id + ".png", directoryHint: .notDirectory)
    }
    
}
