//
//  EmptyMyNoteView.swift
//  GGomVoca
//
//  Created by tae on 2023/02/10.
//

import SwiftUI

struct EmptyMyNoteView: View {
    var body: some View {
        VStack {
            Text("시험 결과가 없습니다.")
              .font(.system(size: 20))
            Text("")
            Text("\(Image(systemName: "square.and.pencil") )시험 보기를 눌러 단어 시험을 선택하세요.")
        }
        .foregroundColor(.secondary)
        .horizontalAlignSetting(.center)
    }
}

struct EmptyMyNoteView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyMyNoteView()
    }
}
