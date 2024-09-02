//
//  Settings.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/30/24.
//

import Foundation
import SwiftData

@Model
final class SpeechSettings {
    
    public static let defaultIdentifier: String = "com.apple.voice.compact.en-US.Samantha"
    
    var voiceIdentifier: String
    
    init(voiceIdentifier: String) {
        self.voiceIdentifier = voiceIdentifier
    }
}
