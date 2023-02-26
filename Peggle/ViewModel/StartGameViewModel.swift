//
//  StartGameViewModel.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 5/2/23.
//

import Foundation

class StartGameViewModel: ObservableObject, GameLogicDelegate {
    @Published var currLevel: Level
    @Published var rotation = 0.0
    @Published var cannonBallInPlay = false
    @Published var bucket: Bucket
    @Published var isGameWon = false
    @Published var isGameLost = false
    @Published var points = 0
    @Published var timer: Double = 100.0
    @Published var siamBall: Int?
    @Published var targetScore: Int?
    @Published var isTimerUp = false
    var cannon: Cannon
    var cannonBall: CannonBall?
    var cannonBallCount = 10
    var gameMode = GameMode.normal
    private var cannonPointingAt: Point
    var gameBoard: CGRect
    var pegEngine: PegEngine
    var audioPlayer = PeggleAudioPlayer()
    var pegs: [Peg] {
        currLevel.getPegs()
    }
    var rects: [Rectangle] {
        currLevel.getRects()
    }
    var readyToLaunchNextBall: Bool {
        !cannonBallInPlay
    }
    var peggleObj: [PeggleObject] {
        var res = [PeggleObject]()
        res.append(contentsOf: pegs)
        res.append(bucket)
        res.append(contentsOf: rects)
        return res
    }
    var numOfOrangeBallsLeft: Int {
        var num = 0
        for peg in pegs where peg.pegType == PegType.orangePeg && !peg.willBeDestroyed {
            num += 1
        }
        return num
    }
    var numOfBlueBallsLeft: Int {
        var num = 0
        for peg in pegs where peg.pegType == PegType.bluePeg && !peg.willBeDestroyed {
            num += 1
        }
        return num
    }
    var numOfSpecialBallsLeft: Int {
        var num = 0
        for peg in pegs where peg.pegType != PegType.orangePeg
            && peg.pegType != PegType.bluePeg && !peg.willBeDestroyed {
            num += 1
        }
        return num
    }
    init(currLevel: Level = Level(),
         gameBoard: CGRect = .zero,
         cannon: Cannon = Cannon(),
         bucket: Bucket = Bucket(),
         pegEngine: PegEngine = .init()) {
        self.currLevel = currLevel
        self.gameBoard = gameBoard
        self.cannon = cannon
        self.bucket = bucket
        self.pegEngine = pegEngine
        self.cannonBall = nil
        self.cannonPointingAt = Point(xCoordinate: gameBoard.maxX, yCoordinate: gameBoard.minY)
        self.pegEngine.setWorldBound(bound: gameBoard)
        self.pegEngine.setDisplayDelegate(delegate: self)
        self.pegEngine.setLogicDelegate(delegate: self)
        self.bucket.moveTo(coordinate: Point(xCoordinate: gameBoard.midX,
                                             yCoordinate: gameBoard.maxY - self.bucket.size))
        self.cannon.moveTo(coordinate: Point(xCoordinate: gameBoard.midX,
                                             yCoordinate: gameBoard.minY + self.cannon.size))
        self.audioPlayer.startgame()
    }
    func start() {
        self.cannonBallCount = 10
        self.pegEngine.startGame(logic: self, display: self)
    }
    func endGame() {
        self.rotation = 0.0
        self.cannonBallInPlay = false
        self.cannonBall = nil
        self.cannonPointingAt = Point(xCoordinate: gameBoard.maxX, yCoordinate: gameBoard.minY)
        self.bucket.moveTo(coordinate: Point(xCoordinate: gameBoard.midX,
                                             yCoordinate: gameBoard.maxY - self.bucket.size))
        self.cannon.moveTo(coordinate: Point(xCoordinate: gameBoard.midX,
                                             yCoordinate: gameBoard.minY + self.cannon.size))
        isGameWon = false
        isGameLost = false
        isTimerUp = false
        points = 0
        self.pegEngine.endGame()
        gameMode = GameMode.normal
        timer = 100.0
        targetScore = nil
        siamBall = nil
    }
    func setLevel(_ level: Level) {
        self.currLevel = level
        self.pegEngine.loadLevel(peggleObj: peggleObj)
    }
    func setGameMode(_ gameMode: GameMode) {
        if gameMode == GameMode.beatScore {
            self.gameMode = gameMode
            let numOfNormalPegs = pegs.count - numOfOrangeBallsLeft
            targetScore = (numOfNormalPegs * 17 * numOfOrangeBallsLeft * 10) +
                (pegs.count - numOfOrangeBallsLeft - numOfBlueBallsLeft) * 10
            if var target = targetScore, target < 10_000 {
                if numOfOrangeBallsLeft != 0 {
                    target += 10_000
                    targetScore = target
                }
            }
            timer = Double(numOfOrangeBallsLeft) * 6.0 + Double(numOfBlueBallsLeft) * 2.0
                + Double(numOfSpecialBallsLeft) * 3.0
            if timer <= 0 {
                timer = 100
            }

            start()
        } else if gameMode == GameMode.siam {
            self.gameMode = gameMode
            if pegs.isEmpty {
                siamBall = 0
            } else if 1...2 ~= pegs.count {
                siamBall = 10
            } else if 3...7 ~= pegs.count {
                siamBall = 5
            } else if 8...11 ~= pegs.count {
                siamBall = 3
            } else if 12...15 ~= pegs.count {
                siamBall = 2
            } else {
                siamBall = 1
            }
            start()
        } else {
            start()
        }
    }
    func backgroundOnTapGesture() {
        fireCannonBall()
    }
    func defaultAllPeggleObj() {
        currLevel.defaultPegs()
        currLevel.defaultRects()
    }
    func backgroundOnDragGesture(point: Point) {
        setCannonRotation(point: point)
    }
    func moveGameObject(_ obj: PeggleObject, newLocation: Point) {
        objectWillChange.send()
        obj.moveTo(coordinate: newLocation)
    }
    func haveCannonBall() -> Bool {
        cannonBallCount > 0
    }
    func loadCannonBall() {
        self.cannonBall = CannonBall(coordinate: cannon.coordinate)
        cannonBallCount -= 1
        cannonBallInPlay = true
    }
    func unloadCannonBall() {
        self.cannonBall = nil
        cannonBallInPlay = false
    }
    private func fireCannonBall() {
        guard haveCannonBall(), readyToLaunchNextBall else {
            return
        }
        cannon.shoot = true
        loadCannonBall()
        guard let cannonBall = self.cannonBall else {
            return
        }
        audioPlayer.shootCannonball()
        pegEngine.fireCannonBall(cannonBall, cannonPointingAt)
        cannon.shoot = false
    }
    private func setCannonRotation(point: Point) {
        let cannonPosition = cannon.coordinate
        let centerHorizontalAxis = Vector(x: cannonPosition.xCoordinate * 2, y: cannonPosition.yCoordinate)
        let directionOfAim = Vector(x: point.xCoordinate - cannonPosition.xCoordinate,
                                    y: point.yCoordinate - cannonPosition.yCoordinate)
        let angleOfRotation = centerHorizontalAxis.angle(with: directionOfAim)
        rotation = angleOfRotation
        self.cannonPointingAt = point
    }

}
