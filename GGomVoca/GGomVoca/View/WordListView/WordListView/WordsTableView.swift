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
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedSegment: ProfileSection
    @Binding var selectedWord: [UUID]
    
    @Binding var filteredWords: [Word]
    
    // MARK: 단어 수정 관련
    @Binding var isShowingEditWordView: Bool
    @Binding var bindingWord: Word // 편집하려는 단어 보내주기 위해서 사용
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    
    let nationality: String
    
    var body: some View {
        ScrollView {
            LazyVStack.init(spacing: 0, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    ForEach(filteredWords) { word in
                        WordCell(selectedSegment: $selectedSegment, selectedWord: $selectedWord, isShowingEditWordView: $isShowingEditWordView, bindingWord: $bindingWord, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection, nationality: nationality, word: word)
                            .addSwipeButtonActions(leadingButtons: [],
                                              trailingButton:  [.delete], onClick: { button in
                                switch button {
                                case .delete:
                                    // 삭제에 필요한 메서드 넣기
                                    word.deletedAt = "\(Date())"
                                    print("현재 시간 데이터를 deleteAt prop에 update \(word.deletedAt!)")
                                    // filteredWords에서는 진짜로 제거
                                    if let index = filteredWords.firstIndex(of: word) {
                                        print("\(index)")
                                        filteredWords.remove(at: index)
                                    }
                                    try? viewContext.save()
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
                        
                        switch nationality {
                        case "EN", "FR":
                            Text("단어")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("뜻")
                                .frame(maxWidth: .infinity, alignment: .center)
                        case "JA":
                            Text("단어")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("발음")
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("뜻")
                                .frame(maxWidth: .infinity, alignment: .center)
                        default:
                            Text("default")
                        }
                    }
                    .frame(height: 40)
                    .background {
                        Color.gray
                    }
                } // Section
                
                
                
            } // LazyVStack
        } // ScrollView
        
    }
}

//struct WordsTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        WordsTableView(selectedSegment: .constant(.normal), selectedWord: .constant([]), filteredWords: .constant(FRWords), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR)
//    }
//}
