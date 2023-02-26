//
//  LevelDesignerFooterView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//

import SwiftUI

struct FooterView: View {
    @ObservedObject var levelDesignerViewModel: LevelDesignerViewModel
    @ObservedObject var loadLevelViewModel: LoadLevelViewModel
    @ObservedObject var startViewModel: StartGameViewModel
    @Binding var levelName: String
    @Binding var showLoadingPage: Bool
    @Binding var gameState: GameState
    var body: some View {
        HStack {
            Button("LOAD") {
                showLoadingPage.toggle()
            }
            Button("SAVE") {
                levelDesignerViewModel.saveLevel(loadLevelViewModel: loadLevelViewModel)
            }
            Button("RESET") {
                levelDesignerViewModel.resetLevel()
            }
            TextField("Level Name", text: $levelName)
            .textFieldStyle(.roundedBorder)
            .padding([.leading, .trailing])
            Button("START") {
                startViewModel.setLevel(levelDesignerViewModel.selectedLevel)
                gameState = .showStartGameFromLevelDesigner
            }
        }
        .padding([.leading, .trailing])
    }
}

struct LevelDesignerFooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView(levelDesignerViewModel: LevelDesignerViewModel(),
                   loadLevelViewModel: LoadLevelViewModel(),
                   startViewModel: StartGameViewModel(),
                   levelName: .constant(""),
                   showLoadingPage: .constant(true),
                   gameState: .constant(GameState.showMenu))
    }
}
