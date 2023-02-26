//
//  ScoreCalculator.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 25/2/23.
//

class ScoreCalculator {
    var score = 0
    init(score: Int = 0) {
        self.score = score
    }
    func reset() {
        self.score = 0
    }
    func updateScore(with peg: Peg, numOrangeBall: Int) {
        score += getBaseScore(for: peg) * getMultiplier(orangePegCount: numOrangeBall)
    }
    func getMultiplier(orangePegCount: Int) -> Int {
        let num = orangePegCount - 1
        if num <= 0 {
            return 100
        } else if 1...3 ~= num {
            return 10
        } else if 4...7 ~= num {
            return 5
        } else if 8...10 ~= num {
            return 3
        } else if 11...15 ~= num {
            return 2
        } else {
            return 1
        }
    }
    private func getBaseScore(for peg: Peg) -> Int {
        switch peg.pegType {
        case .bluePeg, .KaBoomPeg, .spookyPeg, .zombiePeg:
            return 10
        case .orangePeg:
            return 100
        }
    }
}
