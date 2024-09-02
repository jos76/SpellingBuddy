//
//  PreviewContainer.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/28/24.
//

import Foundation
import SwiftData

struct Preview {
    let container: ModelContainer
    
    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try ModelContainer(for: SpellingWordList.self, SpeechSettings.self, configurations: config)
        } catch {
            fatalError("Could not create preview container")
        }
    }
    
    func addExamples(_ examples: [SpellingWordList]) {
        Task { @MainActor in
            examples.forEach { example in
                container.mainContext.insert(example)
            }
            container.mainContext.insert(SpeechSettings(voiceIdentifier: SpeechSettings.defaultIdentifier))
        }
    }
}
