//
//  AudioController.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import AVKit

final class AudioController {
    
    static let shared = AudioController()
    
    let focusSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Focus", withExtension: "wav")!)
    let selectSound = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Select", withExtension: "wav")!)
    
}
