//
//  HeaderText.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/14.
//

import SwiftUI

struct HeaderText: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.model == "iPad" {
            content
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(height: 30)
                .horizontalAlignSetting(.center)
        } else {
            content
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
                .frame(height: 30)
                .horizontalAlignSetting(.center)
        }
    }
}
