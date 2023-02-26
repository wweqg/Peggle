//
//  PaletteButtonView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//

import SwiftUI

struct PaletteButtonView: View {
    @ObservedObject private var paletteViewModel: PaletteViewModel
    private let buttonType: PaletteViewModel.SelectedButton
    init(buttonType: PaletteViewModel.SelectedButton, paletteViewModel: PaletteViewModel) {
        self.buttonType = buttonType
        self.paletteViewModel = paletteViewModel
    }
    var body: some View {
        Button(action: {
            paletteViewModel.select(button: buttonType)
        }) {
            if buttonType == PaletteViewModel.SelectedButton.explodePeg {
                Image("greenPeg")
                    .resizable()
                    .opacity(getOpacity())
                    .frame(width: PaletteViewModel.BUTTON_WIDTH, height: PaletteViewModel.BUTTON_HEIGHT)
                    .shadow(color: Color.red, radius: PaletteViewModel.BUTTON_WIDTH)
                    .scaledToFit()
            } else {
                Image("\(buttonType.rawValue)")
                    .resizable()
                    .opacity(getOpacity())
                    .frame(width: PaletteViewModel.BUTTON_WIDTH, height: PaletteViewModel.BUTTON_HEIGHT)
                    .scaledToFit()
            }
        }
    }
    private func getOpacity() -> Double {
        buttonType == paletteViewModel.selectedButton
            ? paletteViewModel.selectedOpacity
            : paletteViewModel.unSelectedOpacity
    }
}

struct PaletteButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.bluePeg,
                          paletteViewModel: PaletteViewModel())
    }
}
