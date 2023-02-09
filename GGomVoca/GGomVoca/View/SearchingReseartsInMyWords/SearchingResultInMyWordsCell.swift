//
//  SearchListCell.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI

struct SearchingResultInMyWordsCell: View {

    var word: Word
    
    var body: some View {
        NavigationLink(value: word.vocabulary) {
            VStack(alignment: .leading, spacing: 5) {
                Text(word.word ?? "")
                Text(word.meaning?.joined(separator: ", ") ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
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
