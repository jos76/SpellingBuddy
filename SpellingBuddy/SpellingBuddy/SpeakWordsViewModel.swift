//
//  SpeakWordsViewModel.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 9/17/24.
//

import Foundation

@Observable
final class SpeakWordsViewModel {
    let wordList: SpellingWordList
    var apiWords: [ApiWord?]?
    var name: String {
        wordList.name
    }
    var count: Int {
        wordList.spellingWords.count
    }
    var onFirstWord: Bool {
        currentIndex == 0
    }
    var onLastWord: Bool {
        currentIndex + 1 >= count
    }
    private let speechHelper = SpeechHelper.shared
    var speechIdentifier: String = SpeechSettings.defaultIdentifier
    private let urlPatterns: [String] = ["-us", "-ca", "-uk", "-au"]
    private(set) var currentIndex: Int = 0
    private(set) var currentDefinition: String?
    private(set) var currentExampleSentence: String?
    
    init(wordList: SpellingWordList) {
        self.wordList = wordList
    }
    
    func loadApiWords() async {
        self.apiWords = await FreeDictionaryApiServiceImpl.shared.fetchApiWords(words: wordList.spellingWords)
        updateDefinitionAndSentence()
    }
    
    func resetIndex() {
        currentIndex = 0
        updateDefinitionAndSentence()
    }
    
    func changeCurrentIndex(offset: Int) {
        if (offset < 0 && currentIndex >= 0)
            || (offset > 0 && currentIndex + 1 < count) {
            currentIndex = currentIndex + offset
            updateDefinitionAndSentence()
        }
    }
    
    func currentText() -> String {
        if count > 0
            && currentIndex < count {
            return wordList.spellingWords[currentIndex]
        } else {
            return ""
        }
    }
    
    func speakCurrentWord() {
        if let apiWordUrl = apiWordUrl(currentIndex: currentIndex) {
            speechHelper.stop()
            AudioManager.shared.startAudio(url: apiWordUrl)
        } else {
            let text = currentText()
            speak(text: text)
        }
    }
    
    func speakCurrentDefinition() {
        if let text = currentDefinition {
            speak(text: text)
        }
    }
    
    func speakCurrentExampleSentence() {
        if let text = currentExampleSentence {
            speak(text: text)
        }
    }
    
    func speak(text: String) {
        speechHelper.speak(text: text, identifier: speechIdentifier)
    }
    
    func speakCurrentWordSlowly() {
        let text = currentText()
        speechHelper.speakSlowly(text: text, identifier: speechIdentifier)
    }
    
    func speakCurrentWordMachineVoice() {
        let text = currentText()
        speak(text: text)
    }
    
    func apiWordUrl(currentIndex: Int) -> URL? {
        guard let apiWord = currentApiWord(currentIndex: currentIndex),
              let phonetics = apiWord.phonetics else { return nil }
        var url: String?
        for phonetic in phonetics {
            if let audioUrl = phonetic.audio,
               !audioUrl.isEmpty {
                url = findBestUrl(currentUrl: url, newUrl: audioUrl)
            }
        }
        if let url = url {
            return URL(string: url)
        }
        return nil
    }
    
    private func updateDefinitionAndSentence() {
        guard let apiWord = currentApiWord(currentIndex: currentIndex) else {
            currentDefinition = nil
            currentExampleSentence = nil
            return
        }
        currentDefinition = findDefinition(apiWord: apiWord)
        currentExampleSentence = findExampleSentence(apiWord: apiWord)
    }
    
    private func findDefinition(apiWord: ApiWord) -> String? {
        if let definition = findDefinitionWhereExampleContainsWord(apiWord: apiWord) {
            return definition.definition
        } else {
            return findAnyDefinition(apiWord: apiWord)?.definition
        }
    }
    
    private func findExampleSentence(apiWord: ApiWord) -> String? {
        return findDefinitionWhereExampleContainsWord(apiWord: apiWord)?.example
    }
    
    private func findDefinitionWhereExampleContainsWord(apiWord: ApiWord) -> Definition? {
        guard let meanings = apiWord.meanings else { return nil }
        for meaning in meanings {
            guard let definitions = meaning.definitions else { continue }
            for definition in definitions {
                if let exStr = definition.example,
                   !exStr.isEmpty,
                   exStr.contains(apiWord.word) {
                    return definition
                }
            }
        }
        return nil
    }
    
    private func findAnyDefinition(apiWord: ApiWord) -> Definition? {
        guard let meanings = apiWord.meanings else { return nil }
        for meaning in meanings {
            guard let definitions = meaning.definitions else { continue }
            for definition in definitions {
                if let defStr = definition.definition,
                   !defStr.isEmpty {
                    return definition
                }
            }
        }
        return nil
    }
    
    private func findBestUrl(currentUrl: String?, newUrl: String) -> String {
        guard let currentUrl = currentUrl else {
            return newUrl
        }
        
        for pattern in urlPatterns {
            if let url = getUrlWhichContains(currentUrl: currentUrl, newUrl: newUrl, pattern: pattern) {
                return url
            }
        }

        return currentUrl
    }
    
    private func getUrlWhichContains(currentUrl: String, newUrl: String, pattern: String) -> String? {
        if currentUrl.contains(pattern) {
            return currentUrl
        } else if newUrl.contains(pattern) {
            return newUrl
        }
        return nil
    }
    
    private func currentApiWord(currentIndex: Int) -> ApiWord? {
        if let apiWord = apiWords?[currentIndex] {
            return apiWord
        } else {
            return nil
        }
    }
}
