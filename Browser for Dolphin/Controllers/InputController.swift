//
//  InputController.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import GameController

final class InputController {
    
    weak var viewModel: ViewModel!
    
    var gameController: GCController? {
        GCController.current
    }
    
    private var thumbstickMovedFocus: FocusManager.Direction?
    
    init() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidConnect),
            name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidStopBeingCurrent, object: nil)
        
        if let gc = GCController.current {
            registerGameController(gc)
        }
    }
    
    @objc private func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else { return }
        registerGameController(gameController)
    }

    @objc private func handleControllerDidDisconnect(_ notification: Notification) {
        unregisterGameController()
    }

    func registerGameController(_ controller: GCController) {
        updateBatteries()
        guard let gamepad = controller.extendedGamepad else { return }

        weak var weakController = self

        // A Y
        gamepad.buttonA.pressedChangedHandler = { (button, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                guard let game = strongController.viewModel.focusedGame else { return }
                AudioController.shared.selectSound?.play()
                DolphinController.shared.launch(game)
            }
        }
        gamepad.buttonY.pressedChangedHandler = { (button, _, isPressed) in
            if isPressed {
                AudioController.shared.selectSound?.play()
                DolphinController.shared.quit()
            }
        }
        
        // Dpad
        gamepad.dpad.left.pressedChangedHandler = { (_, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.viewModel.focusManager.attemptMove(.left)
            }
        }
        gamepad.dpad.right.pressedChangedHandler = { (_, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.viewModel.focusManager.attemptMove(.right)
            }
        }
        gamepad.dpad.up.pressedChangedHandler = { (_, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.viewModel.focusManager.attemptMove(.up)
            }
        }
        gamepad.dpad.down.pressedChangedHandler = { (_, _, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed {
                strongController.viewModel.focusManager.attemptMove(.down)
            }
        }
        
        // Thumbstick
        gamepad.leftThumbstick.left.valueChangedHandler = { (_, value, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed, 0.6 < value, strongController.thumbstickMovedFocus == nil {
                strongController.viewModel.focusManager.attemptMove(.left)
                strongController.thumbstickMovedFocus = .left
            } else if strongController.thumbstickMovedFocus == .left, value < 0.2 {
                strongController.thumbstickMovedFocus = nil
            }
        }
        gamepad.leftThumbstick.right.valueChangedHandler = { (_, value, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed, 0.6 < value, strongController.thumbstickMovedFocus == nil {
                strongController.viewModel.focusManager.attemptMove(.right)
                strongController.thumbstickMovedFocus = .right
            } else if strongController.thumbstickMovedFocus == .right, value < 0.2 {
                strongController.thumbstickMovedFocus = nil
            }
        }
        gamepad.leftThumbstick.up.valueChangedHandler = { (_, value, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed, 0.6 < value, strongController.thumbstickMovedFocus == nil {
                strongController.viewModel.focusManager.attemptMove(.up)
                strongController.thumbstickMovedFocus = .up
            } else if strongController.thumbstickMovedFocus == .up, value < 0.2 {
                strongController.thumbstickMovedFocus = nil
            }
        }
        gamepad.leftThumbstick.down.valueChangedHandler = { (_, value, isPressed) in
            guard let strongController = weakController else { return }
            if isPressed, 0.6 < value, strongController.thumbstickMovedFocus == nil {
                strongController.viewModel.focusManager.attemptMove(.down)
                strongController.thumbstickMovedFocus = .down
            } else if strongController.thumbstickMovedFocus == .down, value < 0.2 {
                strongController.thumbstickMovedFocus = nil
            }
        }
    }

    func unregisterGameController() {
        updateBatteries()
    }
    
    func updateBatteries() {
        viewModel.controllerBatteries = GCController.controllers().compactMap {
            guard let level = $0.battery?.batteryLevel, !level.isZero else { return nil }
            return ViewModel.Battery(level: level)
        }
    }
    
}
