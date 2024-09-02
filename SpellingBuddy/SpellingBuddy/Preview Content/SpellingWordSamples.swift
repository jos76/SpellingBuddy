//
//  SpellingWordSamples.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/28/24.
//

import Foundation

extension SpellingWordList {
    static var sampleList: [SpellingWordList] {
        [
            SpellingWordList(name: "Test List", spellingWords: sampleWords),
            SpellingWordList(name: "3F Week1", spellingWords: week1Words),
        ]
    }
    
    static var sampleWords: [String] {
        [
            "Fantastic",
            "Super",
            "Amazing"
        ]
    }
    
    static var week1Words: [String] {
        [
            "crop",
            "plan",
            "thing",
            "smell",
            "shut",
            "sticky",
            "spent",
            "lunch",
            "pumpkin",
            "clock",
            "gift",
            "class",
            "skip",
            "swing",
            "next",
            "hug",
            "hospital",
            "fantastic",
        ]
    }
}
