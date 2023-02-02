//
//  KOWordCell.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct KOWordCell: View {
    // MARK: SuperView Properties
    var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    /// - 단어 리스트 편집 관련 State
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<Word>
    
    // MARK: View Properties
    @State var isSelected: Bool = false
    
    let nationality: String
    @Binding var word: Word
    
    var checkImage: Image {
        isSelected ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
    }
    
    var body: some View {
        HStack {
            if isSelectionMode {
                // MARK: 체크박스를 직접 눌렀을 때
                Button {
                    isSelected.toggle()
                    
                    if isSelected {
                        multiSelection.insert(word)
                    } else {
                        multiSelection.remove(word)
                    }
                } label: {
                    checkImage
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                        .padding(.leading, 20)
                }
            }
            
            HStack {
                Text(word.word ?? "")
                    .horizontalAlignSetting(.center)
                    .multilineTextAlignment(.center)
                    .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
                Text(word.option ?? "")
                    .horizontalAlignSetting(.center)
                    .opacity((selectedSegment == .wordTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
              Text(word.meaning!.joined(separator: ", "))
                    .horizontalAlignSetting(.center)
                    .opacity((selectedSegment == .meaningTest && !unmaskedWords.contains(word.id)) ? 0 : 1)
            }
        }
        .background {
            Color.clear
                .horizontalAlignSetting(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !isSelectionMode {
                        /// - 편집모드가 아닐때는 단어를 가렸다가 보였다가 할 수 있도록
                        if unmaskedWords.contains(word.id) {
                            if let tmpIndex = unmaskedWords.firstIndex(of: word.id) {
                                unmaskedWords.remove(at: tmpIndex)
                            }
                        } else {
                            unmaskedWords.append(word.id)
                        }
                    } else {
                        /// - 단어장 편집모드에서 체크박스 뿐만이 아니라 cell을 눌러도 체크될 수 있도록
                        isSelected.toggle()
                        if isSelected {
                            // 선택된 단어를 Set에 삽입
                            multiSelection.insert(word)
                        } else {
                            // 선택해제된 단어를 Set에서 제거
                            multiSelection.remove(word)
                        }
                    }
                }
        }
        .padding(.vertical, 5)
        .frame(minHeight: 50)
        .onChange(of: isSelectionMode) { selectMode in
            // isSelectionMode의 값이 변화할 때 isSelected 값을 false로 바꿔주어 Image도 변경
            // 체크 해제
            if !selectMode {
                isSelected = false
            }
        }
    }
}


//struct KOWordCell_Previews: PreviewProvider {
//    static var previews: some View {
////        KOWordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .JP, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "승진", option: "しょうしん", vocabularyID: "1", word: "しんかんはつばいび"))
//        KOWordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "과일의 설탕절임", option: "f", vocabularyID: "2", word: "confiture"))
//    }
//}
