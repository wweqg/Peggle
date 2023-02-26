//
//  File.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 20/1/23.
//
import Foundation

class PaletteViewModel: ObservableObject {
    @Published private(set) var selectedButton: PaletteViewModel.SelectedButton
    static let BUTTON_WIDTH = 90.0
    static let BUTTON_HEIGHT = 90.0
    let selectedOpacity = 1.0
    let unSelectedOpacity = 0.4
    init(_ selectedButton: PaletteViewModel.SelectedButton = SelectedButton.none) {
        self.selectedButton = selectedButton
    }
    func select(button: PaletteViewModel.SelectedButton) {
        guard selectedButton != button else {
            unselectButton()
            return
        }
        selectedButton = button
    }
    func unselectButton() {
        selectedButton = .none
    }
}

extension PaletteViewModel {
    enum SelectedButton: String {
        case none
        case bluePeg
        case orangePeg
        case delete
        case greenPeg
        case explodePeg
        case rectangle
        case resize
    }
}
