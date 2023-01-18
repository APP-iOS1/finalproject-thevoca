//
//  Vocabulary.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import Foundation

struct TempVocabulary: Identifiable {
    var id: String
    var createdAt: String
    var deletedAt: String
    var isFavorite: Bool
    var name: String
    var nationality: TempNationality
    var words: [TempWord]
}

struct TempWord: Identifiable {
    var id = UUID()
    var correctCount: Int16
    var createdAt: String
    var deletedAt: String
    var incorrectCount: Int16
    var isMemorized: Bool
    var meaning: String
    var option: String?
    var vocabularyID: String
    var word: String
}

var vocabularies: [TempVocabulary] = [
    TempVocabulary(id: "1", createdAt: "", deletedAt: "", isFavorite: false, name: "일본어 회화", nationality: .JP, words: JPWords),
    TempVocabulary(id: "2", createdAt: "", deletedAt: "", isFavorite: false, name: "프랑스어 회화", nationality: .FR, words: FRWords)
]

let JPWords: [TempWord] = [
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "승진", option: "しょうしん", vocabularyID: "1", word: "昇進"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "싫어하다", option: "いやがる", vocabularyID: "1", word: "嫌がる"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "몰래, 살짝, 가만히", option: nil, vocabularyID: "1", word: "こっそり"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "쌓다", option: "つむ", vocabularyID: "1", word: "積む"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "멋있다, 훌륭하다", option: "すてき", vocabularyID: "1", word: "素敵"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "출석", option: "しゅっせき", vocabularyID: "1", word: "出席"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "만지다, 닿다", option: "ふれる", vocabularyID: "1", word: "触れる"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "국회의원", option: "ぎいん", vocabularyID: "1", word: "議員")
]

let FRWords: [TempWord] = [
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "과일의 설탕절임", option: "female", vocabularyID: "2", word: "confiture"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "묘지", option: "male", vocabularyID: "2", word: "cimetière"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "건축하다", option: "", vocabularyID: "2", word: "construire"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "각각의", option: "", vocabularyID: "2", word: "chaque"),
    TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "붙어 있다", option: "", vocabularyID: "2", word: "tenir"),
]
