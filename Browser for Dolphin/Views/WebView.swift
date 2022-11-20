//
//  WebView.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-14.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    
    let fileName: String
    
    func makeNSView(context: Context) -> some NSView {
        let view = WKWebView()
        if let url = Bundle.main.url(forResource: fileName, withExtension: "html") {
            view.loadFileURL(url, allowingReadAccessTo: url)
        }
        view.setValue(false, forKey: "drawsBackground")
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        //
    }
    
}
