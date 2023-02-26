//
//  Peg.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//
import Foundation
import SwiftUI

class Peg: PeggleObject {
    private(set) var defaultRadius = 30.0
    var radius: Double
    var pegType: PegType
    private var minRadius = 15.0
    private var maxRadius = 90.0
    private enum CodingKeys: String, CodingKey {
        case radius
        case pegType
    }
    init(radius: Double, pegType: PegType, coordinate: Point = .ZERO) {
        self.pegType = pegType
        self.radius = radius
        super.init(coordinate: coordinate)
    }
    init(pegType: PegType, coordinate: Point = .ZERO) {
        self.radius = defaultRadius
        self.pegType = pegType
        super.init(coordinate: coordinate)
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pegType = try container.decode(PegType.self, forKey: .pegType)
        radius = try container.decode(Double.self, forKey: .radius)
        try super.init(from: decoder)
    }
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pegType, forKey: .pegType)
        try container.encode(radius, forKey: .radius)
        try super.encode(to: encoder)
    }
    override func getDeepCopy() -> Peg {
        Peg(radius: self.radius, pegType: self.pegType, coordinate: self.coordinate)
    }
    override func restoreState(from peggleObj: PeggleObject) {
        guard let peg = peggleObj as? Peg else {
            fatalError("Restore state from a NonPeg")
        }
        self.pegType = peg.pegType
        self.radius = peg.radius
        self.coordinate = peg.coordinate
    }
    func isFullyAbove(yCoordinate: Double) -> Bool {
        self.coordinate.yCoordinate > yCoordinate + self.radius
    }
    func isFullyBelow(yCoordinate: Double) -> Bool {
        self.coordinate.yCoordinate + radius < yCoordinate
    }
    func isFullyRight(xCoordinate: Double) -> Bool {
        self.coordinate.xCoordinate > xCoordinate + self.radius
    }
    func isFullyLeft(xCoordinate: Double) -> Bool {
        self.coordinate.xCoordinate + radius < xCoordinate
    }
    override func isOverlaping(_ peggleObj: PeggleObject) -> Bool {
        peggleObj.isOverlaping(peg: self)
    }
    override func isOverlaping(peg: Peg) -> Bool {
        let distance = sqrt(pow((self.coordinate.xCoordinate - peg.coordinate.xCoordinate), 2)
                            + pow((self.coordinate.yCoordinate - peg.coordinate.yCoordinate), 2))
        let sumOfRadii = self.radius + peg.radius
        return distance <= sumOfRadii
    }
    override func isOverlaping(rect: Rectangle) -> Bool {
        let rectHalfWidth = rect.width / 2
        let rectHalfHeight = rect.height / 2
        let rectMinX = rect.coordinate.xCoordinate - rectHalfWidth
        let rectMaxX = rect.coordinate.xCoordinate + rectHalfWidth
        let rectMinY = rect.coordinate.yCoordinate - rectHalfHeight
        let rectMaxY = rect.coordinate.yCoordinate + rectHalfHeight

        let closestX = max(rectMinX, min(coordinate.xCoordinate, rectMaxX))
        let closestY = max(rectMinY, min(coordinate.yCoordinate, rectMaxY))

        let dx = coordinate.xCoordinate - closestX
        let dy = coordinate.yCoordinate - closestY

        return (dx * dx + dy * dy) <= (radius * radius)
    }
    override func toPhysicsBody(_ initialVector: Vector?) -> PhysicsBody {
        if pegType == PegType.KaBoomPeg {
            let set: Set<Ability> = [Ability.kaBoomBall]
            return CircleBody(restitution: 0.6,
                              radius: radius,
                              position: coordinate,
                              canBeDestroyed: true,
                              abilities: set)
        } else if pegType == PegType.spookyPeg {
            let set: Set<Ability> = [Ability.spookyBall]
            return CircleBody(restitution: 0.6,
                              radius: radius,
                              position: coordinate,
                              canBeDestroyed: true,
                              abilities: set)
        } else {
           return CircleBody(restitution: 0.6, radius: radius, position: coordinate, canBeDestroyed: true)
        }
    }
    override func resizeObject(location: Point) {
        let distance = distanceBetweenPoints(point1: self.coordinate, point2: location)
        if distance < minRadius {
            self.radius = minRadius
        } else if distance > maxRadius {
            self.radius = maxRadius
        } else {
            self.radius = distance
        }
    }
    func distanceBetweenPoints(point1: Point, point2: Point) -> Double {
        let dx = Double(point2.xCoordinate - point1.xCoordinate)
        let dy = Double(point2.yCoordinate - point1.yCoordinate)
        return sqrt(dx * dx + dy * dy)
    }
}
