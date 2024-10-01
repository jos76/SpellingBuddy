//
//  AudioManager.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 9/17/24.
//

import AVFoundation

final class AudioManager {
    static let shared = AudioManager()

    private var player: AVPlayer?
    
    private var session = AVAudioSession.sharedInstance()

    private init() {}
    
    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}
        
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }
    
    func startAudio(url: URL) {
        // activate our session before playing audio
        activateSession()

        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        if let player = player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }

        if let player = player {
            player.play()
        }
    }
}
