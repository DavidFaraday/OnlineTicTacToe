//
//  GameViewModel.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 02/07/2021.
//

import SwiftUI
import Combine
import AVFoundation

final class GameViewModel: ObservableObject {

    @AppStorage("user") private var userData: Data?
    
    @Published var gameNotification = GameNotification.waitingForPlayer
    @Published var currentUser: User!
    @Published var alertItem: AlertItem?

    @Published var game: Game? {
        didSet {
            checkIfGameIsOver()

            if game == nil { updateGameNotificationFor(.finished) } else {
                game?.player2Id == "" ? updateGameNotificationFor(.waitingForPlayer) : updateGameNotificationFor(.started)
            }
        }
    }

       
    private var cancellables: Set<AnyCancellable> = []
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]


    init() {
        
        retriveUser()
        if currentUser == nil {
            saveUser()
        }
    }
    
    
    //MARK: - Online setup
    func getTheGame() {
        
        FirebaseService.shared.startGame(with: currentUser.id)
        
        FirebaseService.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    

    
    
    //MARK: - Game logic

    func processPlayerMove(for position: Int) {
        guard game != nil else { return }

        //human move processing
        if isSquareOccupied(in: game!.moves, forIndex: position) { return }

        game!.moves[position] = Move(isPlayer1: isPlayerOne(), boardIndex: position)
        game!.blockMoveForPlayerId = currentUser.id

        FirebaseService.shared.updateGame(game!)

        if checkWinCondition(for: isPlayerOne(), in: game!.moves) {
            game!.winningPlayerId = currentUser.id
            FirebaseService.shared.updateGame(game!)
            return
        }

        if checkForDraw(in: game!.moves) {
            game!.winningPlayerId = "0"
            FirebaseService.shared.updateGame(game!)
            return
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {

        return moves.contains(where: { $0?.boardIndex == index })
    }


    func checkWinCondition(for player: Bool, in moves: [Move?]) -> Bool {

        //remove all nils from the array and filter moves of the player only
        let playerMoves = moves.compactMap { $0 }.filter{ $0.isPlayer1 == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })

        //go through winPatterns [0,1,2] and check if my playerPositions match with winPattern we have a win

        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }

        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {

        return moves.compactMap { $0 }.count == 9
    }
    
    
    func quiteGame() {
        FirebaseService.shared.quitTheGame()
    }
    
    func resetGame() {

        guard game != nil else {
            alertItem = AlertContext.quit
            return
        }
        
        if game!.rematchPlayerId.count == 1 {
            game!.moves = Array(repeating: nil, count: 9)
            game!.winningPlayerId = ""
            game!.blockMoveForPlayerId = game!.player2Id
            
        } else if game!.rematchPlayerId.count == 2 {
            game!.rematchPlayerId = []
        }
        
        game!.rematchPlayerId.append(currentUser.id)
        
        FirebaseService.shared.updateGame(game!)
    }

    func checkForGameBoardStatus() -> Bool {
        return game != nil ? game!.blockMoveForPlayerId == currentUser.id : false
    }

    func isPlayerOne() -> Bool {
        return game != nil ? game!.player1Id == currentUser.id : false
    }
    
    func checkIfGameIsOver() {
        alertItem = nil

        guard game != nil else { return }

        if game!.winningPlayerId == "0" {
            alertItem = AlertContext.draw
        } else if game!.winningPlayerId != "" {
            if game!.winningPlayerId == currentUser.id {
                alertItem = AlertContext.youWin
            } else {
                alertItem = AlertContext.youLost
            }
        }
    }
    
    func updateGameNotificationFor(_ state: GameState) {
        switch state {
        case .started:
            gameNotification = GameNotification.gameHasStarted
        case .waitingForPlayer:
            gameNotification = GameNotification.waitingForPlayer
        case .finished:
            gameNotification = GameNotification.gameFinished
        }
    }
    
    //MARK: - Dummy user
    func saveUser() {
        currentUser = User()
        do {
            let data = try JSONEncoder().encode(currentUser)
            userData = data
        } catch {
            print("couldn't save user")
        }
    }
    
    func retriveUser() {
        
        guard let userData = userData else { return }
        
        do {
            print("set current user")
            self.currentUser = try JSONDecoder().decode(User.self, from: userData)
        } catch {
            print("no user saved")
        }
    }
}



