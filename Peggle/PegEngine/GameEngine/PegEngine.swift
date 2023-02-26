//
//  PegEngine.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 10/2/23.
//

import Foundation
import SwiftUI

class PegEngine: PhysicsWorldDelegate {

    private var gameLoop: GameLoop
    private var scoreCalculator = ScoreCalculator()
    private var physicsWorld: PhysicsWorld
    private var gameBound: CGRect
    private weak var gameDisplayDelegate: GameDisplayDelegate?
    private weak var gameLogicDelegate: GameLogicDelegate?
    private var mappings: [PeggleObject: PhysicsBody]
    private var collided = false
    init(gameDisplayDelegate: GameDisplayDelegate? = nil,
         gameLoop: GameLoop = GameLoop(),
         physicsWorld: PhysicsWorld = .init(),
         mappings: [PeggleObject: PhysicsBody] = [PeggleObject: PhysicsBody](),
         gameBound: CGRect = .zero) {
        self.gameLoop = gameLoop
        self.physicsWorld = physicsWorld
        self.mappings = mappings
        self.gameBound = gameBound
        self.gameDisplayDelegate = gameDisplayDelegate
        gameLoop.setGameEngine(self)
        self.physicsWorld.setDelegate(delegate: self)
    }
    func update(_ time: Double) {
        physicsWorld.simulatePhysics(timeInterval: time)
        handleExplosion()
        gameLogicDelegate?.processWinCondition()
        gameLogicDelegate?.procesLoseCondition()
        gameLogicDelegate?.updateTimer(time)
        gameLogicDelegate?.processTimer()
    }
    func render() {
        for (peggleObj, phyBody) in mappings {
            let newPosition = phyBody.position
            gameDisplayDelegate?.didMove(peggleObj: peggleObj, to: newPosition)
        }
        if isCannonBallInBucket() {
            gameLogicDelegate?.playFreeBallSound()
            gameLogicDelegate?.increCannonCount()
        }
    }
    func endGame() {
        gameLoop.end()
        physicsWorld.emptyBodies()
        mappings = [:]
        gameLogicDelegate = nil
        gameDisplayDelegate = nil
        scoreCalculator.reset()
        collided = false
    }
    func loadLevel(peggleObj: [PeggleObject]) {
        for obj in peggleObj {
            let newPhyBody = obj.toPhysicsBody(nil)
            mappings[obj] = newPhyBody
            physicsWorld.addPhyBody(phyBody: newPhyBody)
        }
    }
    func fireCannonBall(_ cannonBall: CannonBall, _ cannonPoitingAt: Point) {
        var modifiedDirection = cannonPoitingAt
        if cannonPoitingAt.yCoordinate < cannonBall.coordinate.yCoordinate {
            modifiedDirection = Point(xCoordinate: cannonPoitingAt.xCoordinate,
                                      yCoordinate: cannonBall.coordinate.yCoordinate)
        }
        let initialVector = Vector(x: modifiedDirection.xCoordinate - cannonBall.coordinate.xCoordinate,
                                   y: modifiedDirection.yCoordinate - cannonBall.coordinate.yCoordinate)
        let newPhyBody = cannonBall.toPhysicsBody(initialVector)
        mappings[cannonBall] = newPhyBody
        physicsWorld.addPhyBody(phyBody: newPhyBody)
    }
    func setWorldBound(bound: CGRect) {
        self.gameBound = bound
        self.physicsWorld.setWorldBound(bound: bound)
    }
    func setDisplayDelegate(delegate: GameDisplayDelegate) {
        self.gameDisplayDelegate = delegate
    }
    func setLogicDelegate(delegate: GameLogicDelegate) {
        self.gameLogicDelegate = delegate
    }
    func startGame(logic: GameLogicDelegate, display: GameDisplayDelegate) {
        gameLoop.start()
        self.gameLogicDelegate = logic
        self.gameDisplayDelegate = display
        scoreCalculator.reset()
        collided = false
    }
    func didDestroyedOutOfBoundBody() {
        for (peggleObj, phyBody) in mappings where phyBody.isDestroyed {
            if peggleObj is CannonBall {
                if !collided {
                    collided = false
                    gameLogicDelegate?.updateSiamBall()
                }
                gameLogicDelegate?.unloadCannonBall()
                gameDisplayDelegate?.removeDestroyedPeggleObject()
                /* Remove destroyed pegs from physics world */
                for (peggleObj, phyBody) in mappings where peggleObj.willBeDestroyed {
                    mappings[peggleObj] = nil
                    if phyBody.canBeDestroyed {
                        phyBody.isDestroyed = true
                    }
                }
            }
            peggleObj.willBeDestroyed = true
            mappings[peggleObj] = nil
            if let peg = peggleObj as? Peg, peg.pegType == PegType.zombiePeg {
                peg.willBeDestroyed = true
                gameDisplayDelegate?.removeDestroyedPeggleObject()
            }
        }
    }
    func didCollide() {
        for (peggleObj, phyBody) in mappings where phyBody.isDestroyed {
            if let peg = peggleObj as? Peg, !peg.willBeDestroyed {
                scoreCalculator.updateScore(with: peg, numOrangeBall: gameLogicDelegate?.getOrangeBallLeft() ?? 0)
                gameLogicDelegate?.updatePoint(scoreCalculator.score)
            }
            if peggleObj is Peg {
                phyBody.isDestroyed = false
                gameLogicDelegate?.markDestroyedPeggleObject(peggleObj)
                collided = true
            }
            if let circle = phyBody as? CircleBody {
                if circle.abilities.contains(Ability.kaBoomBall) {
                    circle.exploded = true
                } else if circle.abilities.contains(Ability.spookyBall) {
                    circle.used = true
                }
            }
        }
    }
    private func isCannonBallInBucket() -> Bool {
        guard let bucket = gameLogicDelegate?.bucket, let bucketPhysicsBody = mappings[bucket] as? BucketBody else {
            return false
        }
        guard let cannonBall = gameLogicDelegate?.cannonBall, let cannonPhyBody = mappings[cannonBall] else {
            return false
        }
        let bucketCenter = bucketPhysicsBody.position
        let bucketWidth = bucketPhysicsBody.width
        let bucketHeight = bucketPhysicsBody.height
        let cannonBallCenter = cannonPhyBody.position
        let isInBucket = cannonBallCenter.xCoordinate > bucketCenter.xCoordinate - bucketWidth / 2
            && cannonBallCenter.xCoordinate < bucketCenter.xCoordinate + bucketWidth / 2
            && cannonBallCenter.yCoordinate > bucketCenter.yCoordinate - bucketHeight / 2
            && cannonBallCenter.yCoordinate < bucketCenter.yCoordinate + bucketWidth / 2
        if isInBucket {
            cannonPhyBody.isDestroyed = true
            cannonBall.willBeDestroyed = true
         }
        return isInBucket
    }
    private func handleExplosion() {
        let explodeRadius: Double = 100.0
        var explodedBody: PhysicsBody?
        for (obj, phyBody) in mappings where phyBody.abilities.contains(Ability.kaBoomBall) && obj.willBeDestroyed {
            explodedBody = phyBody
        }
        guard let exploded = explodedBody else {
            return
        }
        for (_, phyBody) in mappings {
            if phyBody.canBeDestroyed && !phyBody.canMove &&
                isWithinExplosionRadius(phyBody: phyBody, explodedBody: exploded, explodeRadius: explodeRadius) {
                phyBody.isDestroyed = true
            }
        }
        didCollide()
    }
    private func isWithinExplosionRadius(phyBody: PhysicsBody,
                                         explodedBody: PhysicsBody, explodeRadius: Double) -> Bool {
        distanceBetweenPoints(point1: explodedBody.position, point2: phyBody.position) <= explodeRadius + phyBody.size
    }
    func distanceBetweenPoints(point1: Point, point2: Point) -> Double {
        let dx = Double(point2.xCoordinate - point1.xCoordinate)
        let dy = Double(point2.yCoordinate - point1.yCoordinate)
        return sqrt(dx * dx + dy * dy)
    }
    func didSpooky() {
        gameLogicDelegate?.playSpookySound()
    }
    func didExplode() {
        gameLogicDelegate?.playKaBoomSound()
    }
    func didBounce() {
        gameLogicDelegate?.playCollideSoundEffect()
    }
}
