//
//  WordCell.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordCell: View {
    // MARK: SuperView Properties
    @Binding var selectedSegment: ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    
    // MARK: 단어 수정 관련
    @Binding var isShowingEditWordView: Bool
    @Binding var bindingWord: Word // 편집하려는 단어 보내주기 위해서 사용
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    @State var isTextShowing: Bool = true
    @State var isSelected: Bool = false
    
    let nationality: String
    let word: Word
    
    var checkImage: Image {
        isSelected ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
    }
    
    var body: some View {
        HStack {
            if isSelectionMode {
                // MARK: 체크박스를 직접 눌렀을 때
                Button {
                    isSelected.toggle()
                    
                    if isSelected {
                        multiSelection.insert(word.id?.uuidString ?? "")
                    } else {
                        multiSelection.remove(word.id?.uuidString ?? "")
                    }
                } label: {
                    checkImage
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                }
            }
            
            switch nationality {
            case "JA":
                HStack {
                    Text(word.word ?? "")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .opacity((selectedSegment == .wordTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                    Text(word.option ?? "")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .opacity((selectedSegment == .wordTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                    Text(word.meaning ?? "")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .opacity((selectedSegment == .meaningTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                }
            case "FR", "EN":
                Text(word.word ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .opacity((selectedSegment == .wordTest && !selectedWord.contains(word.id!)) ? 0 : 1)
                HStack(spacing: 0) {
//                    Image(systemName: word.option == "f" ? "f.square" : "m.square")
//                        .font(.subheadline)
//                        .opacity(0.5)
//                    Text(word.meaning ?? "")
                    Image(systemName: word.option == "f" ? "f.square" : word.option == "m" ? "m.square" : "" )
                        .font(.subheadline)
                        .opacity(0.5)
                        .padding(.trailing, 5)

                    Text(word.meaning ?? "")

                }
                .frame(maxWidth: .infinity, alignment: .center)
                .opacity((selectedSegment == .meaningTest && !selectedWord.contains(word.id!)) ? 0 : 1)
            default:
                Text("default")
            }
        }
        .background {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    // 단어장 편집모드에서 체크박스 뿐만이 아니라 cell을 눌러도 체크될 수 있도록
                    if !isSelectionMode {
                        if selectedWord.contains(word.id!) {
                            if let tmpIndex = selectedWord.firstIndex(of: word.id!) {
                                selectedWord.remove(at: tmpIndex)
                            }
                        } else {
                            selectedWord.append(word.id!)
                        }
                    } else {
                        isSelected.toggle()
                        if isSelected {
                            // 선택된 단어를 Set에 삽입
                            multiSelection.insert(word.id?.uuidString ?? "")
                        } else {
                            // 선택해제된 단어를 Set에서 제거
                            multiSelection.remove(word.id?.uuidString ?? "")
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
        .contextMenu(ContextMenu {
            if selectedSegment == .normal {
                Button {
                    bindingWord = word
                    isShowingEditWordView.toggle()
                } label: {
                    Label("수정하기", systemImage: "gearshape.fill")
                }
                Button {
                    // Voice Over
                } label: {
                    Label("발음 듣기", systemImage: "mic.fill")
                }
            }
            
        })
    }
}


//struct WordCell_Previews: PreviewProvider {
//    static var previews: some View {
////        WordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .JP, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "승진", option: "しょうしん", vocabularyID: "1", word: "しんかんはつばいび"))
//        WordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "과일의 설탕절임", option: "f", vocabularyID: "2", word: "confiture"))
//    }
//}
