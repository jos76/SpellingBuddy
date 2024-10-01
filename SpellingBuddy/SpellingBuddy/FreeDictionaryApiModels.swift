//
//  WordDefinition.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 9/8/24.
//

import Foundation

class ApiWord: Codable {
    let word: String
    let phonetics: [Phonetic]?
    let meanings: [Meaning]?
    let license: License?
    let sourceUrls: [String]?
}

class Phonetic: Codable {
    let text: String?
    let audio: String?
    let sourceUrl: String?
    let license: License?
}

class Meaning: Codable {
    let partOfSpeech: String?
    let definitions: [Definition]?
    let synonyms: [String]?
    let antonyms: [String]?
}

class Definition: Codable {
    let definition: String?
    let synonyms: [String]?
    let antonyms: [String]?
    let example: String?
}

class License: Codable {
    let name: String?
    let url: String?
}
