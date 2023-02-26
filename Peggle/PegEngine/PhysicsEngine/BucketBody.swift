//
//  BucketBody.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 24/2/23.
//
import SwiftUI

class BucketBody: PhysicsBody {
    var velocity: Vector
    var position: Point
    var restitution: Double = 0.0
    var canMove: Bool
    var isDestroyed: Bool
    var affectedByGravity: Bool
    var canBeDestroyed: Bool
    var height: Double
    var width: Double
    var size: Double
    var abilities: Set<Ability>
    init(velocity: Vector = Vector(),
         restitution: Double = 1.0,
         canMove: Bool = false,
         affectedByGravity: Bool = false,
         position: Point = .ZERO,
         isDestroyed: Bool = false,
         height: Double = .zero,
         width: Double = .zero,
         canBeDestroyed: Bool = false,
         abilities: Set<Ability> = Set()) {
        self.velocity = velocity
        self.restitution = restitution
        self.canMove = canMove
        self.affectedByGravity = affectedByGravity
        self.position = position
        self.isDestroyed = isDestroyed
        self.width = width
        self.height = height
        self.canBeDestroyed = canBeDestroyed
        self.abilities = abilities
        self.size = width
    }
    func isOutOfBounds(minX: Double, maxX: Double, minY: Double, maxY: Double) -> Bool {
        collideWithHorizontalEdge(xCoor: minX - width) || collideWithHorizontalEdge(xCoor: maxX + width) ||
        collideWithVerticalEdge(yCoor: minY - height) || collideWithVerticalEdge(yCoor: maxY + height)
    }
    func isIntersecting(phyBody: PhysicsBody) -> Bool {
        phyBody.isIntersecting(bucketBody: self)
    }
    func collideWithHorizontalEdge(xCoor: Double) -> Bool {
        abs(self.position.xCoordinate - xCoor) < (self.width / 2)
    }
    func collideWithVerticalEdge(yCoor: Double) -> Bool {
        abs(self.position.yCoordinate - yCoor) < (self.height / 2)
    }
    func resolveCollisionsWith(phyBody: PhysicsBody) {
        phyBody.resolveCollisionsWith(bucketBody: self)
    }
    func isIntersecting(circleBody: CircleBody) -> Bool {
        let rectHalfWidth = width / 2
        let rectHalfHeight = height / 2
        let rectMinX = position.xCoordinate - rectHalfWidth
        let rectMaxX = position.xCoordinate + rectHalfWidth
        let rectMinY = position.yCoordinate - rectHalfHeight + (height / 3)
        let rectMaxY = position.yCoordinate + rectHalfHeight

        let closestX = max(rectMinX, min(circleBody.position.xCoordinate, rectMaxX))
        let closestY = max(rectMinY, min(circleBody.position.yCoordinate, rectMaxY))

        let dx = circleBody.position.xCoordinate - closestX
        let dy = circleBody.position.yCoordinate - closestY

        return (dx * dx + dy * dy) <= (circleBody.radius * circleBody.radius)
    }
    func isIntersecting(rectangleBody: RectangleBody) -> Bool {
        false
    }
    func resolveCollisionsWith(circleBody: CircleBody) {
        let collisionVector = Vector(x: circleBody.position.xCoordinate
                                     - self.position.xCoordinate,
                                     y: circleBody.position.yCoordinate
                                     - self.position.yCoordinate)
        let relativeVelocity = Vector().subtract(circleBody.velocity)
        let tempSpeed = (relativeVelocity.x * collisionVector.x +
                         relativeVelocity.y * collisionVector.y)
        let speedAfterRestitution = Double(tempSpeed) * restitution * (1 / 23)
        if speedAfterRestitution >= 0 {
            if circleBody.canMove {
                circleBody.velocity = circleBody.velocity
                    .add(to: collisionVector.scalarMultiply(with: speedAfterRestitution))
            }
        }
    }
    func resolveCollisionsWith(rectBody: RectangleBody) {
    }
    func isIntersecting(bucketBody: BucketBody) -> Bool {
        false
    }
    func resolveCollisionsWith(bucketBody: BucketBody) {
    }
    func collisionDetected(rect: BucketBody, circle: CircleBody) -> Bool {
        let x = rect.position.xCoordinate
        let y = rect.position.yCoordinate
        let h = rect.height
        let w = rect.width
        let cx = circle.position.xCoordinate
        let cy = circle.position.yCoordinate
        let r = circle.radius
        // Find the four corners of the rectangle
        let topLeft = CGPoint(x: x - w / 2, y: y - h / 2)
        let topRight = CGPoint(x: x + w / 2, y: y + h / 2)
        let bottomLeft = CGPoint(x: x - w / 2, y: y + h / 2)
        let bottomRight = CGPoint(x: x + w / 2, y: y + h / 2)
        // Check if any of the four sides of the rectangle collide with the circle
        if lineCircleCollisionDetected(startPoint: topRight, endPoint: bottomRight, cx: cx, cy: cy, r: r) {
            return true
        }
        if lineCircleCollisionDetected(startPoint: bottomLeft, endPoint: topLeft, cx: cx, cy: cy, r: r) {
            return true
        }
        return false
    }
    func lineCircleCollisionDetected(startPoint: CGPoint, endPoint: CGPoint,
                                     cx: Double, cy: Double, r: Double) -> Bool {
        // Find the closest point on the line segment to the center of the circle
        let closestPoint = closestPointOnLineSegment(startPoint: startPoint, endPoint: endPoint, cx: cx, cy: cy)
        let distance = distanceBetweenPoints(point1: closestPoint, point2: CGPoint(x: cx, y: cy))
        if distance <= r {
            return true
        }
        return false
    }
    func closestPointOnLineSegment(startPoint: CGPoint, endPoint: CGPoint, cx: Double, cy: Double) -> CGPoint {
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let t = ((cx - Double(startPoint.x)) * dx + (cy - Double(startPoint.y)) * dy) / (dx * dx + dy * dy)
        if t < 0 {
            return startPoint
        } else if t > 1 {
            return endPoint
        } else {
            let closestPointX = startPoint.x + t * dx
            let closestPointY = startPoint.y + t * dy
            return CGPoint(x: closestPointX, y: closestPointY)
        }
    }
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> Double {
        let dx = Double(point2.x - point1.x)
        let dy = Double(point2.y - point1.y)
        return sqrt(dx * dx + dy * dy)
    }
}
