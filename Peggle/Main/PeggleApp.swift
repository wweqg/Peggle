//
//  PeggleApp.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 16/1/23.
//

import SwiftUI

@main
struct PeggleApp: App {
    @State private var gameState = GameState.showMenu
    var body: some Scene {
        WindowGroup {
            MainView(gameState: $gameState)
        }
    }
}
