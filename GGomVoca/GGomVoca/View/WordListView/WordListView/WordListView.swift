//
//  WordListView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordListView: View {
    @State private var selectedSegment: ProfileSection = .normal
    @State private var selectedWord: [UUID] = []
    
    @State var isSelectionMode: Bool = false
    @State private var multiSelection: Set<String> = Set<String>()
    
//    @State var vocabulary: Vocabulary
    @State var vocabulary: TempVocabulary = vocabularies[0]
//    @State var vocabulary: TempVocabulary = vocabularies[1]
    
    @State var words: [TempWord] = [] {
        didSet {
            //삭제된 기록이 없는 단어장 filter
            filteredWords = vocabulary.words.filter({ $0.deletedAt == "" })
        }
    }
    
    @State var filteredWords: [TempWord] = []
    
    var body: some View {
        VStack{
            SegmentView(selectedSegment: $selectedSegment, selectedWord: $selectedWord)
            
            if filteredWords.count <= 0 {
                VStack(alignment: .center){
                    Spacer()
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("단어를 추가해주세요")
                        .font(.title3)
                    Spacer()
                }
                .foregroundColor(.gray)
            } else {
                WordsTableView(selectedSegment: $selectedSegment, selectedWord: $selectedWord, filteredWords: $filteredWords, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, nationality: vocabulary.nationality)
            }
            
        }
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView(vocabulary: vocabularies[0], filteredWords: JPWords)
    }
}



