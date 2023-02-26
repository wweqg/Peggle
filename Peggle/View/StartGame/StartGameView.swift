//
//  StartGameView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import SwiftUI

struct StartGameView: View {

    @ObservedObject var startGameViewModel: StartGameViewModel
    @ObservedObject var loadLevelViewModel: LoadLevelViewModel
    @Binding var load: Bool
    @State private var selectGameMode = true
    @Binding var gameState: GameState
    var body: some View {
        ZStack {
            StartGameCanvasView(viewModel: startGameViewModel)
            if load {
                StartGameLoadingView(loadLevelViewModel: loadLevelViewModel,
                                     startGameViewModel: startGameViewModel,
                                     load: $load,
                                     gameState: $gameState)
            } else {
                Button("Exit") {
                    gameEnd()
                }
                .position(CGPoint(x: UIScreen.main.bounds.minX + 50.0,
                                  y: UIScreen.main.bounds.minY + 50.0))
                .font(.headline)
                CannonBallCountView(viewModel: startGameViewModel)
                .alert("Select Game Mode ",
                       isPresented: .constant(selectGameMode)) {
                    VStack {
                        Button("Beat the Score !") {
                            startGameViewModel.setGameMode(GameMode.beatScore)
                            selectGameMode = false
                        }
                        Button("Siam Left, Siam Right !") {
                            startGameViewModel.setGameMode(GameMode.siam)
                            selectGameMode = false
                        }
                        Button("Cancel") {
                            startGameViewModel.setGameMode(GameMode.normal)
                            selectGameMode = false
                        }
                    }
                }
                .alert("Congratulations, you have won! You earned \(startGameViewModel.points) points!",
                       isPresented: .constant(startGameViewModel.isGameWon && !selectGameMode)) {
                    Button("Home") {
                        gameEnd()
                    }
                }
                .alert("You lose, you ran out of cannon balls :( You earned \(startGameViewModel.points) points!",
                       isPresented: .constant(startGameViewModel.isGameLost && !selectGameMode)) {
                    Button("Home") {
                        gameEnd()
                    }
                }
                .alert("Times up ! You lose :( You earned \(startGameViewModel.points) points!",
                       isPresented: .constant(startGameViewModel.isTimerUp && !selectGameMode)) {
                    Button("Home") {
                        gameEnd()
                    }
                }
            }
        }
    }
    func gameEnd() {
        startGameViewModel.endGame()
        gameState = GameState.showMenu
        load = true
    }
}

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView(startGameViewModel: StartGameViewModel(),
                      loadLevelViewModel: LoadLevelViewModel(),
                      load: .constant(true),
                      gameState: .constant(GameState.showMenu))
    }
}
