//
//  CoverView.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-06.
//

import SwiftUI

struct CoverView: View {
    
    static let coverSize = CGSize(width: 240, height: 336)
    
    let game: Game
    
    @Binding var isFocused: Bool
    
    var body: some View {
        AsyncImage(url: game.coverURL) { imagePhase in
            switch imagePhase {
            case .empty:
                Color(nsColor: .controlBackgroundColor)
                    .overlay {
                        ProgressView()
                    }
            case .failure:
                Color(nsColor: .controlBackgroundColor)
                    .overlay {
                        Text(game.name)
                            .multilineTextAlignment(.center)
                    }
            case .success(let image):
                image
                    .resizable()
            @unknown default:
                Color(nsColor: .controlBackgroundColor)
            }
        }
        .frame(width: Self.coverSize.width, height: Self.coverSize.height)
        .cornerRadius(20)
        .shadow(color: .black, radius: isFocused ? 30 : 10, y: 5)
        .scaleEffect(isFocused ? 1.1 : 1)
        .overlay(alignment: .bottom) {
            Text(game.name)
                .lineLimit(1)
                .font(.system(size: 28))
                .opacity(isFocused ? 1 : 0)
                .offset(y: 56)
        }
        .animation(.easeInOut(duration: 0.1), value: isFocused)
        .onHover { hovered in
            if hovered {
                isFocused = true
            }
        }
        .onTapGesture {
            DolphinController.shared.launch(game)
        }
    }
}

struct CoverView_Previews: PreviewProvider {
    static var previews: some View {
        CoverView(game: Game(id: "123456", name: "Title", fileURL: URL(string: "https://www.jaydenirwin.com/spritepencil/icon_spencil.png")!), isFocused: .constant(true))
    }
}
