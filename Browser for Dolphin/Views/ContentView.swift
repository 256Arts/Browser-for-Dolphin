//
//  ContentView.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-06.
//

import SwiftUI

struct ContentView: View {
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let gridItemWidth = CoverView.coverSize.width + 56
    let font = Font.system(size: 44)
    
    @StateObject var viewModel = ViewModel()
    @State var currentDate: Date = .now
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemWidth, maximum: gridItemWidth))], spacing: 64) {
                        if viewModel.games.isEmpty {
                            VStack {
                                Text("No Games Found")
                                    .font(font)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            ForEach(viewModel.games) { game in
                                CoverView(game: game, isFocused: Binding(get: { game.id == viewModel.focusedGame?.id }, set: { newValue in if newValue { viewModel.focusedGame = game } }))
                                    .id(game.id)
                            }
                        }
                    }
                    .onChange(of: viewModel.focusedGame) { newValue in
                        if let newValue {
                            AudioController.shared.focusSound?.play()
                            withAnimation {
                                proxy.scrollTo(newValue.id)
                            }
                        }
                    }
                    .padding()
                    .padding(.vertical, 40)
                    .scenePadding()
                    .frame(maxHeight: .infinity)
                }
            }
            .onAppear {
                viewModel.focusManager.columns = Int(geometry.size.width / gridItemWidth)
            }
            .onChange(of: geometry.size.width) { newValue in
                viewModel.focusManager.columns = Int(newValue / gridItemWidth)
            }
        }
        .overlay(alignment: .top) {
            HStack {
                if UserDefaults.standard.bool(forKey: UserDefaults.Key.useBlockyClock) {
                    WebView(fileName: "clock")
                        .frame(width: 360, height: 100)
                        .scaleEffect(0.6666)
                        .frame(width: 180, height: 50)
                } else {
                    Text(currentDate, style: .time)
                }
                Spacer()
                ForEach(viewModel.controllerBatteries) { battery in
                    Image(systemName: battery.symbolName)
                }
            }
            .font(font)
            .shadow(radius: 10)
            .scenePadding()
        }
        .overlay(alignment: .bottomTrailing) {
            if let gamepad = viewModel.inputController.gameController?.extendedGamepad {
                HStack(spacing: 20) {
                    Label("Open", systemImage: gamepad.buttonA.sfSymbolsName ?? "")
                    Label("Quit Dolphin", systemImage: gamepad.buttonY.sfSymbolsName ?? "")
                        .foregroundColor(DolphinController.shared.dolphinIsRunning ? .primary : Color(.disabledControlTextColor))
                        .onTapGesture {
                            DolphinController.shared.quit()
                        }
                }
                .font(font)
                .symbolVariant(.fill)
                .shadow(radius: 10)
                .scenePadding()
            }
        }
        .background {
            WebView(fileName: "background")
                .ignoresSafeArea()
        }
        .onReceive(timer, perform: { _ in
            currentDate = .now
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
