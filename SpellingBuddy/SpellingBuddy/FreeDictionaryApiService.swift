//
//  FreeDictionaryApiService.swift
//  SpellingBuddy
//
//  Created by Jon Savage on 9/8/24.
//

import Foundation

protocol FreeDictionaryApiService {
    func fetchApiWords(words: [String]) async -> [ApiWord?]
    func fetchApiWord(word: String) async -> ApiWord?
}

class FreeDictionaryApiServiceImpl: FreeDictionaryApiService {
    
    static let shared = FreeDictionaryApiServiceImpl()
    
    private let host = "https://api.dictionaryapi.dev"
    private let path = "/api/v2/entries/en/"
    
    private init() {}
    
    func fetchApiWords(words: [String]) async -> [ApiWord?] {
        var apiWords = [ApiWord?]()
        for word in words {
            apiWords.append(await fetchApiWord(word: word))
        }
        return apiWords
    }
    
    func fetchApiWord(word: String) async -> ApiWord? {
        let apiWords = try? await makeApiCall(word: word)
        guard let apiWord = apiWords?.first else {
            return nil
        }
        return apiWord
    }
    
    private func makeApiCall(word: String) async throws -> [ApiWord] {
        let urlString = "\(host)\(path)\(word)"
        guard let url = URL(string: urlString) else {
            throw ErrorMessage(message: "Failed to create URL from \(urlString)")
        }
        
        let session = URLSession.shared
        do {
            let (data, response) = try await session.data(from: url)
        
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                throw ErrorMessage(message: "Error with the response, unexpected status code")
            }
            
            return try JSONDecoder().decode([ApiWord].self, from: data)
        } catch {
            throw error
        }
    }
}

struct ErrorMessage: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
