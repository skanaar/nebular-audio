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
    public init () {
        //should set up some options, like crossFade time.
    }
    
    public func playMusic (file: String) {
        let url = Bundle.main.url(forResource: file, withExtension: "mp3")
    
        if (url != nil) {
            let current = musicPool.filter { (player) -> Bool in
                return player.isPlaying
            }
            
            if let currentPlayer = current.first {
                self.crossFade(player: currentPlayer, from: 1.0, to: 0.0)
            }
            
            let audioPlayer = try? AVAudioPlayer(contentsOf: url!)
    
            audioPlayer?.numberOfLoops = -1
            // audioPlayer?.volume = 0.0
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            musicPool.append(audioPlayer!)
        }
    }
    
    public func playEffect (file: String, time: Int) {
    
    }
    
    public func crossFade (player: AVAudioPlayer, from: Float, to: Float) {
        // player.setValue(true, forKey: "crossFading")
        
        let fade: Int = Int(3.0) * 100
    
        for step in 0...fade {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(Float(step) * 0.01)) {
                player.volume = from + (to - from) * (Float(step) / Float(fade))
            }
        }
    }
}
