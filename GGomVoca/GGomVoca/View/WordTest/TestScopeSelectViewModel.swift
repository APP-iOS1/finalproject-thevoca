//
//  TestScopeSelectViewModel.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/13.
//

import Foundation

final class TestScopeSelectViewModel: ObservableObject {
    // MARK: Properties
    @Published private var words: [Word] = []
    private var notMemorizedWords: [Word] {
        words.filter { !$0.isMemorized }
    }
    /// - 문제 개수
    var fullScopeQuestionCount   : Int { words.count }
    var notMemorizedQuestionCount: Int { notMemorizedWords.count }
    
    // 한 문제당 주어지는 시간
    private let iPhoneTimeLimitPerOneQuestion = 15
    private let iPadTimeLimitPerOneQuestion = 30
    
    /// - 시험 시간(Int)
    private var fullScopeTestTimeSecondsToiPhone   : Int {
        fullScopeQuestionCount * iPadTimeLimitPerOneQuestion
    }
    private var fullScopeTestTimeSecondsToiPad     : Int {
        fullScopeQuestionCount * iPadTimeLimitPerOneQuestion
    }
    private var notMemorizedTestTimeSecondsToiPhone: Int {
        notMemorizedQuestionCount * iPhoneTimeLimitPerOneQuestion
    }
    private var notMemorizedTestTimeSecondsToiPad  : Int {
        notMemorizedQuestionCount * iPadTimeLimitPerOneQuestion
    }
    
    /// - 시험 시간(String)
    var fullScopeTestTimeStringToiPhone   : String {
        convertSecondsToTime(seconds: fullScopeTestTimeSecondsToiPhone)
    }
    var fullScopeTestTimeStringToiPad     : String {
        convertSecondsToTime(seconds: fullScopeTestTimeSecondsToiPad)
    }
    var notMemorizedTestTimeStringToiPhone: String {
        convertSecondsToTime(seconds: notMemorizedTestTimeSecondsToiPhone)
    }
    var notMemorizedTestTimeStringToiPad  : String {
        convertSecondsToTime(seconds: notMemorizedTestTimeSecondsToiPad)
    }
    
    // MARK: 시간(초)를 hh:mm:ss로 바꿔주는 메서드
    private func convertSecondsToTime(seconds: Int) -> String {
        let minutes = seconds / 60
        return "약 \(minutes)분 소요"
    }
    
    // MARK: Vocabulary ID를 매개변수로 해당하는 단어장의 words를 가져오는 메서드
    func getWords(for vocabularyID: Vocabulary.ID) {
        let vocabulary = CoredataRepository().getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let allWords = vocabulary.words?.allObjects as? [Word] ?? []
        words = allWords.filter { $0.deletedAt == nil }
    }
}
