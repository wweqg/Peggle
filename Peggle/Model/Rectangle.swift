//
//  Rectangle.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 25/2/23.
//
import Foundation

class Rectangle: PeggleObject {
    var height: Double
    var width: Double
    private var minWidth = 64.0
    private var maxWidth = 256.0
    init(height: Double = 80.0,
         width: Double = 128.0,
         coordinate: Point = .ZERO) {
        self.height = height
        self.width = width
        super.init(coordinate: coordinate)
    }
    private enum CodingKeys: String, CodingKey {
        case height
        case width
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decode(Double.self, forKey: .height)
        width = try container.decode(Double.self, forKey: .width)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try super.encode(to: encoder)
    }
    override func getDeepCopy() -> Rectangle {
        Rectangle(height: self.height, width: self.width, coordinate: self.coordinate)
    }
    override func restoreState(from peggleObj: PeggleObject) {
        guard let rect = peggleObj as? Rectangle else {
            fatalError("Restore state from a NonRectangle")
        }
        self.height = rect.height
        self.width = rect.width
        self.coordinate = rect.coordinate
    }
    override func toPhysicsBody(_ initialVector: Vector?) -> PhysicsBody {
        RectangleBody(restitution: 0.6, position: self.coordinate, height: self.height, width: self.width)
    }
    override func isOverlaping(_ peggleObj: PeggleObject) -> Bool {
        peggleObj.isOverlaping(rect: self)
    }
    override func isOverlaping(peg: Peg) -> Bool {
        let rectHalfWidth = self.width / 2
        let rectHalfHeight = self.height / 2
        let rectMinX = self.coordinate.xCoordinate - rectHalfWidth
        let rectMaxX = self.coordinate.xCoordinate + rectHalfWidth
        let rectMinY = self.coordinate.yCoordinate - rectHalfHeight
        let rectMaxY = self.coordinate.yCoordinate + rectHalfHeight

        let closestX = max(rectMinX, min(peg.coordinate.xCoordinate, rectMaxX))
        let closestY = max(rectMinY, min(peg.coordinate.yCoordinate, rectMaxY))

        let dx = peg.coordinate.xCoordinate - closestX
        let dy = peg.coordinate.yCoordinate - closestY

        return (dx * dx + dy * dy) <= (peg.radius * peg.radius)
    }
    override func isOverlaping(rect: Rectangle) -> Bool {
        let leftX = max(self.coordinate.xCoordinate, rect.coordinate.xCoordinate)
        let rightX = min(self.coordinate.xCoordinate + self.width, rect.coordinate.xCoordinate + rect.width)
        let topY = max(self.coordinate.yCoordinate, rect.coordinate.yCoordinate)
        let bottomY = min(self.coordinate.yCoordinate + self.height, rect.coordinate.yCoordinate + rect.height)
        if leftX < rightX && topY < bottomY {
            return true
        }
        return false
    }
    func isFullyAbove(yCoordinate: Double) -> Bool {
        self.coordinate.yCoordinate > yCoordinate + self.height / 2
    }
    func isFullyBelow(yCoordinate: Double) -> Bool {
        self.coordinate.yCoordinate + self.height / 2 < yCoordinate
    }
    func isFullyRight(xCoordinate: Double) -> Bool {
        self.coordinate.xCoordinate > xCoordinate + self.width / 2
    }
    func isFullyLeft(xCoordinate: Double) -> Bool {
        self.coordinate.xCoordinate + self.width / 2 < xCoordinate
    }
    override func resizeObject(location: Point) {
        let scale = height / width
        let distance = distanceBetweenPoints(point1: self.coordinate, point2: location)
        if distance < (minWidth / 2) {
            self.width = minWidth
            self.height = minWidth * scale
        } else if distance > (maxWidth / 2) {
            self.width = maxWidth
            self.height = maxWidth * scale
        } else {
            self.width = distance
            self.height = distance * scale
        }
    }
    func distanceBetweenPoints(point1: Point, point2: Point) -> Double {
        let dx = Double(point2.xCoordinate - point1.xCoordinate)
        let dy = Double(point2.yCoordinate - point1.yCoordinate)
        return sqrt(dx * dx + dy * dy)
    }
}
