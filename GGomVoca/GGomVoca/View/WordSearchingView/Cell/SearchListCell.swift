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
    var deviceWidth = UIScreen.main.bounds.size.width
    var body: some View {
        
            HStack(spacing: 0){
                Spacer()
                Text("\(word.vocabulary.description)")
                    .frame(width: 120)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("\(word.word.description)")
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("\(word.meaning.description)")
                    .frame(width: 100)
                    .multilineTextAlignment(.center)
                    
                Spacer()
            }
            .padding(.vertical, 8)
            .ignoresSafeArea()
            .listRowInsets(.init())
        
        
        
    }
}

//struct SearchListCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchListCell(word: Word(vocabulary: "단어장명", word: "단어", meaning: "의미", isMemorized: false))
//    }
//    
////        .constant(Word(vocabulary: "단어장", word: "가나다", meaning: "의미", isMemorized: false)
//}
