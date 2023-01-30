//
//  CellButtons.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

enum CellButtons: Identifiable {
    case edit
    case delete
    case save
    case info
    
    var id: String {
        return "\(self)"
    }
}
