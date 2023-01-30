//
//  ENMoveWordView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/31.
//

import SwiftUI

struct ENMoveWordView: View {
    @StateObject var vocaListViewModel = VocabularyListViewModel(vocabularyList: [])
    @StateObject var selectedVocaviewModel: ENENWordListViewModel = ENENWordListViewModel()
    @ObservedObject var currentVocaViewModel: ENENWordListViewModel
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<Word>
    @Binding var moveWord: Bool
    
    let currentVocaID: Vocabulary.ID
    
    var body: some View {
        List {
            Section {
                ForEach(vocaListViewModel.englishVoca) { vocabulary in
                    Button {
                        for word in multiSelection {
                            // 현재 단어장에서 삭제
                            currentVocaViewModel.deleteWord(word: word)
                            // 선택한 단어장에 추가
                            selectedVocaviewModel.getVocabulary(vocabularyID: vocabulary.id)
                            selectedVocaviewModel.addNewWord(word: word.word!, meaning: word.meaning!, option: word.option!)
                            // 단어 이동 후 처리
                            moveWord.toggle()
                            multiSelection.removeAll()
                            isSelectionMode.toggle()
                        }
                    } label: {
                        Text(vocabulary.name!)
                            .foregroundColor(vocabulary.id == currentVocaID ? .gray : .black)
                    }
                    .disabled(vocabulary.id == currentVocaID ? true : false)
                }
            } header: {
                Text(currentVocaViewModel.nationality)
                    .font(.title)
                    .bold()
            }
        }
        .onAppear {
            vocaListViewModel.getVocabularyData()
        }
    }
}

//struct ENMoveWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        ENMoveWordView()
//    }
//}
