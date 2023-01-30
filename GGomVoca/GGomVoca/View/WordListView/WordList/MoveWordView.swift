//
//  MoveWordView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/30.
//

import SwiftUI

struct MoveWordView: View {
    @StateObject var vocaListViewModel = VocabularyListViewModel(vocabularyList: [])
    @StateObject var selectedVocaviewModel: WordListViewModel = WordListViewModel()
    @ObservedObject var currentVocaViewModel: WordListViewModel
    
    // 이동 가능한 단어장 List를 보여주기 위한 프로퍼티
    @State var vocabularyList : [Vocabulary]  = []
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<Word>
    @Binding var moveWord: Bool
    
    let currentVocaID: Vocabulary.ID
    
    var body: some View {
        List {
            Section {
                ForEach(vocabularyList) { vocabulary in
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
            
            // 현재 단어장의 국가와 같은 국가인 단어장으로만 이동 가능
            switch currentVocaViewModel.nationality {
            case "KO":
                vocabularyList = vocaListViewModel.koreanVoca
            case "EN":
                vocabularyList = vocaListViewModel.englishVoca
            case "JA":
                vocabularyList = vocaListViewModel.japaneseVoca
            case "FR":
                vocabularyList = vocaListViewModel.frenchVoca
            default:
                vocabularyList = []
            }
        }
    }
}

//struct MoveWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        MoveWordView()
//    }
//}
