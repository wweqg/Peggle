//
//  PhysicsWorld.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 10/2/23.
//

import Foundation
import SwiftUI

class PhysicsWorld {
    private(set) var physicsBodies: [PhysicsBody]
    private(set) var worldBound: CGRect
    private var gravity: Vector
    private weak var physicisWorldDelegate: PhysicsWorldDelegate?
    init(physicsBodies: [PhysicsBody] = [PhysicsBody](),
         worldBound: CGRect = .zero,
         gravity: Vector = Vector(x: 0.0, y: 400.0)) {
        self.physicsBodies = physicsBodies
        self.worldBound = worldBound
        self.gravity = gravity
    }
    func simulatePhysics(timeInterval: Double) {
        simulateGravity(timeInterval: timeInterval)
        generateNewPosition(timeInterval: timeInterval)
        resolveCollisions()
        resolveEdgeCollision()
        destroyOutOfBound()
        removeAllPhysicsBodies(where: { $0.isDestroyed })
    }
    func addPhyBody(phyBody: PhysicsBody) {
        self.physicsBodies.append(phyBody)
    }
    func setWorldBound(bound: CGRect) {
        self.worldBound = bound
    }
    func setDelegate(delegate: PhysicsWorldDelegate) {
        self.physicisWorldDelegate = delegate
    }
    func emptyBodies() {
        self.physicsBodies = [PhysicsBody]()
    }
    private func simulateGravity(timeInterval: Double) {
        for obj in physicsBodies where obj.affectedByGravity {
            let newVelocity = obj.getNewVelocity(withGravity: gravity, timeInterval: timeInterval)
            obj.setVelocity(newVelocity)
        }
    }
    private func generateNewPosition(timeInterval: Double) {
        for obj in physicsBodies where obj.canMove {
            let newPosition = obj.getNewPosition(withVector: obj.velocity, timeInterval: timeInterval)
            obj.moveTo(point: newPosition)
        }
    }
    private func resolveCollisions() {
        for indexOfFirstBody in 0 ..< physicsBodies.count {
            let firstBody = physicsBodies[indexOfFirstBody]
            for indexOfSecondBody in indexOfFirstBody + 1 ..< physicsBodies.count {
                let secondBody = physicsBodies[indexOfSecondBody]
                guard firstBody.canMove || secondBody.canMove else {
                    continue
                }
                if firstBody.isIntersecting(phyBody: secondBody) {
                    if let first = firstBody as? CircleBody {
                        if first.abilities.contains(Ability.spookyBall)
                            && !first.used {
                            physicisWorldDelegate?.didSpooky()
                        } else if first.abilities.contains(Ability.kaBoomBall)
                            && !first.exploded {
                            physicisWorldDelegate?.didExplode()
                        }
                    } else if let second = secondBody as? CircleBody {
                        if second.abilities.contains(Ability.spookyBall)
                            && !second.used {
                            physicisWorldDelegate?.didSpooky()
                        } else if second.abilities.contains(Ability.kaBoomBall)
                            && !second.exploded {
                            physicisWorldDelegate?.didExplode()
                        }
                    } else {
                        physicisWorldDelegate?.didBounce()
                    }
                    markSelectedToBeDestroyed(firstBody)
                    markSelectedToBeDestroyed(secondBody)
                    firstBody.resolveCollisionsWith(phyBody: secondBody)
                    physicisWorldDelegate?.didCollide()
                }
            }
        }
    }
    private func markSelectedToBeDestroyed(_ obj: PhysicsBody) {
        if obj.canBeDestroyed && !obj.canMove {
            obj.isDestroyed = true
        }
    }
    private func resolveEdgeCollision() {
        resolveHorizontalEdgeCollision()
    }
    private func resolveHorizontalEdgeCollision() {
        for obj in physicsBodies where obj.canMove {
            var newChangeInX: Double?

            if obj.collideWithHorizontalEdge(xCoor: worldBound.minX) {
                if obj is CircleBody {
                    physicisWorldDelegate?.didBounce()
                }
                newChangeInX = abs(obj.velocity.x) * obj.restitution
            } else if obj.collideWithHorizontalEdge(xCoor: worldBound.maxX) {
                if obj is CircleBody {
                    physicisWorldDelegate?.didBounce()
                }
                newChangeInX = -abs(obj.velocity.x) * obj.restitution
            }

            if let newChangeInX = newChangeInX {
                let newVelocity = Vector(x: newChangeInX, y: obj.velocity.y)
                obj.setVelocity(newVelocity)
            }
        }
    }
    private func destroyOutOfBound() {
        for obj in physicsBodies where obj.canBeDestroyed &&
            obj.isOutOfBounds(minX: worldBound.minX,
                              maxX: worldBound.maxX,
                              minY: worldBound.minY,
                              maxY: worldBound.maxY) {
                obj.isDestroyed = true
        }
        physicisWorldDelegate?.didDestroyedOutOfBoundBody()
    }
    private func removeAllPhysicsBodies(where shouldBeRemoved: (PhysicsBody) -> Bool) {
        physicsBodies.removeAll(where: shouldBeRemoved)
    }
}
