//
//  FocusManager.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-05.
//

import GameController

final class FocusManager {
    
    struct FocusItem {
        var x: Int
        var y: Int
        
        func index(columns: Int) -> Int {
            (y * columns) + x
        }
    }
    
    enum Direction {
        case up, down, left, right
    }
    
    weak var viewModel: ViewModel?
    
    var itemCount: Int = 0
    var columns: Int = 0
    
    var focusIndex: Int?
    var focusItem: FocusItem? {
        get {
            if let focusIndex {
                return FocusItem(x: focusIndex % columns, y: focusIndex / columns)
            } else {
                return nil
            }
        }
        set {
            focusIndex = newValue?.index(columns: columns)
        }
    }
    
    func attemptMove(_ direction: Direction) {
        guard let oldFocusItem = focusItem else { return }
        
        switch direction {
        case .up:
            if 0 < oldFocusItem.y {
                viewModel?.objectWillChange.send()
                focusItem!.y -= 1
            }
        case .down:
            let newFocusItem = FocusItem(x: oldFocusItem.x, y: oldFocusItem.y + 1)
            if newFocusItem.index(columns: columns) < itemCount {
                viewModel?.objectWillChange.send()
                focusItem = newFocusItem
            }
        case .left:
            if 0 < oldFocusItem.x {
                viewModel?.objectWillChange.send()
                focusItem!.x -= 1
            }
        case .right:
            let newFocusItem = FocusItem(x: oldFocusItem.x + 1, y: oldFocusItem.y)
            if newFocusItem.x < columns, newFocusItem.index(columns: columns) < itemCount {
                viewModel?.objectWillChange.send()
                focusItem = newFocusItem
            }
        }
    }
    
}
