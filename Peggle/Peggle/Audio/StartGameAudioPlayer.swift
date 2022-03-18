class StartGameAudioPlayer {

    func startgame() {
        AudioPlayer.instance.playMusic(musicFileName: "startGameMusic")
    }

    func endGame() {
        AudioPlayer.instance.playMusic(musicFileName: "backgroundMusic")
    }

    func explode() {
        AudioPlayer.instance.playSoundEffect(soundFileNames: "kaboom")
    }

    func spookyball() {
        AudioPlayer.instance.playSoundEffect(soundFileNames: "spookyball")
    }

    func freeBall() {
        AudioPlayer.instance.playSoundEffect(soundFileNames: "freeBall")
    }

    func shootCannonball() {
        AudioPlayer.instance.playSoundEffect(soundFileNames: "shootCannonball")
    }
}
