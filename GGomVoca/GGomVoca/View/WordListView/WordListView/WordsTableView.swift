//
//  WordsTableView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordsTableView: View {
    @Binding var filteredWords: [Word]
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    
    let nationality: String
    
    var body: some View {
        ScrollView {
            GeometryReader { geo in
                LazyVStack.init(spacing: 0, pinnedViews: [.sectionHeaders], content: {
                    
                    Section.init(header:
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
                            .frame(width: geo.size.width * 0.5, alignment: .center)
                        Text("성별")
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("뜻")
                            .frame(width: geo.size.width * 0.5, alignment: .center)
                    }
                        .frame(height: 40)
                        .background(Color.blue))
                    {
                        ForEach(filteredWords, id: \.self) { word in
                            WordCell(isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, word: word)
                        }
                    }
                })
            }
        } // ScrollView
        .navigationTitle("단어장")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                VStack {
                    Text("\(multiSelection.count)")
                        .foregroundColor(.gray)
                }
            }
            ToolbarItem {
                Button {
                    isSelectionMode.toggle()
                    multiSelection.removeAll()
                } label: {
                    isSelectionMode ? Text("취소") : Text("편집")
                }
            }
        } // toolbar
    }
}

struct WordsTableView_Previews: PreviewProvider {
    static var previews: some View {
        WordsTableView(filteredWords: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: "JP")
    }
}
