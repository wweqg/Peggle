//
//  Level.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//

import Foundation

struct Level: Identifiable, Codable, Equatable {
    private(set) var id = UUID()
    var levelName: String
    var pegs: [Peg]
    var rectangles: [Rectangle]
    var peggleObjects: [PeggleObject] {
        var res = [PeggleObject]()
        res.append(contentsOf: pegs)
        res.append(contentsOf: rectangles)
        return res
    }
    private enum CodingKeys: String, CodingKey {
        case levelName
        case pegs
        case rectangles
    }
    init(levelName: String = "", pegs: [Peg] = [Peg](), rectangles: [Rectangle] = [Rectangle]()) {
        self.levelName = levelName
        self.pegs = pegs
        self.rectangles = rectangles
    }
    func getPegs() -> [Peg] {
        pegs
    }
    func getRects() -> [Rectangle] {
        rectangles
    }
    mutating func defaultPegs() {
        for peg in pegs {
            peg.willBeDestroyed = false
        }
    }
    mutating func defaultRects() {
        for rect in rectangles {
            rect.willBeDestroyed = false
        }
    }
    mutating func addPeg(_ peg: Peg) {
        pegs.append(peg)
    }
    mutating func addRect(_ rect: Rectangle) {
        rectangles.append(rect)
    }
    mutating func removePeg(_ peg: Peg) {
        guard let index = pegs.firstIndex(of: peg) else {
            return
        }
        pegs.remove(at: index)
    }
    mutating func removeRect(_ rect: Rectangle) {
        guard let index = rectangles.firstIndex(of: rect) else {
            return
        }
        rectangles.remove(at: index)
    }
    mutating func moveSelectedPegTo(coordinate: Point, _ selectedPeg: Peg) {
        selectedPeg.moveTo(coordinate: coordinate)
    }
    mutating func moveSelectedRectTo(coordinate: Point, _ selectedRect: Rectangle) {
        selectedRect.moveTo(coordinate: coordinate)
    }
    mutating func copy(level: Level) {
        self.levelName = level.levelName
        self.pegs = level.pegs
        self.rectangles = level.rectangles
    }
    mutating func markDestroyedPeggleObject(_ obj: PeggleObject) {
        obj.willBeDestroyed = true
    }
    mutating func removedDestroyedPeg() {
        pegs.removeAll(where: { $0.willBeDestroyed })
    }
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id
    }
    mutating func resizeObject(peggleObject: PeggleObject, location: Point) {
        if let peg = peggleObject as? Peg {
            peg.resizeObject(location: location)
        } else if let rect = peggleObject as? Rectangle {
            rect.resizeObject(location: location)
        }
    }
    func getDeepCopy() -> Level {
        var levelCopy = Level()
        var pegsCopy = [Peg]()
        var rectsCopy = [Rectangle]()
        for peg in pegs {
            let copy = peg.getDeepCopy()
            pegsCopy.append(copy)
        }
        for rect in rectsCopy {
            let copy = rect.getDeepCopy()
            rectsCopy.append(copy)
        }
        levelCopy.id = self.id
        levelCopy.levelName = self.levelName
        levelCopy.pegs = pegsCopy
        levelCopy.rectangles = rectsCopy
        return levelCopy
    }
}
