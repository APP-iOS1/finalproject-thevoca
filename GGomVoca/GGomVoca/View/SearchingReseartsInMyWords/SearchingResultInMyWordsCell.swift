//
//  SearchListCell.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI

struct SearchingResultInMyWordsCell: View {

    let word: Word
    let keyword: String
    
    var body: some View {
        NavigationLink(value: word.vocabulary) {
            VStack(alignment: .leading, spacing: 5) {
                Text(word.word ?? "") { string in
                    if let range = string.range(of: keyword) {
                        string[range].foregroundColor = Color("highlight")
                    }
                }
                
                Text(word.meaning?.joined(separator: ", ") ?? "") { string in
                    string.foregroundColor = .gray
                    if let range = string.range(of: keyword) {
                        string[range].foregroundColor = Color("highlight")
                    }
                }
                .font(.subheadline)
                
                Text("\(Image(systemName: "folder")) \(word.vocabulary?.name ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

//struct SearchListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListCell(word: Word(vocabulary: "단어장명", word: "단어", meaning: "의미", isMemorized: false))
//    }
//    
////        .constant(Word(vocabulary: "단어장", word: "가나다", meaning: "의미", isMemorized: false)
//}
