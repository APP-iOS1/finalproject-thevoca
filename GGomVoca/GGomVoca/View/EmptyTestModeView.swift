//
//  EmptyTestModeView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/10.
//

import SwiftUI

struct EmptyTestModeView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            .horizontalAlignSetting(.trailing)
            .padding()
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("시험 볼 단어가 없습니다.")
                    .font(.title3)
                Text("\(Image(systemName: "plus.circle.fill")) 새 단어 추가를 눌러 단어를 추가해주세요.")
            }
            .foregroundColor(.gray)
            .horizontalAlignSetting(.center)
            
            Spacer()
        }
    }
}

struct EmptyTestModeView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyTestModeView()
    }
}
