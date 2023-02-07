//
//  SearchingWordModel.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import Foundation

struct SearchingWordModel: Identifiable, Hashable {
    var id = UUID()
    var vocabularyID = UUID()
    var vocabulary: String // 소속된 단어장 이름
    var word: String // 단어
    var option: String? // 언어별 옵션 ex. 일본어-후리가나, 유럽어-성별, 중국어-성조 등
    var meaning: [String] // 뜻
    var isMemorized: Bool = false // 암기여부
    var createdAt: Date = Date.now // 생성일시
    var deletedAt: Date? // 삭제된 날짜
    var recentTestResults: [String] // 시험에서 정답 여부를 저장하는 배열
    var correctCount: Int
    var incorrectCount: Int
}

struct SearchingVocaModel {
    var words: Array<SearchingWordModel>
}
