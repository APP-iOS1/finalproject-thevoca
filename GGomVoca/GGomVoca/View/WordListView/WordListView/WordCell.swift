//
//  WordCell.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordCell: View {
    @Binding var isSelectionMode: Bool
    @Binding var multiSelection: Set<String>
    @State var isTextShowing: Bool = true
    @State var isSelected: Bool = false
    let word: Word
    
    var checkImage: Image {
        isSelected ? Image(systemName: "checkmark.circle") : Image(systemName: "circle")
    }
    
    var body: some View {
        VStack {
            HStack {
                if isSelectionMode {
                    Button {
                        isSelected.toggle()
                    } label: {
                        checkImage
                            .resizable()
                            .frame(width: 25, height: 25)
                            .padding(.leading, 20)
                    }
                }
                    
                Text(word.word ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(2)
                Text(word.option ?? "")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(word.meaning ?? "")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .opacity(isTextShowing ? 1 : 0)
            }
            .background {
                Color.clear
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .contentShape(Rectangle())
                  .onTapGesture {
                      print("tapped")
                      isTextShowing.toggle()
                  }
            }
            Divider()
                .padding(0)
        }
        .frame(height: 50)
        .onChange(of: isSelectionMode) { selectMode in
            if !selectMode {
                isSelected = false
            }
        }
    }
}


struct WordCell_Previews: PreviewProvider {
    static var previews: some View {
        WordCell(isSelectionMode: .constant(false), multiSelection: .constant(Set<String>()), word: Word())
    }
}
