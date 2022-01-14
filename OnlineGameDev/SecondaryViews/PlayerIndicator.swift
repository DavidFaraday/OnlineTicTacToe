//
//  PlayerIndicator.swift
//  PlayerIndicator
//
//  Created by David Kababyan on 04/08/2021.
//

import SwiftUI

struct PlayerIndicator: View {
    
    var systemImageName: String
    
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .opacity(systemImageName == "applelogo" ? 0 : 1)
    }
}

struct PlayerIndicator_Previews: PreviewProvider {
    static var previews: some View {
        PlayerIndicator(systemImageName: "applelogo")
    }
}
