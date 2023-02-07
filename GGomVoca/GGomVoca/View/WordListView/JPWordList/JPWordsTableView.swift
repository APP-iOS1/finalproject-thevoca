//
//  JPWordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct JPWordsTableView: View {
    // MARK: SuperView Properties
    @ObservedObject var viewModel: JPWordListViewModel
    var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    
    // MARK: View Properties
    /// - 단어 수정 관련 State
    @State var editWord: Bool = false
    @State var editingWord: Word = Word()
    
    /// - 단어 리스트 편집 관련 State
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<Word>
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach($viewModel.words) { $word in
                        JPWordCell(selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords,
                                 isSelectionMode: $isSelectionMode, multiSelection: $multiSelection,
                                 nationality: viewModel.nationality, word: $word)
                            .addSwipeButtonActions(leadingButtons: [],
                                              trailingButton:  [.delete], onClick: { button in
                                switch button {
                                case .delete:
                                    viewModel.deleteWord(word: word)
                                default:
                                    print("default")
                                }
                            })
                            .contextMenu {
                                if selectedSegment == .normal {
                                    Button {
                                        editingWord = word
                                        editWord.toggle()
                                    } label: {
                                        Label("수정하기", systemImage: "gearshape.fill")
                                    }
                                    Button {
                                        SpeechSynthesizer.shared.speakWordAndMeaning(word, to: "ja-JP", .single)
                                    } label: {
                                        Label("발음 듣기", systemImage: "mic.fill")
                                    }
                                }
                            }
                        
                        Divider()
                    }
                } header: {
                    VStack(spacing: 0) {
                        HStack {
                            if isSelectionMode {
                                /// - 편집모드에서 header도 체크용 원만큼 오른쪽으로 밀리도록 하기 위해 circle image를 배경색과 같은색으로 띄움
                                Image(systemName: "circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color("offwhite"))
                                    .padding(.leading, 20)
                            }
                            
                            Text("단어")
                                .horizontalAlignSetting(.center)
                            Text("발음")
                                .horizontalAlignSetting(.center)
                            Text("뜻")
                                .horizontalAlignSetting(.center)
                        }
                        .frame(height: 40)
                        .background { Color("offwhite") }
                        
                        Rectangle()
                            .foregroundColor(Color("toolbardivider"))
                            .frame(height: 1)
                    }
                } // Section
            } // LazyVStack
            .background { Color("offwhite") }
        } // ScrollView
        // MARK: 단어 편집 시트
        .sheet(isPresented: $editWord) {
            JPEditWordView(viewModel: viewModel, editWord: $editWord, editingWord: $editingWord)
                .presentationDetents([.medium])
        }
        .onDisappear {
            SpeechSynthesizer.shared.stopSpeaking()
        }
    }
}

//struct JPWordsTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        JPWordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(FRWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR)
//    }
//}
