//
//  Alert.swift
//  Alert
//
//  Created by David Kababyan on 26/07/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var isForQuit = false
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    
    static let youWin =      AlertItem(title: Text("You Win!"),
                                  message: Text("You are good at this!"),
                                  buttonTitle: Text("Rematch"))
    
    static let youLost =   AlertItem(title: Text("You lost"),
                                  message: Text("Try rematch."),
                                  buttonTitle: Text("Rematch"))
    
    static let draw =          AlertItem(title: Text("Draw"),
                                  message: Text("What a game..."),
                                  buttonTitle: Text("Rematch"))
    
    static let quit =          AlertItem(isForQuit: true, title: Text("Game Over"),
                                  message: Text("Other player left."),
                                  buttonTitle: Text("Quite"))
}
