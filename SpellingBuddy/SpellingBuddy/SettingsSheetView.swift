//
//  SettingsSheetView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/30/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct SettingsSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var settings: SpeechSettings?
    @State private var voiceSelection: String?
    private let speechHelper = SpeechHelper()
    private var voices = AVSpeechSynthesisVoice.speechVoices().filter { voice in
        voice.language.starts(with: "en") && voice.voiceTraits != .isNoveltyVoice
    }
    
    var body: some View {
        NavigationStack {
            VStack() {
                if settings != nil {
                    Text("Settings")
                        .font(.title)
                    List(selection: $voiceSelection) {
                        Section {
                            ForEach(voices, id: \.identifier) { voice in
                                Text("\(voice.language) - \(voice.name)")
                            }
                        } header: {
                            Text("Selected Voice")
                        }
                    }.onChange(of: voiceSelection) {
                        save()
                        speakVoice()
                    }
                } else {
                    Text("Loading...")
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear(perform: load)
    }
    
    private func save() {
        if let selection = voiceSelection {
            settings?.voiceIdentifier = selection
        }
    }
    
    private func speakVoice() {
        if let selection = voiceSelection {
            speechHelper.speak(text: "This is my voice", identifier: selection)
        }
    }
    
    private func load() {
        let request = FetchDescriptor<SpeechSettings>()
        let data = try? modelContext.fetch(request)
        let dataOrDefault = data?.first ?? SpeechSettings(voiceIdentifier: SpeechSettings.defaultIdentifier)
        if data?.first == nil {
            modelContext.insert(dataOrDefault)
        }
        settings = dataOrDefault
        voiceSelection = settings?.voiceIdentifier
    }
}

//#Preview {
//    let preview = Preview()
//    preview.addExamples(SpellingWordList.sampleList)
//    return SettingsSheetView()
//        .modelContainer(preview.container)
//}
