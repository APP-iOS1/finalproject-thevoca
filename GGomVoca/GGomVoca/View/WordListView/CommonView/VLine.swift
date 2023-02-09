//
//  VerticalDividerView.swift
//  GGomVoca
//
//  Created by tae on 2023/02/08.
//

import SwiftUI

struct VLine: View {
  var body: some View {
    Line()
    .stroke(Color.secondary, style: StrokeStyle(lineWidth: 0.1, dash: [5]))
    .frame(width: 1)
  }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.midX, y: rect.maxY)
        let end = CGPoint(x: rect.midX, y: rect.minY)

        return Path { p in
            p.move(to: start)
            p.addLine(to: end)
        }
    }
}

