//
//  NebularAudio.swift
//  NebularAudio
//
//  Created by Linus Schwalbe on 2017-10-08.
//  Copyright © 2017 skanaar. All rights reserved.
//

import AVFoundation

private var musicPool: [AVAudioPlayer] = []
private var effectPool: [AVAudioPlayer] = []

public class NebularAudio {
    public init () {}
    
    public func playMusic (file: String) {
        let url = Bundle.main.url(forResource: file, withExtension: "mp3")
    
        if (url != nil) {
            let current = musicPool.filter { (player) -> Bool in
                return player.isPlaying
            }
            
            if let currentPlayer = current.first {
                self.crossFade(player: currentPlayer, from: 1.0, to: 0.0)
            }
            
            let audioPlayer = self.requestMusicPlayer(url: url!)
    
            audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    public func playEffect (file: String, time: Int) {
    
    }
    
    private func crossFade (player: AVAudioPlayer, from: Float, to: Float) {
        let fade: Int = Int(2.0) * 100
    
        for step in 0...fade {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(Float(step) * 0.01)) {
                player.volume = from + (to - from) * (Float(step) / Float(fade))
                
                if (player.volume <= 0.0) {
                    player.pause()
                }
            }
        }
    }
    
    private func requestMusicPlayer (url: URL) -> AVAudioPlayer {
        let inPool = musicPool.filter { (player) -> Bool in
            return player.isPlaying == false && player.url == url
        }
        
        if let player = inPool.first {
            return player
        }
        
        let player = try? AVAudioPlayer(contentsOf: url)
        
        musicPool.append(player!)
        
        return musicPool.last!
    }
    
    private func requestEffectPlayer (url: URL) {
    
    }
}
