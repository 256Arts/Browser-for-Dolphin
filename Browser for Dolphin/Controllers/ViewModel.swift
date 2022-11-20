//
//  ViewModel.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import Foundation

final class ViewModel: ObservableObject {
    
    struct Battery: Identifiable {
        let id = UUID()
        let level: Float
        var symbolName: String {
            switch level {
            case ...0.01:
                return "battery.0"
            case ...0.12:
                return "battery.25"
            case ...0.38:
                return "battery.50"
            case ...0.62:
                return "battery.75"
            default:
                return "battery.100"
            }
        }
    }
    
    let gameManager = GameManager()
    let focusManager = FocusManager()
    let inputController = InputController()
    
    @Published var controllerBatteries: [Battery] = []
    @Published var games: [Game] = [] {
        didSet {
            focusManager.itemCount = games.count
            if focusManager.focusItem == nil {
                focusManager.focusIndex = 0
            }
        }
    }
    
    var focusedGame: Game? {
        get {
            guard let focusIndex = focusManager.focusIndex else { return nil }
            return games[focusIndex]
        }
        set {
            if let newValue {
                focusManager.focusIndex = games.firstIndex(where: { $0.id == newValue.id })
            }
        }
    }
    
    init() {
        games = (try? gameManager.loadGamesList()) ?? []
        focusManager.viewModel = self
        inputController.viewModel = self
        DolphinController.shared.viewModel = self
    }
    
}
