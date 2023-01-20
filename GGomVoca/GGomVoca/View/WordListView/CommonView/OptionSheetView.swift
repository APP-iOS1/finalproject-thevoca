//
//  OptionSheetView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/19.
//

import SwiftUI

struct OptionSheetView: View {
    
    @Binding var words: [Word]
    var vocabulary: Vocabulary
    
    var body: some View {
        NavigationStack {
            List {
                OptionButton(name: "단어 순서 섞기", words: $words)
                OptionButton(name: "전체 단어 재생하기", words: $words)
                NavigationLink {
                    ImportCSVFileView(vocabulary: vocabulary)
                } label: {
                    HStack {
                        Text("단어 가져오기")
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                OptionButton(name: "단어 리스트 내보내기", words: $words)
            }
        }
    }
}

struct OptionButton: View {
    let name: String
    @Binding var words: [Word]
    
    var body: some View {
        Button(action: {
            print("button")
            if name == "단어 순서 섞기" {
                print("shuffle")
                words.shuffle()
            }
        }) {
            Text("\(name)")
        }
//        .padding()
//        .frame(width: 220)
//        .foregroundColor(.black)
//        .background(Color(red: 0, green: 0, blue: 0.5))
//        .clipShape(Capsule())
    }
}
