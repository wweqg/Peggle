//
//  PeggleObject.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 21/1/23.
//
import Foundation

class PeggleObject: Hashable, Identifiable, Codable {
    private(set) var id = UUID()
    var coordinate: Point
    var willBeDestroyed: Bool
    init(coordinate: Point = .ZERO,
         willBeDestroyed: Bool = false) {
        self.coordinate = coordinate
        self.willBeDestroyed = willBeDestroyed
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PeggleObject, rhs: PeggleObject) -> Bool {
        lhs.id == rhs.id
    }
    func moveTo(coordinate: Point) {
        self.coordinate = coordinate
    }
    func isOverlaping(_ peggleObj: PeggleObject) -> Bool {
        false
    }
    func isOverlaping(peg: Peg) -> Bool {
        false
    }
    func isOverlaping(rect: Rectangle) -> Bool {
        false
    }
    func restoreState(from peggleObj: PeggleObject) {
    }
    func getDeepCopy() -> PeggleObject {
        PeggleObject(coordinate: self.coordinate, willBeDestroyed: self.willBeDestroyed)
    }
    func toPhysicsBody(_ initialVector: Vector?) -> PhysicsBody {
        CircleBody()
    }
    func resizeObject(location: Point) {
    }
}
