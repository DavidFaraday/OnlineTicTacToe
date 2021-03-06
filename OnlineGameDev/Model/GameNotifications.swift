//
//  GameNotifications.swift
//  GameNotifications
//
//  Created by David Kababyan on 31/07/2021.
//

import SwiftUI

struct GameNotification {
    static let waitingForPlayer = "Waiting for player"
    static let gameHasStarted = "Game has started"
    static let gameFinished = "Player left the game."
}

enum GameState {
    case started
    case waitingForPlayer
    case finished
}
