import Foundation
import AVFoundation

// Audio player adapted from:
// https://stackoverflow.com/questions/36865233/get-avaudioplayer-to-play-multiple-sounds-at-a-time
class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    static let instance = AudioPlayer()

    private override init() {
        super.init()
        playBackgroundMusic()
    }

    var players = [NSURL: AVAudioPlayer]()
    var duplicatePlayers = [AVAudioPlayer]()

    static func initialiseAudioPlayer() -> AudioPlayer {
        instance
    }

    private func playAudio(withFileName audioFileName: String, numberOfLoops: Int, volume: Float) {
        if let bundle = Bundle.main.path(forResource: audioFileName, ofType: "mp3") {
            let audio = NSURL(fileURLWithPath: bundle)

            do {
                if let player = players[audio] {

                    if player.isPlaying {
                        let duplicatePlayer = try AVAudioPlayer(contentsOf: audio as URL)
                        duplicatePlayer.delegate = self
                        duplicatePlayers.append(duplicatePlayer)
                        duplicatePlayer.numberOfLoops = numberOfLoops
                        duplicatePlayer.prepareToPlay()
                        duplicatePlayer.play()
                        duplicatePlayer.volume = volume
                    } else {
                        player.numberOfLoops = numberOfLoops
                        player.prepareToPlay()
                        player.play()
                        player.volume = volume
                    }

                } else {

                    let player = try AVAudioPlayer(contentsOf: audio as URL)
                    players[audio] = player
                    player.numberOfLoops = numberOfLoops
                    player.prepareToPlay()
                    player.play()
                    player.volume = volume

                }
            } catch {
                print(error)
            }
        }
    }

    func playSoundEffect(soundFileNames: String...) {
        for soundFileName in soundFileNames {
            playAudio(withFileName: soundFileName, numberOfLoops: 0, volume: 1.0)
        }
    }

    func playMusic(musicFileName: String) {
        players = [:]
        duplicatePlayers = []
        playAudio(withFileName: musicFileName, numberOfLoops: -1, volume: 0.7)
    }

    private func playBackgroundMusic() {
        playMusic(musicFileName: "backgroundMusic")
    }

}
