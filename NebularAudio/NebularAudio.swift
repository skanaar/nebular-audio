import AVFoundation

fileprivate func sign(_ x: Float) -> Float {
    if x < 0 { return -1 }
    if x > 0 { return 1 }
    return 0
}

class FadingPlayer {
    let player: AVAudioPlayer
    let speed: Float = 0.01
    var targetVolume: Float = 0

    init(_ player: AVAudioPlayer) {
        self.player = player
    }

    func update(dt: Float) {
        let step = speed * Float(dt)
        if abs(player.volume - targetVolume) < 1.5*step {
            player.volume = targetVolume
        } else {
            player.volume -= step * sign(player.volume - targetVolume)
        }
        if player.isPlaying && player.volume == 0 {
            player.stop()
        }
        if !player.isPlaying && player.volume > 0 {
            player.play()
        }
    }
}

public class NebularAudio {

    private var musicPool = [URL: FadingPlayer]()

    public func update(dt: Double) {
        for (_, e) in musicPool {
            e.update(dt: Float(dt))
        }
    }
    
    public func playMusic(file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else {
            return
        }
        for (_, e) in musicPool {
            e.targetVolume = 0
        }
        let player = buildPlayer(url: url)
        player?.targetVolume = 1
    }
    
    private func buildPlayer(url: URL) -> FadingPlayer? {
        if let player = musicPool[url] {
            return player
        }
        if let audioPlayer = try? AVAudioPlayer(contentsOf: url) {
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0
            let player = FadingPlayer(audioPlayer)
            musicPool[url] = player
            return player
        }
        return nil
    }
}
