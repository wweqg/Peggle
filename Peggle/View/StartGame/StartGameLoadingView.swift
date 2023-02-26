//
//  StartGameLoadingView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct StartGameLoadingView: View {
    @ObservedObject var loadLevelViewModel: LoadLevelViewModel
    @ObservedObject var startGameViewModel: StartGameViewModel
    @Binding var load: Bool
    @Binding var gameState: GameState
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    gameState = GameState.showMenu
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.red)
                }
                .font(.headline)
                Text("Select a level to load").font(.headline)
            }
            List {
                ForEach(loadLevelViewModel.getLevelCollectionWithDefault()) { level in
                    Button(level.levelName) {
                        startGameViewModel.setLevel(level)
                        startGameViewModel.defaultAllPeggleObj()
                        load = false
                    }
                }
            }
            .cornerRadius(10)
        }
    }
}

struct StartGameLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameLoadingView(loadLevelViewModel: LoadLevelViewModel(),
                             startGameViewModel: StartGameViewModel(),
                             load: .constant(true),
                             gameState: .constant(GameState.showMenu))
    }
}
