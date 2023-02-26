//
//  GameLogicDelegate.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 11/2/23.
//

protocol GameLogicDelegate: AnyObject {
    var cannonBall: CannonBall? { get set }
    var bucket: Bucket { get set }
    func unloadCannonBall()
    func markDestroyedPeggleObject(_ obj: PeggleObject)
    func increCannonCount()
    func processWinCondition()
    func procesLoseCondition()
    func processTimer()
    func updateTimer(_ time: Double)
    func getOrangeBallLeft() -> Int
    func updatePoint(_ points: Int)
    func updateSiamBall()
    func playCollideSoundEffect()
    func playKaBoomSound()
    func playSpookySound()
    func playFreeBallSound()
}
