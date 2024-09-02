//
//  SpeechHelper.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/28/24.
//

import Foundation
import AVFoundation

struct SpeechHelper {
    // Create a speech synthesizer.
    private let speechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    private let defaultRate: Float = 0.5
    private let slowRate: Float = 0.35
    
    public func speak(text: String, identifier: String) {
        speak(text: text, rate: AVSpeechUtteranceDefaultSpeechRate, identifier: identifier)
    }
    
    public func speakSlowly(text: String, identifier: String) {
        speak(text: text, rate: AVSpeechUtteranceMinimumSpeechRate, identifier: identifier)
    }
    
    private func speak(text: String, rate: Float, identifier: String) {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: text)

        // Configure the utterance.
        utterance.rate = rate

        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(identifier: identifier)

        // Assign the voice to the utterance.
        utterance.voice = voice

        // Tell the synthesizer to speak the utterance.
        speechSynthesizer.speak(utterance)
    }
}
