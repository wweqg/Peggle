//
//  CannonBallCountView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 26/2/23.
//

import SwiftUI

struct CannonBallCountView: View {
    @ObservedObject var viewModel: StartGameViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<min(viewModel.cannonBallCount, 5), id: \.self) { _ in
                    Image("ball")
                        .resizable()
                        .frame(width: viewModel.gameBoard.width / 15,
                               height: viewModel.gameBoard.width / 15)
                        .opacity(0.5)
                }
            }

            HStack {
                ForEach(0..<max(0, viewModel.cannonBallCount - 5), id: \.self) { _ in
                    Image("ball")
                        .resizable()
                        .frame(width: viewModel.gameBoard.width / 15,
                               height: viewModel.gameBoard.width / 15)
                        .opacity(0.5)
                }
            }
        }
        .position(x: viewModel.gameBoard.width * 3.5 / 4.5,
                  y: 75)
    }
}

struct CannonBallCountView_Previews: PreviewProvider {
    static var previews: some View {
        CannonBallCountView(viewModel: StartGameViewModel())
    }
}
