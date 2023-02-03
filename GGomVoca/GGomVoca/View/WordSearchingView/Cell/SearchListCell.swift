//
//  SearchListCell.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI

struct SearchListCell: View {
    //단어
    //바인딩으로 넘겨받을 필요 없음.
    var word: SearchingWordModel
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(word.vocabulary.description)")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("\(word.word.description)")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("\(word.meaning.joined(separator: ", "))")
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
        }
        .padding(.vertical, 8)
        .ignoresSafeArea()
    }
}

//struct SearchListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListCell(word: Word(vocabulary: "단어장명", word: "단어", meaning: "의미", isMemorized: false))
//    }
//    
////        .constant(Word(vocabulary: "단어장", word: "가나다", meaning: "의미", isMemorized: false)
//}
