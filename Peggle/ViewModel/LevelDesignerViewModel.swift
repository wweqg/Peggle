//
//  LevelDesignerViewModel.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//
import Foundation
import SwiftUI

class LevelDesignerViewModel: ObservableObject {
    private(set) var paletteViewModel: PaletteViewModel
    var gameBoard: CGRect
    @Published var selectedLevel: Level
    var selectedLevelPegs: [Peg] {
        selectedLevel.getPegs()
    }
    var selectedLevelRectangles: [Rectangle] {
        selectedLevel.getRects()
    }
    var selectedLevelObjs: [PeggleObject] {
        var res = [PeggleObject]()
        res.append(contentsOf: selectedLevelPegs)
        res.append(contentsOf: selectedLevelRectangles)
        return res
    }
    var numOfOrangeBalls: Int {
        var num = 0
        for peg in selectedLevelPegs where peg.pegType == PegType.orangePeg {
            num += 1
        }
        return num
    }
    var numOfBlueBalls: Int {
        var num = 0
        for peg in selectedLevelPegs where peg.pegType == PegType.bluePeg {
            num += 1
        }
        return num
    }
    var numOfSpecialBalls: Int {
        var num = 0
        for peg in selectedLevelPegs where peg.pegType != PegType.orangePeg && peg.pegType != PegType.bluePeg {
            num += 1
        }
        return num
    }
    init(paletteViewModel: PaletteViewModel = .init(),
         selectedLevel: Level = .init(),
         gameBoard: CGRect = .init()) {
        self.paletteViewModel = paletteViewModel
        self.selectedLevel = selectedLevel
        self.gameBoard = gameBoard
    }
    func backgroundOnTapGesture(_ point: Point, canvas: CGRect) {
        var addedPeg: Peg?
        var addedRect: Rectangle?

        switch paletteViewModel.selectedButton {
        case .bluePeg:
            addedPeg = Peg(pegType: PegType.bluePeg, coordinate: point)
        case .orangePeg:
            addedPeg = Peg(pegType: PegType.orangePeg, coordinate: point)
        case .greenPeg:
            addedPeg = Peg(pegType: PegType.spookyPeg, coordinate: point)
        case .explodePeg:
            addedPeg = Peg(pegType: PegType.KaBoomPeg, coordinate: point)
        case .rectangle:
            addedRect = Rectangle(coordinate: point)
        default:
            break
        }
        if let peg = addedPeg, isValidState(peg: peg, canvas: canvas) {
            selectedLevel.addPeg(peg)
            return
        }
        if let rect = addedRect, isValidState(rect: rect, canvas: canvas) {
            selectedLevel.addRect(rect)
            return
        }
    }
    func peggObjOnTapGesture(_ peggobj: PeggleObject) {
        guard paletteViewModel.selectedButton == .delete else {
            return
        }
        if let peg = peggobj as? Peg {
            removePeg(peg)
        } else if let rect = peggobj as? Rectangle {
            removeRect(rect)
        }
    }
    func peggObjOnLongPressGesture(_ peggobj: PeggleObject) {
        if let peg = peggobj as? Peg {
            removePeg(peg)
        } else if let rect = peggobj as? Rectangle {
            removeRect(rect)
        }
    }
    func peggObjOnDragGesture(_ coordinate: Point, _ peggobj: PeggleObject, _ canvas: CGRect) {
        if paletteViewModel.selectedButton == PaletteViewModel.SelectedButton.resize {
            if let peg = peggobj as? Peg {
                let pegCopy = peg.getDeepCopy()
                selectedLevel.resizeObject(peggleObject: peggobj, location: coordinate)
                if !isValidState(peg: peg, canvas: canvas) {
                    peg.restoreState(from: pegCopy)
                }
            } else if let rect = peggobj as? Rectangle {
                let rectCopy = rect.getDeepCopy()
                selectedLevel.resizeObject(peggleObject: peggobj, location: coordinate)
                if !isValidState(rect: rect, canvas: canvas) {
                    rect.restoreState(from: rectCopy)
                }
            }
        } else {
            if let peg = peggobj as? Peg {
                let pegCopy = peg.getDeepCopy()
                selectedLevel.moveSelectedPegTo(coordinate: coordinate, peg)
                if !isValidState(peg: peg, canvas: canvas) {
                    peg.restoreState(from: pegCopy)
                }
            } else if let rect = peggobj as? Rectangle {
                let rectCopy = rect.getDeepCopy()
                selectedLevel.moveSelectedRectTo(coordinate: coordinate, rect)
                if !isValidState(rect: rect, canvas: canvas) {
                    rect.restoreState(from: rectCopy)
                }
            }
        }
    }
    func isValidState(peg: Peg, canvas: CGRect) -> Bool {
        isWithinCanvas(peg, canvas) && noOtherPeggleObjsSurrouding(peggObj: peg)
    }
    func isValidState(rect: Rectangle, canvas: CGRect) -> Bool {
        isWithinCanvas(rect, canvas) && noOtherPeggleObjsSurrouding(peggObj: rect)
    }
    func setLevel(_ level: Level) {
        selectedLevel = level
    }
    func createNewLevel() {
        selectedLevel = Level()
    }
    func saveLevel(loadLevelViewModel: LoadLevelViewModel) {
        if selectedLevel.levelName.isEmpty {
            selectedLevel.levelName = "Unnamed level"
        }
        /* Handle case on saving into default levels*/
        let id = selectedLevel.id
        if loadLevelViewModel.defaultIds.contains(id) {
            var level = Level()
            level.copy(level: level)
            selectedLevel = level
        }
        let savedLevels = loadLevelViewModel.savedLevels
        if !savedLevels.contains(level: selectedLevel) {
            savedLevels.append(level: selectedLevel)
        } else {
            savedLevels.copySelectedLevel(selectedLevel)
        }
        savedLevels.save()
        createNewLevel()
    }
    func resetLevel() {
        selectedLevel.levelName = ""
        selectedLevel.pegs = [Peg]()
        selectedLevel.rectangles = [Rectangle]()
    }
    private func removePeg(_ peg: Peg) {
        selectedLevel.removePeg(peg)
    }
    private func removeRect(_ rect: Rectangle) {
        selectedLevel.removeRect(rect)
    }
    private func isWithinCanvas(_ peg: Peg, _ canvas: CGRect) -> Bool {
        peg.isFullyAbove(yCoordinate: canvas.minY)
        && peg.isFullyBelow(yCoordinate: canvas.maxY)
        && peg.isFullyLeft(xCoordinate: canvas.maxX)
        && peg.isFullyRight(xCoordinate: canvas.minX)
    }
    private func isWithinCanvas(_ rect: Rectangle, _ canvas: CGRect) -> Bool {
        rect.isFullyAbove(yCoordinate: canvas.minY)
        && rect.isFullyBelow(yCoordinate: canvas.maxY)
        && rect.isFullyLeft(xCoordinate: canvas.maxX)
        && rect.isFullyRight(xCoordinate: canvas.minX)
    }
    private func noOtherPeggleObjsSurrouding(peggObj: PeggleObject) -> Bool {
        for obj in selectedLevel.peggleObjects where obj != peggObj &&
        obj.isOverlaping(peggObj) {
                return false
        }
        return true
    }
}
