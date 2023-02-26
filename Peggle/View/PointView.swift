//
//  PointView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 25/2/23.
//

import SwiftUI

struct PointView: View {
    @ObservedObject var viewModel: StartGameViewModel
    var body: some View {
        if viewModel.gameMode == GameMode.beatScore {
            VStack {
                Text("Target Points: \(viewModel.targetScore ?? 0)")
                    .foregroundColor(.red)
                    .font(.system(size: 25))
                    .padding(.leading)
                Text("Points: \(viewModel.points)")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .padding(.leading)
            }
            .position(x: 120, y: viewModel.gameBoard.height * 0.95)
        } else if viewModel.gameMode == GameMode.siam {
            VStack {
                Text("\(viewModel.siamBall ?? 0) more balls to siam ")
                    .foregroundColor(.red)
                    .font(.system(size: 25))
                    .padding(.leading)
                Text("Points: \(viewModel.points)")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .padding(.leading)
            }
            .position(x: 120, y: viewModel.gameBoard.height * 0.95)
        } else {
            Text("Points: \(viewModel.points)")
                .foregroundColor(.black)
                .position(x: 100, y: viewModel.gameBoard.height * 0.95)
                .font(.system(size: 25))
        }
    }
}

struct PointView_Previews: PreviewProvider {
    static var previews: some View {
        PointView(viewModel: StartGameViewModel())
    }
}
