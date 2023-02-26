//
//  PeggleAudioPlayer.swift
//  Peggle
//
//  Created by Weiqiang Zhang on 26/2/23.
//

class PeggleAudioPlayer {
    func startgame() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "Background")
    }
    func endGame() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "Background")
    }
    func explode() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "kaboom")
    }

    func spookyball() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "spookyBall")
    }

    func freeBall() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "freeBall")
    }
    func win() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "win")
    }
    func lose() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "lose")
    }
    func collide() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "bounce")
    }
    func shootCannonball() {
        AudioPlayer.sharedInstance.playSounds(soundFileNames: "fireBall")
    }
}
