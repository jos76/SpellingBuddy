//
//  SpeakWordsView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/29/24.
//

import SwiftUI
import SwiftData

struct SpeakWordsView: View {
    @Environment(\.modelContext) private var modelContext
    private let wordList: SpellingWordList
    @State private var currentWordIndex = 0
    private let speechHelper = SpeechHelper()
    @State private var speechIdentifier = SpeechSettings.defaultIdentifier
    @State var presentSettings: Bool = false

    init(wordList: SpellingWordList)
    {
        self.wordList = wordList
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Text("Selected List:")
                    .font(.title)
                    .fontWeight(.bold)
                Text(wordList.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("Practicing word \(currentWordIndex + 1) of \(wordList.spellingWords.count)")
                    .font(.title2)
                Spacer()
                VStack() {
                    Divider()
                    Button("Speak Previous Word", systemImage: "backward.circle") {
                        if currentWordIndex > 0 {
                            currentWordIndex = currentWordIndex - 1
                        }
                        let text = currentText()
                        speak(text: text)
                    }.buttonStyle(.borderedProminent)
                        .padding()
                    Divider()
                    Button("Speak Word Slowly", systemImage: "tortoise") {
                        let text = currentText()
                        speakSlowly(text: text)
                    }.buttonStyle(.borderedProminent)
                        .padding()
                    Divider()
                    Button("Speak Current Word", systemImage: "person.wave.2") {
                        let text = currentText()
                        speak(text: text)
                    }.buttonStyle(.borderedProminent)
                        .padding()
                    Divider()
                    Button("Speak Next Word", systemImage: "forward.circle") {
                        if currentWordIndex + 1 >= wordList.spellingWords.count {
                            speak(text: "Spelling words completed!")
                        } else {
                            currentWordIndex = currentWordIndex + 1
                            let text = currentText()
                            speak(text: text)
                        }
                    }.buttonStyle(.borderedProminent)
                        .padding()
                    Divider()
                }
                Spacer()
            }
        }.onAppear(perform: load)
    }
    
    private func load() {
        let request = FetchDescriptor<SpeechSettings>()
        let data = try? modelContext.fetch(request)
        let settings = data?.first ?? SpeechSettings(voiceIdentifier: SpeechSettings.defaultIdentifier)
        speechIdentifier = settings.voiceIdentifier
    }
    
    private func speak(text: String) {
        speechHelper.speak(text: text, identifier: speechIdentifier)
    }
    
    private func speakSlowly(text: String) {
        speechHelper.speakSlowly(text: text, identifier: speechIdentifier)
    }
    
    private func currentText() -> String {
        if wordList.spellingWords.count > 0 {
            return wordList.spellingWords[currentWordIndex]
        } else {
            return ""
        }
    }
}

//#Preview {
//    var wordList = SpellingWordList.sampleList[0]
//    return SpeakWordsView(wordList: wordList)
//}
