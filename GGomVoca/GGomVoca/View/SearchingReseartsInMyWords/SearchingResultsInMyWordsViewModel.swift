//
//  SearchingResultsInMyWordsViewModel.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/09.
//

import Foundation

class SearchingResultsInMyWordsViewModel {
    // MARK: Repository Property
    var repository : CoredataRepository = CoredataRepository()
    
    var totalWords: [Word] = []
    
    init() {
        getAllVocabulariesData()
    }
    
    // MARK: 전체 단어장에서 words 배열 가져오기
    func getAllVocabulariesData() {
        /// - 데이터 가져오기 전에 일단 배열 초기화
        clearVocabulariesData()
        
        /// - repository에서 Vocabulary Data 받아옴
        let results = repository.getVocabularyData()
        
        for vocabulary in results {
            /// - 삭제된 단어장은 pass
            guard vocabulary.deleatedAt == nil else { continue }
            /// - 각 단어장을 돌면서 words 배열 가져와서 합치기
            var tempWords = vocabulary.words?.allObjects as? [Word] ?? []
            tempWords = tempWords.filter { $0.deletedAt == nil }
            totalWords += tempWords
        }
    }
    
    func searchKeyword(for keyword: String) -> [Word] {
        var hasPrefix: [Word] = []
        var contains: [Word] = []
        
        for wordStruct in totalWords {
            let word = wordStruct.word!.lowercased()
            let meaning = wordStruct.meaning!.joined(separator: " ")
            
            if word.hasPrefix(keyword) || meaning.hasPrefix(keyword) {
                hasPrefix.append(wordStruct)
            } else if word.contains(keyword) || meaning.contains(keyword) {
                contains.append(wordStruct)
            }
        }
        
        hasPrefix.sort { $0.word!.lowercased() < $1.word!.lowercased() }
        contains.sort { $0.word!.lowercased() < $1.word!.lowercased() }
        
        
        return hasPrefix + contains
    }
    
    // MARK: 단어 배열 초기화
    func clearVocabulariesData() {
        totalWords = []
    }
}
