//
//  WordCell.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordCell: View {
    @Binding var selectedSegment: ProfileSection
    @Binding var selectedWord: [UUID]
    
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    @State var isTextShowing: Bool = true
    @State var isSelected: Bool = false
    
    let nationality: Nationality
    let word: Word
    
    var checkImage: Image {
        isSelected ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
    }
    
    var body: some View {
        HStack {
            if isSelectionMode {
                Button {
                    isSelected.toggle()
                    multiSelection.insert(word.word!)
                } label: {
                    checkImage
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                }
            }
            
            switch nationality {
            case .EN:
                Text("EN")
            case .KO, .JA, .CH:
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
            case .FR:
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
            case .DE:
                Text("DE")
            case .ES:
                Text("ES")
            case .IT:
                Text("IT")
            }
        }
        .background {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedWord.contains(word.id!) {
                        if let tmpIndex = selectedWord.firstIndex(of: word.id!) {
                            selectedWord.remove(at: tmpIndex)
                        }
                    } else {
                        selectedWord.append(word.id!)
                    }
                }
        }
        .frame(height: 50)
        .onChange(of: isSelectionMode) { selectMode in
            // isSelectionMode의 값이 변화할 때 isSelected 값을 false로 바꿔주어 Image도 변경
            // 체크 해제
            if !selectMode {
                isSelected = false
            }
        }
    }
}


//struct WordCell_Previews: PreviewProvider {
//    static var previews: some View {
////        WordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .JP, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "승진", option: "しょうしん", vocabularyID: "1", word: "しんかんはつばいび"))
//        WordCell(selectedSegment: .constant(.normal), selectedWord: .constant([]), isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), nationality: .FR, word: TempWord(correctCount: 0, createdAt: "2023-01-18", deletedAt: "", incorrectCount: 0, isMemorized: false, meaning: "과일의 설탕절임", option: "f", vocabularyID: "2", word: "confiture"))
//    }
//}
