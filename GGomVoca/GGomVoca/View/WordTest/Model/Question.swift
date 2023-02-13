//
//  Question.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/13.
//

import Foundation

struct Question: Identifiable {
    var id: UUID
    var word: String
    var meaning: [String]
    var answer: String?
    var isCorrect: Result = .Wrong
    var isToggleMemorize: Bool = false
}
