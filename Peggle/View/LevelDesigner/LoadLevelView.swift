//
//  LoadLevelView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 28/1/23.
//

import SwiftUI

struct LoadLevelView: View {
    @ObservedObject var loadLevelViewModel: LoadLevelViewModel
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel
    @Binding var showLoadingPage: Bool
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
                    HStack {
                        Button(level.levelName) {
                            levelDesignerViewModel.setLevel(level)
                            showLoadingPage.toggle()
                        }
                    }
                }
                Button("+ New Level") {
                    levelDesignerViewModel.createNewLevel()
                    showLoadingPage.toggle()
                }
            }
        }
    }
}

struct LoadLevelView_Previews: PreviewProvider {
    static var previews: some View {
        LoadLevelView(loadLevelViewModel: LoadLevelViewModel(),
                      levelDesignerViewModel: LevelDesignerViewModel(),
                      showLoadingPage: .constant(true),
                      gameState: .constant(GameState.showLevelDesigner))
    }
}
