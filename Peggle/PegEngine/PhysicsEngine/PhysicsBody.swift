//
//  PhysicsBody.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 10/2/23.
//

protocol PhysicsBody: AnyObject {
    var velocity: Vector { get set }
    var position: Point { get set }
    var restitution: Double { get }
    var canMove: Bool { get set }
    var isDestroyed: Bool { get set }
    var affectedByGravity: Bool { get set }
    var canBeDestroyed: Bool { get }
    var abilities: Set<Ability> { get set }
    var size: Double { get set }
    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool
    func isIntersecting(phyBody: PhysicsBody) -> Bool
    func collideWithHorizontalEdge(xCoor: Double) -> Bool
    func collideWithVerticalEdge(yCoor: Double) -> Bool
    func resolveCollisionsWith(phyBody: PhysicsBody)
    func isIntersecting(circleBody: CircleBody) -> Bool
    func isIntersecting(rectangleBody: RectangleBody) -> Bool
    func isIntersecting(bucketBody: BucketBody) -> Bool
    func resolveCollisionsWith(circleBody: CircleBody)
    func resolveCollisionsWith(rectBody: RectangleBody)
    func resolveCollisionsWith(bucketBody: BucketBody)
}

extension PhysicsBody {
    func getNewVelocity(withGravity: Vector, timeInterval: Double) -> Vector {
        velocity.add(to: withGravity.scalarMultiply(with: timeInterval))
    }
    func getNewPosition(withVector: Vector, timeInterval: Double) -> Point {
        let displacement = velocity.scalarMultiply(with: timeInterval)
        let newPosition = displacement.addTo(point: position)
        return newPosition
    }
    func setVelocity(_ velocity: Vector) {
        self.velocity = velocity
    }
    func moveTo(point: Point) {
        self.position = point
    }
}
