//
//  InfoSheetView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 9/27/24.
//

import SwiftUI
import SwiftData
import AVFoundation

struct InfoSheetView: View {
    @Environment(\.dismiss) private var dismiss
    private let iconInfoList: [(String, String)] = [
        ("arrow.trianglehead.clockwise", "Restarts from the beginning of the list"),
        ("bubble.circle", "Plays a sentence which uses the word, if available"),
        ("book.closed.circle", "Plays the definition of the word, if available"),
        ("tortoise.circle", "Plays the current word slowly using a synthesized voice"),
        ("waveform.circle", "Plays the current word using a synthesized voice"),
        ("backward.circle", "Plays the previous word using a recorded voice if available or a synthesized voice if not"),
        ("play.circle", "Plays the current word using a recorded voice if available or a synthesized voice if not"),
        ("forward.circle", "Plays the next word using a recorded voice if available or a synthesized voice if not")
    ]
    
    var body: some View {
        NavigationStack {
            VStack() {
                Divider()
                Text("Please ensure your phone is not on silent and your volume is turned up.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.all)
                List() {
                    Section {
                        ForEach(iconInfoList.indices, id: \.self) { index in
                            let iconInfo = iconInfoList[index]
                            HStack() {
                                Image(systemName: iconInfo.0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color(.systemBlue))
                                Text("\(iconInfo.1)")
                                    .multilineTextAlignment(.leading)
                                    .padding(.leading)
                            }
                        }
                    } header: {
                        Text("Icon Information")
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
