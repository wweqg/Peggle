//
//  LoadLevelViewModel.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 28/1/23.
//

import SwiftUI

class LoadLevelViewModel: ObservableObject {
    @Published var savedLevels: SavedLevels
    private var gameBoard: CGRect
    private var defaul1_1: Level {
        var level = Level()
        var pegs = [Peg]()
        level.levelName = "Default level 1"
        let topLeft = Peg(pegType: PegType.orangePeg,
                          coordinate: Point(xCoordinate: gameBoard.minX + gameBoard.maxX * 0.1,
                                            yCoordinate: gameBoard.minY + gameBoard.maxY * 0.1))
        let topRight = Peg(pegType: PegType.orangePeg,
                           coordinate: Point(xCoordinate: gameBoard.maxX * 0.9,
                                             yCoordinate: gameBoard.minY + gameBoard.maxY * 0.1))
        let botLeft = Peg(pegType: PegType.orangePeg,
                          coordinate: Point(xCoordinate: gameBoard.minX + gameBoard.maxX * 0.1,
                                            yCoordinate: gameBoard.maxY * 0.8))
        let botRight = Peg(pegType: PegType.orangePeg,
                           coordinate: Point(xCoordinate: gameBoard.maxX * 0.9,
                                             yCoordinate: gameBoard.maxY * 0.8))
        pegs.append(contentsOf: [topLeft, topRight, botLeft, botRight])
        level.pegs = pegs
        return level
    }
    private var defaul1_2: Level {
        var level = Level()
        var pegs = [Peg]()
        level.levelName = "Default level 2"
        let topLeft = Peg(pegType: PegType.orangePeg,
                          coordinate: Point(xCoordinate: gameBoard.minX + gameBoard.maxX * 0.1,
                                            yCoordinate: gameBoard.minY + gameBoard.maxY * 0.1))
        let topRight = Peg(pegType: PegType.orangePeg,
                           coordinate: Point(xCoordinate: gameBoard.maxX * 0.9,
                                             yCoordinate: gameBoard.minY + gameBoard.maxY * 0.1))
        let botMid = Peg(pegType: PegType.orangePeg,
                         coordinate: Point(xCoordinate: gameBoard.midX,
                                           yCoordinate: gameBoard.maxY * 0.8))
        pegs.append(contentsOf: [topLeft, topRight, botMid])
        level.pegs = pegs
        return level
    }
    private var defaul1_3: Level {
        var level = Level()
        var pegs = [Peg]()
        var rects = [Rectangle]()
        level.levelName = "Default level 3"
        let mid = Rectangle(coordinate: Point(xCoordinate: gameBoard.midX, yCoordinate: gameBoard.midY))
        let botLeft = Peg(pegType: PegType.orangePeg,
                          coordinate: Point(xCoordinate: gameBoard.minX + gameBoard.maxX * 0.1,
                                            yCoordinate: gameBoard.maxY * 0.8))
        let botRight = Peg(pegType: PegType.orangePeg,
                           coordinate: Point(xCoordinate: gameBoard.maxX * 0.9,
                                             yCoordinate: gameBoard.maxY * 0.8))
        pegs.append(contentsOf: [botLeft, botRight])
        rects.append(mid)
        level.pegs = pegs
        level.rectangles = rects
        return level
    }
    var defaultIds: [UUID] {
        var res = [UUID]()
        res.append(contentsOf: [defaul1_1.id, defaul1_2.id, defaul1_3.id])
        return res
    }
    init(savedLevels: SavedLevels = .init(),
         gameBoard: CGRect = .init()) {
        self.savedLevels = savedLevels
        self.gameBoard = gameBoard
    }
    func getLevelCollection() -> [Level] {
        savedLevels.levels
    }
    func delete(level: Level) {
        savedLevels.delete(level: level)
    }
    func getLevelCollectionWithDefault() -> [Level] {
        var res = [Level]()
        res.append(contentsOf: [defaul1_1, defaul1_2, defaul1_3])
        res.append(contentsOf: savedLevels.levels)
        return res
    }
}
