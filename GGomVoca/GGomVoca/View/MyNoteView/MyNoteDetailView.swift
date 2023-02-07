//
//  MyNoteDetailView.swift
//  GGomVoca
//
//  Created by 고도 on 2023/02/06.
//

import SwiftUI

struct MyNoteDetailView: View {
    var navigationTitle: String
    var words: [Word]
    
    var body: some View {
        List {
            ForEach(words, id: \.self) { word in
                HStack(spacing: 0) {
                    Text(word.word ?? "")
                    
                    Spacer()
                    
                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                        Image(systemName: result == "O" ? "circle" : "xmark")
                            .foregroundColor(result == "O" ? .green : .red)
                    }
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct MyNoteDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyNoteDetailView()
//    }
//}
