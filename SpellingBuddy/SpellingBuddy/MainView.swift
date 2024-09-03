//
//  MainView.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 8/28/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var lists: [SpellingWordList]
    @State private var showListInput = false
    @State private var listName = ""
    @State var presentSettings: Bool = false
    @State var showAddError: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0.0) {
                Divider()
                VStack() {
                    TextField(
                        "Enter your spelling list name",
                        text: $listName
                    )
                    .padding()
                    .textFieldStyle(.roundedBorder)
                }.background(Color(.secondarySystemBackground))
                if lists.isEmpty {
                    VStack() {
                        Text("Add a new list above to start practicing spelling")
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.title3)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.secondarySystemBackground))
                } else {
                    List() {
                        ForEach(lists) { list in
                            HStack {
                                NavigationLink {
                                    SpellingWordListView(wordList: list)
                                } label: {
                                    Text("\(list.name) (\(list.spellingWords.count))")
                                }
                            }
                        }.onDelete(perform: deleteLists)
                    }
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Settings", systemImage: "slider.horizontal.3") {
                        presentSettings.toggle()
                    }.sheet(isPresented: $presentSettings) {
                        SettingsSheetView()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add List", systemImage: "plus") {
                        if listName.isEmpty {
                            showAddError.toggle()
                        } else {
                            addList()
                        }
                    }.disabled(listName.isEmpty)
                }
            }
        }
    }
    
    private func addList() {
        withAnimation {
            if !listName.isEmpty {
                let newList = SpellingWordList(name: listName, spellingWords: [])
                modelContext.insert(newList)
            }
            listName = ""
        }
    }
    
    private func deleteLists(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(lists[index])
            }
        }
    }
}

//#Preview {
//    let preview = Preview()
//    preview.addExamples(SpellingWordList.sampleList)
//    return MainView()
//        .modelContainer(preview.container)
//}
