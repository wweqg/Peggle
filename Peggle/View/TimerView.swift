//
//  TimerView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 25/2/23.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: StartGameViewModel
    var body: some View {
        Text(String(format: "%.0f", viewModel.timer))
            .position(x: viewModel.gameBoard.width * 1 / 4,
                      y: viewModel.gameBoard.height / 15)
            .font(.system(size: 35))
            .foregroundColor(viewModel.timer < 0.0 ? .red : .black)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(viewModel: StartGameViewModel())
    }
}
