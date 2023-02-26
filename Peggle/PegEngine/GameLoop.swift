//
//  GameLoop.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 10/2/23.
//

import QuartzCore

class GameLoop {
    private let updateRate: Double
    private var displayLink: CADisplayLink?
    private var previous: Double
    private var lag: Double

    weak var gameEngine: PegEngine?
    init(framesPerSecond: Double = 120.0) {
        self.updateRate = 1.0 / framesPerSecond
        self.previous = CACurrentMediaTime()
        self.lag = 0.0
    }
    func setGameEngine(_ gameEngine: PegEngine) {
        self.gameEngine = gameEngine
    }

    func start() {
        previous = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .current, forMode: .default)
    }
    func end() {
        self.lag = 0.0
        self.displayLink = nil
    }
    @objc private func update() {
        let current: Double = CACurrentMediaTime()
        let elapsed: Double = current - previous
        previous = current
        lag += elapsed

        while lag >= updateRate {
            gameEngine?.update(updateRate)
            lag -= updateRate
        }
        gameEngine?.render()
    }
}
