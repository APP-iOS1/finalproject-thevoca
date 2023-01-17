//
//  View+.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/17.
//

import SwiftUI

// MARK: View Extentsions For UI Building
extension View {
    func horizontalAlignSetting(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func verticalAlignSetting(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
}