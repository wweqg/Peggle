//
//  AddedPegsView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 26/2/23.
//

import SwiftUI

struct AddedPegsView: View {
    @ObservedObject var viewModel: LevelDesignerViewModel
    var body: some View {
        VStack {
            Text("Orange pegs added: \(viewModel.numOfOrangeBalls)")
                .font(.system(size: 25))
            Text("Blue pegs added: \(viewModel.numOfBlueBalls)")
                .font(.system(size: 25))
            Text("Special pegs added: \(viewModel.numOfSpecialBalls)")
                .font(.system(size: 25))
        }
        .position(x: viewModel.gameBoard.width * 0.82, y: viewModel.gameBoard.height * 0.04)
    }
}

struct AddedPegsView_Previews: PreviewProvider {
    static var previews: some View {
        AddedPegsView(viewModel: LevelDesignerViewModel())
    }
}
