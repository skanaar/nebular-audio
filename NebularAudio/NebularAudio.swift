import AVFoundation

fileprivate func sign(_ x: Float) -> Float {
    if x < 0 { return -1 }
    if x > 0 { return 1 }
    return 0
}

class FadingPlayer {
    let player: AVAudioPlayer
    var crossFade: Float
    var targetVolume: Float = 0
    
    init(_ player: AVAudioPlayer, crossFade: Float) {
        self.player = player
        self.crossFade = crossFade
    }
    
    func update(dt: Float) {
        let step = Float(dt) / crossFade
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

public class MusicPlayer {
    
    private var musicPool = [URL: FadingPlayer]()
    
    public func update(dt: Double) {
        for (_, e) in musicPool {
            e.update(dt: Float(dt))
        }
    }
    
    public func playMusic(file: String, crossFade: Float) {
        guard let url = Bundle.main.url(forResource: file, withExtension: "mp3") else {
            return
        }
        for (_, e) in musicPool {
            e.crossFade = crossFade
            e.targetVolume = 0
        }
        let player = buildPlayer(url: url, crossFade: crossFade)
        player?.targetVolume = 1
    }
    
    private func buildPlayer(url: URL, crossFade: Float) -> FadingPlayer? {
        if let player = musicPool[url] {
            return player
        }
        if let audioPlayer = try? AVAudioPlayer(contentsOf: url) {
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 0
            let player = FadingPlayer(audioPlayer, crossFade: crossFade)
            musicPool[url] = player
            return player
        }
        return nil
    }
}

