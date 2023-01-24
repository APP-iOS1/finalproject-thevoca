//
//  WordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordsTableView: View {
    // MARK: SuperView Properties
    @ObservedObject var viewModel: WordListViewModel
    var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    
    // MARK: View Properties
    /// - 단어 수정 관련 State
    @State var editWord: Bool = false
    @State var editingWord: Word = Word()
    
    /// - 단어 리스트 편집 관련 State
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(viewModel.words) { word in
                        WordCell(selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords, editWord: $editWord, editingWord: $editingWord, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, nationality: viewModel.nationality, word: word)
                            .addSwipeButtonActions(leadingButtons: [],
                                              trailingButton:  [.delete], onClick: { button in
                                switch button {
                                case .delete:
                                    viewModel.deleteWord(word: word)
                                default:
                                    print("default")
                                }
                            })
                        Divider()
                    }
                } header: {
                    HStack {
                        if isSelectionMode {
                            Button {
                                
                            } label: {
                                /// header도 밑의 내용과 같은 위치에 나오도록 하기위해서 circle image를 같이 띄워줌
                                /// clear로 띄우거나 배경과 같은 색으로 띄워줘서 원 있는거 모르게 하기
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 20)
                            }
                        }
                        
                        switch viewModel.nationality {
                        case "EN", "FR":
                            Text("단어")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("뜻")
                                .frame(maxWidth: .infinity, alignment: .center)
                        case "KO", "JA":
                            Text("단어")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("발음")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("뜻")
                                .frame(maxWidth: .infinity, alignment: .center)
                        default:
                            EmptyView()
                        }
                    }
                    .frame(height: 40)
                    .background { Color.gray }
                } // Section
            } // LazyVStack
        } // ScrollView
        // 단어 편집
        .sheet(isPresented: $editWord) {
            EditWordView(viewModel: viewModel, editWord: $editWord, editingWord: $editingWord)
                .presentationDetents([.medium])
        }
    }
}

//struct WordsTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(FRWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR)
//    }
//}
