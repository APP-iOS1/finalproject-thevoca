//
//  Vocabulary.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import Foundation

struct Vocabulary: Identifiable {
    var id = UUID().uuidString
    var createdAt: String
    var deletedAt: String
    var isFavorite: Bool
    var name: String
    var nationality: String
}
