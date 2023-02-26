//
//  CircleBody.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 10/2/23.
//

import Foundation

class CircleBody: PhysicsBody {
    var canBeDestroyed: Bool
    var position: Point
    var isDestroyed: Bool
    var velocity: Vector
    var ignoreBound: Bool
    var abilities: Set<Ability>
    var size: Double
    var used: Bool
    var exploded: Bool
    private(set) var restitution: Double
    var canMove: Bool
    var affectedByGravity: Bool
    private(set) var radius: Double
    init(velocity: Vector = Vector(),
         restitution: Double = 1.0,
         canMove: Bool = false,
         affectedByGravity: Bool = false,
         radius: Double = 20.0,
         position: Point = .ZERO,
         isDestroyed: Bool = false,
         canBeDestroyed: Bool = false,
         ignoreBound: Bool = false,
         abilities: Set<Ability> = Set()) {
        self.velocity = velocity
        self.restitution = restitution
        self.canMove = canMove
        self.affectedByGravity = affectedByGravity
        self.radius = radius
        self.position = position
        self.isDestroyed = isDestroyed
        self.canBeDestroyed = canBeDestroyed
        self.ignoreBound = false
        self.abilities = abilities
        self.size = radius
        self.used = false
        self.exploded = false
    }
    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool {
        let res = (position.yCoordinate + radius * 2) > maxY || (position.yCoordinate + radius * 2) < minY
        if res && ignoreBound {
            self.ignoreBound = false
            self.position = Point(xCoordinate: self.position.xCoordinate, yCoordinate: 0.0)
            return false
        } else {
            return res
        }
    }
    func collideWithHorizontalEdge(xCoor: Double) -> Bool {
        abs(self.position.xCoordinate - xCoor) < self.radius
    }
    func collideWithVerticalEdge(yCoor: Double) -> Bool {
        abs(self.position.xCoordinate - yCoor) < self.radius
    }
    func isIntersecting(phyBody: PhysicsBody) -> Bool {
        phyBody.isIntersecting(circleBody: self)
    }
    func isIntersecting(circleBody: CircleBody) -> Bool {
        let distance = sqrt(pow((self.position.xCoordinate - circleBody.position.xCoordinate), 2)
                            + pow((self.position.yCoordinate - circleBody.position.yCoordinate), 2))
        let sumOfRadii = self.radius + circleBody.radius
        return distance <= sumOfRadii
    }
    func isIntersecting(rectangleBody: RectangleBody) -> Bool {
        let rectHalfWidth = rectangleBody.width / 2
        let rectHalfHeight = rectangleBody.height / 2
        let rectMinX = rectangleBody.position.xCoordinate - rectHalfWidth
        let rectMaxX = rectangleBody.position.xCoordinate + rectHalfWidth
        let rectMinY = rectangleBody.position.yCoordinate - rectHalfHeight
        let rectMaxY = rectangleBody.position.yCoordinate + rectHalfHeight

        let closestX = max(rectMinX, min(position.xCoordinate, rectMaxX))
        let closestY = max(rectMinY, min(position.yCoordinate, rectMaxY))

        let dx = position.xCoordinate - closestX
        let dy = position.yCoordinate - closestY

        return (dx * dx + dy * dy) <= (radius * radius)
    }
    func resolveCollisionsWith(phyBody: PhysicsBody) {
        phyBody.resolveCollisionsWith(circleBody: self)
    }
    func resolveCollisionsWith(circleBody: CircleBody) {
        var scale: Double = 1 / 23
        if self.abilities.contains(Ability.kaBoomBall) && !self.exploded {
            self.exploded = true
            scale = 1 / 12
        }
        if circleBody.abilities.contains(Ability.kaBoomBall) && !circleBody.exploded {
            circleBody.exploded = true
            scale = 1 / 12
        }
        if circleBody.abilities.contains(Ability.spookyBall) && !circleBody.used {
            self.ignoreBound = true
            circleBody.used = true
        } else if self.abilities.contains(Ability.spookyBall) && !self.used {
            circleBody.ignoreBound = true
            self.used = true
        }
        let collisionVector = Vector(x: circleBody.position.xCoordinate
                                     - self.position.xCoordinate,
                                     y: circleBody.position.yCoordinate
                                     - self.position.yCoordinate)
        let distance = distanceBetweenPoints(point1: self.position, point2: circleBody.position)
        let collisionNormalVector = Vector(x: collisionVector.x / (distance),
                                           y: collisionVector.y / (distance))
        let relativeVelocity = self.velocity.subtract(circleBody.velocity)
        let tempSpeed = (relativeVelocity.x * collisionVector.x +
                         relativeVelocity.y * collisionVector.y)
        let speedAfterRestitution = Double(tempSpeed) * restitution * scale
        if speedAfterRestitution >= 0 {
            if canMove {
                self.velocity = self.velocity.add(to: collisionNormalVector
                    .scalarMultiply(with: -1 * speedAfterRestitution))
            }
            if circleBody.canMove {
                circleBody.velocity = circleBody.velocity
                    .add(to: collisionVector.scalarMultiply(with: speedAfterRestitution))
            }
        }
    }
    func resolveCollisionsWith(rectBody: RectangleBody) {
        let collisionVector = Vector(x: rectBody.position.xCoordinate
                                     - self.position.xCoordinate,
                                     y: rectBody.position.yCoordinate
                                     - self.position.yCoordinate)
        let distance = distanceBetweenPoints(point1: self.position, point2: rectBody.position)
        let collisionNormalVector = Vector(x: collisionVector.x / (distance),
                                           y: collisionVector.y / (distance))
        let relativeVelocity = self.velocity.subtract(rectBody.velocity)
        let tempSpeed = (relativeVelocity.x * collisionVector.x +
                         relativeVelocity.y * collisionVector.y)
        let speedAfterRestitution = Double(tempSpeed) * restitution * (1 / 40)
        if speedAfterRestitution >= 0 {
            if canMove {
                self.velocity = self.velocity.add(to: collisionNormalVector
                    .scalarMultiply(with: -1 * speedAfterRestitution))
            }
        }
    }
    func isIntersecting(bucketBody: BucketBody) -> Bool {
        let rectHalfWidth = bucketBody.width / 2
        let rectHalfHeight = bucketBody.height / 2
        let rectMinX = bucketBody.position.xCoordinate - rectHalfWidth
        let rectMaxX = bucketBody.position.xCoordinate + rectHalfWidth
        let rectMinY = bucketBody.position.yCoordinate - rectHalfHeight + (bucketBody.height / 3)
        let rectMaxY = bucketBody.position.yCoordinate + rectHalfHeight

        let closestX = max(rectMinX, min(self.position.xCoordinate, rectMaxX))
        let closestY = max(rectMinY, min(self.position.yCoordinate, rectMaxY))

        let dx = self.position.xCoordinate - closestX
        let dy = self.position.yCoordinate - closestY

        return (dx * dx + dy * dy) <= (self.radius * self.radius)
    }
    func resolveCollisionsWith(bucketBody: BucketBody) {
        let collisionVector = Vector(x: bucketBody.position.xCoordinate
                                     - self.position.xCoordinate,
                                     y: bucketBody.position.yCoordinate
                                     - self.position.yCoordinate)
        let distance = distanceBetweenPoints(point1: bucketBody.position, point2: self.position)
        let collisionNormalVector = Vector(x: collisionVector.x / (distance),
                                           y: collisionVector.y / (distance))
        let relativeVelocity = self.velocity.subtract(Vector())
        let tempSpeed = (relativeVelocity.x * collisionVector.x +
                         relativeVelocity.y * collisionVector.y)
        let speedAfterRestitution = Double(tempSpeed) * restitution * (1 / 30)
        if speedAfterRestitution >= 0 {
            if canMove {
                self.velocity = self.velocity.add(to: collisionNormalVector
                    .scalarMultiply(with: -1 * speedAfterRestitution))
            }
        }
    }
    func distanceBetweenPoints(point1: Point, point2: Point) -> Double {
        let dx = Double(point2.xCoordinate - point1.xCoordinate)
        let dy = Double(point2.yCoordinate - point1.yCoordinate)
        return sqrt(dx * dx + dy * dy)
    }

}
