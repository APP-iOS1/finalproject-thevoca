//
//  WordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

enum TempNationality: String, CaseIterable {
    case KO = "한국어" // 한국어
    case EN = "영어" // 영어
    case JP = "일본어" // 일본어
    case CH = "중국어" // 중국어
    case FR = "프랑스어" // 프랑스어
    case DE = "독일어" // 독일어
    case ES = "스페인어" // 스페인어
    case IT = "이탈리아어" // 이탈리아어
}

struct WordsTableView: View {
    @Binding var selectedSegment: ProfileSection
    @Binding var selectedWord: [UUID]
    
    @Binding var filteredWords: [TempWord]
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    
    let nationality: TempNationality
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                LazyVStack.init(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    switch nationality {
                    case .KO:
                        Text("KO")
                    case .EN:
                        Text("EN")
                    case .JP:
                        Section {
                            ForEach(filteredWords) { word in
                                WordCell(selectedSegment: $selectedSegment, selectedWord: $selectedWord, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, nationality: nationality, word: word)
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
                                            .padding(.leading, 20)
                                    }
                                }
                                Text("단어")
                                    .frame(width: geo.size.width * 0.33, alignment: .center)
                                Text("성별")
                                    .frame(width: geo.size.width * 0.33, alignment: .center)
                                Text("뜻")
                                    .frame(width: geo.size.width * 0.33, alignment: .center)
                            }
                            .frame(height: 40)
                            .background {
                                Color.gray
                            }
                        } // Section
                    case .CH:
                        Text("CH")
                    case .FR:
                        Text("FR")
                    case .DE:
                        Text("DE")
                    case .ES:
                        Text("ES")
                    case .IT:
                        Text("IT")
                    }

                } // LazyVStack
            } // GeometryReader
        } // ScrollView
        
    }
}

struct WordsTableView_Previews: PreviewProvider {
    static var previews: some View {
        WordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(JPWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .JP)
    }
}
