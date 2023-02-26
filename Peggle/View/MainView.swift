//
//  MainView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 28/1/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var startGameViewModel = StartGameViewModel(gameBoard: UIScreen.main.bounds)
    @StateObject private var levelDesignerViewModel = LevelDesignerViewModel(gameBoard: UIScreen.main.bounds)
    @StateObject private var loadLevelViewModel = LoadLevelViewModel(gameBoard: UIScreen.main.bounds)
    @Binding var gameState: GameState
    @State var load = true
    var body: some View {
        switch gameState {
        case .showStartGameFromMenu:
            StartGameView(startGameViewModel: startGameViewModel,
                          loadLevelViewModel: loadLevelViewModel,
                          load: $load,
                          gameState: $gameState)
        case .showMenu:
            MenuView(gameState: $gameState)
        case .showLevelDesigner:
            LevelDesignerView(loadLevelViewModel: loadLevelViewModel,
                              levelDesignerViewModel: levelDesignerViewModel,
                              startGameViewModel: startGameViewModel,
                              gameState: $gameState)
        case .showStartGameFromLevelDesigner:
            StartGameView(startGameViewModel: startGameViewModel,
                          loadLevelViewModel: loadLevelViewModel,
                          load: .constant(false),
                          gameState: $gameState)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(gameState: .constant(GameState.showMenu))
    }
}
