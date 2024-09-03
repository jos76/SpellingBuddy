//
//  SpellingWordListView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/28/24.
//
import AVFoundation
import SwiftUI
import SwiftData

struct SpellingWordListView: View {
    @Environment(\.modelContext) private var modelContext
    @State var wordList: SpellingWordList
    @State private var showDeleteAll = false
    @State private var showEditWordInput = false
    @State private var editWord = ""
    @State private var wordText = ""
    @FocusState private var wordTextFocused
    @State private var editingIndex = 0
    @State private var speakIndex = 0
    private let speechHelper = SpeechHelper()
    @State private var speechIdentifier = SpeechSettings.defaultIdentifier
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0.0) {
                Divider()
                VStack() {
                    TextField(
                        "Enter your spelling word",
                        text: $wordText
                    ).focused($wordTextFocused)
                        .onSubmit {
                            addWord()
                        }
                        .padding()
                        .textFieldStyle(.roundedBorder)
                }.background(Color(.secondarySystemBackground))
                if wordList.spellingWords.isEmpty {
                    VStack() {
                        Text("Add a new spelling word to this list")
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.title3)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.secondarySystemBackground))
                } else {
                    List {
                        ForEach(Array(wordList.spellingWords.enumerated()), id: \.offset) { idx, word in
                            HStack {
                                Image(systemName: "square.and.pencil").onTapGesture {
                                    editWord(idx: idx, word: word)
                                }.foregroundColor(Color(.systemBlue))
                                Text(word).padding(5)
                                Spacer()
                                Image(systemName: "person.wave.2.fill").onTapGesture {
                                    speechHelper.speak(text: word, identifier: speechIdentifier)
                                }.foregroundColor(Color(.systemBlue))
                            }
                        }
                        .onDelete(perform: deleteWords)
                    }
                    .alert("Edit Spelling Word", isPresented: $showEditWordInput) {
                        TextField("Enter your spelling word", text: $editWord)
                        Button("Cancel") {
                            showEditWordInput.toggle()
                        }
                        Button("Update", action: updateWord)
                    }
                    Spacer()
                    NavigationLink {
                        SpeakWordsView(wordList: wordList)
                    } label: {
                        Text("Start Practice")
                            .padding(8)
                    }.buttonStyle(.borderedProminent)
                    Spacer()
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Word", systemImage: "plus") {
                        addWord()
                    }.disabled(wordText.isEmpty)
                }
                ToolbarItem() {
                    Button("Delete All", systemImage: "trash") {
                        if wordList.spellingWords.count > 0 {
                            showDeleteAll.toggle()
                        }
                    }.disabled(wordList.spellingWords.isEmpty).alert("Delete All Words?", isPresented: $showDeleteAll) {
                        Button("Cancel") {
                            showDeleteAll.toggle()
                        }
                        Button("Delete All") {
                            if wordList.spellingWords.count > 0 {
                                deleteAllWords()
                            }
                        }
                    }
                }
            }
        }.onAppear(perform: load)
    }
    
    private func load() {
        let request = FetchDescriptor<SpeechSettings>()
        let data = try? modelContext.fetch(request)
        let settings = data?.first ?? SpeechSettings(voiceIdentifier: SpeechSettings.defaultIdentifier)
        speechIdentifier = settings.voiceIdentifier
    }
    
    private func editWord(idx: Int, word: String) {
        editingIndex = idx
        editWord = word
        showEditWordInput.toggle()
    }
    
    private func updateWord() {
        withAnimation {
            wordList.spellingWords[editingIndex] = editWord
        }
    }

    private func addWord() {
        withAnimation {
            if !wordText.isEmpty {
                wordList.spellingWords.append(wordText)
                wordTextFocused = true
            }
            wordText = ""
        }
    }

    private func deleteAllWords() {
        withAnimation {
            wordList.spellingWords.removeAll()
        }
    }
    
    private func deleteWords(offsets: IndexSet) {
        withAnimation {
            wordList.spellingWords.remove(atOffsets: offsets)
        }
    }
}

//#Preview {
//    let preview = Preview()
//    preview.addExamples(SpellingWordList.sampleList)
//    return SpellingWordListView(wordList: SpellingWordList.sampleList[1])
//        .modelContainer(preview.container)
//}
