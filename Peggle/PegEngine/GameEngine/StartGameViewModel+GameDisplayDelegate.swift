//
//  StartGameViewModelExtension.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 11/2/23.
//

extension StartGameViewModel: GameDisplayDelegate {
    func didMove(peggleObj: PeggleObject, to: Point) {
        moveGameObject(peggleObj, newLocation: to)
    }
    func markDestroyedPeggleObject(_ obj: PeggleObject) {
        currLevel.markDestroyedPeggleObject(obj)
    }
    func removeDestroyedPeggleObject() {
        currLevel.removedDestroyedPeg()
    }
    func increCannonCount() {
        cannonBallCount += 1
    }
    func procesLoseCondition() {
        switch self.gameMode {
        case GameMode.normal:
            if cannonBallCount == 0 && !cannonBallInPlay && numOfOrangeBallsLeft > 0 {
                self.audioPlayer.lose()
                self.pegEngine.endGame()
                isGameLost = true
            }
        case GameMode.siam:
            if let num = siamBall, num > 0 && cannonBallCount == 0 && !cannonBallInPlay {
                self.audioPlayer.lose()
                self.pegEngine.endGame()
                isGameLost = true
            }
        case GameMode.beatScore:
            if let target = targetScore, self.points < target && cannonBallCount == 0 && !cannonBallInPlay {
                self.audioPlayer.lose()
                self.pegEngine.endGame()
                isGameLost = true
            }
        }
    }
    func processWinCondition() {
        switch self.gameMode {
        case GameMode.normal:
            if numOfOrangeBallsLeft == 0 {
                self.audioPlayer.win()
                self.pegEngine.endGame()
                isGameWon = true
            }
        case GameMode.siam:
            if let num = siamBall, num <= 0 {
                self.audioPlayer.win()
                self.pegEngine.endGame()
                isGameWon = true
            }
        case GameMode.beatScore:
            if let target = targetScore, self.points >= target {
                self.audioPlayer.win()
                self.pegEngine.endGame()
                isGameWon = true
            }
        }
    }
    func updateTimer(_ time: Double) {
        self.timer -= time
    }
    func getOrangeBallLeft() -> Int {
        numOfOrangeBallsLeft
    }
    func updatePoint(_ points: Int) {
        self.points = points
    }
    func updateSiamBall() {
        if var count = siamBall {
            count -= 1
            siamBall = count
        }
    }
    func playSpookySound() {
        self.audioPlayer.spookyball()
    }
    func playKaBoomSound() {
        self.audioPlayer.explode()
    }
    func playFreeBallSound() {
        self.audioPlayer.freeBall()
    }
    func playCollideSoundEffect() {
        self.audioPlayer.collide()
    }
    func processTimer() {
        if self.timer <= 0 {
            self.audioPlayer.lose()
            self.pegEngine.endGame()
            self.isTimerUp = true
        }
    }
}
