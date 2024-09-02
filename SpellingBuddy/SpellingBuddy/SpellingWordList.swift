//
//  SpellingWordList.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/29/24.
//

import Foundation
import SwiftData

@Model
final class SpellingWordList {
    var name: String
    var spellingWords: [String]
    
    init(name: String, spellingWords: [String]) {
        self.name = name
        self.spellingWords = spellingWords
    }
}
