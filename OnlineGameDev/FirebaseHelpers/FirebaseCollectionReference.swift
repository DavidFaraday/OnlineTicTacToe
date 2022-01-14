//
//  FirebaseCollectionReference.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 02/07/2021.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import Foundation

final class FirebaseService: ObservableObject {

    static let shared = FirebaseService()

    @Published var game: Game!

    init() { }
    
    func createOnlineGame() {
        do {
            _ = try FirebaseReference(.Game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating game ", error.localizedDescription)
        }
    }
    
    func startGame(with userId: String) {
        FirebaseReference(.Game).whereField("player2Id", isEqualTo: "").whereField("player1Id", isNotEqualTo: userId).getDocuments(completion: { querySnapshot, error in

            if error != nil {
                print("Error starting game",error!.localizedDescription)
                self.createNewGame(with: userId)
                return
            }


            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.game.player2Id = userId
                self.game.blockMoveForPlayerId = userId
                self.updateGame(self.game)
                self.listenForGameChanges()
            } else {
                self.createNewGame(with: userId)
            }
        })
    }

    func listenForGameChanges() {

        FirebaseReference(.Game).document(self.game.id).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                print("Error listening for game",error!.localizedDescription)
                return
            }

            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }

    }
    
    func updateGame(_ game: Game) {

        do {
            try FirebaseReference(.Game).document(game.id).setData(from: game)
        } catch {
            print("Error updating move ", error.localizedDescription)
        }

    }
    
    private func createNewGame(with userId: String) {
        print("creating new game", userId)
        self.game = Game(id: UUID().uuidString, player1Id: userId, player2Id: "", blockMoveForPlayerId: userId, winningPlayerId: "", rematchPlayerId: [], moves: Array(repeating: nil, count: 9))
        self.createOnlineGame()
        self.listenForGameChanges()
    }
    
    func quitTheGame() {
        guard game != nil else { return }
        FirebaseReference(.Game).document(self.game.id).delete()
    }
}
