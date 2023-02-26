//
//  MenuView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 28/1/23.
//

import SwiftUI

struct MenuView: View {
    @Binding var gameState: GameState
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                VStack {
                    Button("Start Game") {
                        gameState = GameState.showStartGameFromMenu
                    }
                    .font(.headline)
                    .padding(.bottom)
                    Button("Design Level") {
                        gameState = GameState.showLevelDesigner
                    }
                    .font(.headline)
                    .padding(.top)
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(gameState: .constant(GameState.showMenu))
    }
}
