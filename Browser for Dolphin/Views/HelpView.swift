//
//  HelpView.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            GroupBox {
                VStack(alignment: .leading, spacing: 0) {
                    Link("Get Dolphin", destination: URL(string: "https://dolphin-emu.org/download/")!)
                        .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Game Cover Art")
                            .font(.headline)
                        Text("To setup cover art, go to Dolphin > Settings > Interface and enable \"Download Game Covers\".")
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Fullscreen")
                            .font(.headline)
                        Text("Since games don't launch in fullscreen, it is recommended that you go to Dolphin > Options > Hotkey Settings > General, and add a hotkey for \"Toggle Fullscreen\" to your game controller.")
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Quit Games")
                            .font(.headline)
                        Text("To quit a game and return to the game browser, hold down the home button and use the app switcher to return to this app. Alternatively you can use the toggle fullscreen hotkey again, to return in one-click.")
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            HStack {
                Link("Website", destination: URL(string: "https://www.jaydenirwin.com/")!)
                Link("Community", destination: URL(string: "https://www.256arts.com/joincommunity/")!)
                Link("Contribute", destination: URL(string: "https://github.com/256Arts/Browser-for-Dolphin")!)
            }
            .font(.footnote)
        }
        .scenePadding()
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
