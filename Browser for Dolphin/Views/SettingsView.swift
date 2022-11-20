//
//  SettingsView.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(UserDefaults.Key.foregroundOnActiveSpaceChanged) private var foregroundOnActiveSpaceChanged = false
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack {
            GroupBox {
                Toggle("Foreground app when active space changes (exit fullscreen)", isOn: $foregroundOnActiveSpaceChanged)
            }
            GroupBox("Acknowledgements") {
                Text("Sounds by Nathan Gibson")
                    .foregroundColor(.secondary)
            }
            Button("Show Help") {
                openWindow(id: "help")
            }
        }
        .scenePadding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
