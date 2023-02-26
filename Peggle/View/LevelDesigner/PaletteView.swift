//
//  PaletteView.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//

import SwiftUI

struct PaletteView: View {
    @ObservedObject private var paletteViewModel: PaletteViewModel
    init(paletteViewModel: PaletteViewModel) {
        self.paletteViewModel = paletteViewModel
    }
    var body: some View {
        HStack {
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.bluePeg, paletteViewModel: paletteViewModel)
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.orangePeg, paletteViewModel: paletteViewModel)
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.greenPeg, paletteViewModel: paletteViewModel)
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.explodePeg,
                              paletteViewModel: paletteViewModel)
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.rectangle, paletteViewModel: paletteViewModel)
            Spacer()
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.resize, paletteViewModel: paletteViewModel)
            PaletteButtonView(buttonType: PaletteViewModel.SelectedButton.delete, paletteViewModel: paletteViewModel)
        }
        .padding([.leading, .trailing])
    }
}

struct PaletteView_Previews: PreviewProvider {
    static var previews: some View {
        PaletteView(paletteViewModel: PaletteViewModel())
    }
}
