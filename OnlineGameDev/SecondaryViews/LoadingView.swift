//
//  LoadingView.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 04/07/2021.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}
