//
//  ContentView.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 02/07/2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        VStack() {
         
            Button {
                viewModel.isGameViewShowing = true
            } label: {
                GameButton(title: "Play", backgroundColor: Color(.systemGreen))
            }
        }
        .fullScreenCover(isPresented: $viewModel.isGameViewShowing) {
            GameView(viewModel: GameViewModel())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

