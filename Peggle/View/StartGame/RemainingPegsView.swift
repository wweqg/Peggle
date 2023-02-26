//
//  RemainingPegsView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 26/2/23.
//

import SwiftUI

struct RemainingPegsView: View {
    @ObservedObject var viewModel: StartGameViewModel
    var body: some View {
        VStack {
            Text("Orange pegs remaining: \(viewModel.numOfOrangeBallsLeft)")
                .font(.system(size: 25))
            Text("Blue pegs remaining: \(viewModel.numOfBlueBallsLeft)")
                .font(.system(size: 25))
            Text("Special pegs remaining: \(viewModel.numOfSpecialBallsLeft)")
                .font(.system(size: 25))
        }
        .position(x: viewModel.gameBoard.width - 150, y: viewModel.gameBoard.height * 0.93)
    }
}

struct RemainingPegsView_Previews: PreviewProvider {
    static var previews: some View {
        RemainingPegsView(viewModel: StartGameViewModel())
    }
}
