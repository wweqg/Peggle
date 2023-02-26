//
//  LevelDesignerView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//

import SwiftUI

struct LevelDesignerView: View {
    @ObservedObject var loadLevelViewModel: LoadLevelViewModel
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel
    @ObservedObject var startGameViewModel: StartGameViewModel
    @State private var showLoadingPage = true
    @Binding var gameState: GameState
    var body: some View {
        ZStack {
            VStack {
                DesignerCanvasView(levelDesignerViewModel: levelDesignerViewModel)
                Spacer()
                PaletteView(paletteViewModel: levelDesignerViewModel.paletteViewModel)
                FooterView(levelDesignerViewModel: levelDesignerViewModel,
                           loadLevelViewModel: loadLevelViewModel,
                           startViewModel: startGameViewModel,
                           levelName: $levelDesignerViewModel.selectedLevel.levelName,
                           showLoadingPage: $showLoadingPage,
                           gameState: $gameState)
            }
            if showLoadingPage {
                LoadLevelView(loadLevelViewModel: loadLevelViewModel,
                              levelDesignerViewModel: levelDesignerViewModel,
                              showLoadingPage: $showLoadingPage,
                              gameState: $gameState)
            } else {
                Button("Exit") {
                    gameState = GameState.showMenu
                }
                .position(CGPoint(x: UIScreen.main.bounds.minX + 50.0,
                                  y: UIScreen.main.bounds.minY + 50.0))
                .font(.headline)
                AddedPegsView(viewModel: levelDesignerViewModel)
            }
        }
    }
}

struct LevelDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(loadLevelViewModel: LoadLevelViewModel(),
                          levelDesignerViewModel: LevelDesignerViewModel(),
                          startGameViewModel: StartGameViewModel(),
                          gameState: .constant(GameState.showLevelDesigner))
    }
}
