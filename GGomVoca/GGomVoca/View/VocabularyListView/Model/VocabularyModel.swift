//
//  VocabularyModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import Foundation
struct VocabularyModel : Identifiable, Hashable {
    var id = UUID()
    var name: String // 단어장 이름
    var nationality: Nationality // 국가
    var words: [Word] = [] // 단어 배열
    var isPinned: Bool = false // 단어장 즐겨찾기
    var created: Date = Date.now // 생성일시
    var deleted: Date? // 삭제된 날짜
}

enum Nationality: String, CaseIterable {
    case KO = "한국어" // 한국어
    case EN = "영어" // 영어
    case JA = "일본어" // 일본어
    case FR = "프랑스어" // 프랑스어
//    case CH = "중국어" // 중국어
//    case DE = "독일어" // 독일어
//    case ES = "스페인어" // 스페인어
//    case IT = "이탈리아어" // 이탈리아어
}
