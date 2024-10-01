//
//  SpeakWordsView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/29/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct SpeakWordsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var model: SpeakWordsViewModel
    @State private var currentApiWord: ApiWord? = nil
    @State private var presentInfoSheet = false

    init(model: SpeakWordsViewModel)
    {
        self.model = model
        Task {
            await model.loadApiWords()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Spacer()
                Text("Selected List:")
                    .font(.title)
                    .fontWeight(.bold)
                Text(model.name)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("Practicing word \(model.currentIndex + 1) of \(model.count)")
                    .font(.title2)
                Spacer()
                VStack(spacing: 25.0) {
                    Divider()
                    HStack(spacing: 30.0) {
                        Button {
                            model.speakCurrentExampleSentence()
                        } label: {
                            Image(systemName: "bubble.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }.disabled(model.currentExampleSentence == nil)
                        Button {
                            model.speakCurrentDefinition()
                        } label: {
                            Image(systemName: "book.closed.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }.disabled(model.currentDefinition == nil)
                    }
                    Divider()
                    HStack(spacing: 30.0) {
                        Button {
                            model.speakCurrentWordSlowly()
                        } label: {
                            Image(systemName: "tortoise.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                        Button {
                            model.speakCurrentWordMachineVoice()
                        } label: {
                            Image(systemName: "waveform.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    }
                    Divider()
                    HStack(spacing: 30.0) {
                        Button {
                            model.changeCurrentIndex(offset: -1)
                            model.speakCurrentWord()
                        } label: {
                            Image(systemName: "backward.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }.disabled(model.onFirstWord)
                        Button {
                            model.speakCurrentWord()
                        } label: {
                            Image(systemName: "play.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                        Button {
                            model.changeCurrentIndex(offset: 1)
                            model.speakCurrentWord()
                        } label: {
                            Image(systemName: "forward.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }.disabled(model.onLastWord)
                    }
                    Divider()
                }
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset", systemImage: "arrow.trianglehead.clockwise") {
                        model.resetIndex()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Info", systemImage: "info.circle") {
                        presentInfoSheet.toggle()
                    }.sheet(isPresented: $presentInfoSheet) {
                        InfoSheetView()
                    }
                }
            }
        }.onAppear(perform: load)
    }
    
    private func load() {
        let request = FetchDescriptor<SpeechSettings>()
        let data = try? modelContext.fetch(request)
        let settings = data?.first ?? SpeechSettings(voiceIdentifier: SpeechSettings.defaultIdentifier)
        model.speechIdentifier = settings.voiceIdentifier
    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(SpellingWordList.sampleList)
    var wordList = SpellingWordList.sampleList[0]
    return SpeakWordsView(model: SpeakWordsViewModel(wordList: wordList))
        .modelContainer(preview.container)
}
