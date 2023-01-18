//
//  Vocabulary.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import Foundation

struct TempVocabulary: Identifiable {
    var id = UUID().uuidString
    var createdAt: String
    var deletedAt: String
    var isFavorite: Bool
    var name: String
    var nationality: String
    var words: [TempWord]
}

struct TempWord: Identifiable {
    var id = UUID().uuidString
    var correctCount: Int16
    var createdAt: String
    var deletedAt: String
    var incorrectCount: Int16
    var isMemorized: Bool
    var meaning: String
    var option: String
    var vocabularyID: String
    var word: String
}
