//
//  VocabularyCell.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI
//단어장 셀 뷰
struct VocabularyCell: View {
    // MARK: SuperView Properties
    var vm : VocabularyCellViewModel = VocabularyCellViewModel()
    //단어장 즐겨찾기 completion Handler
    var pinnedCompletion: () -> ()
    //단어장 삭제 completion Handler
    var deleteCompletion : () -> ()
    @Binding var selectedVocabulary: Vocabulary?
    
    var vocabulary: Vocabulary
    
    // MARK: View Properties
    @State private var deleteActionSheet: Bool = false
    @State private var deleteAlert: Bool = false
    
    private var natianalityIcon: String {
        switch vocabulary.nationality {
        case "KO":
            return "🇰🇷"
        case "EN":
            return "🇺🇸"
        case "JA":
            return "🇯🇵"
        case "FR":
            return "🇫🇷"
        default:
            return ""
        }
    }
    
    private var wordsCount: Int {
        let temp = vocabulary.words?.allObjects as? [Word]
        /// - 삭제되지 않은 상태인 Word만 filter
        let words = temp?.filter { $0.deletedAt == nil } ?? []
        return words.count
    }
    
    /// - 단어장 이름 수정 관련
    @State private var editVocabularyName: Bool = false
    
    /// - 편집 모드 관련
    @Binding var editMode: EditMode
    
    var body: some View {
        NavigationLink(value: vocabulary) {
            HStack {
                Text("\(natianalityIcon) \(vocabulary.name ?? "")")
                Spacer()
                Text("\(wordsCount)").foregroundColor(.gray)
            }
        }
        .isDetailLink(true)
        
//        HStack {
//            Text(vocabulary.name ?? "")
//            
//            Spacer()
//            
//            // editmode가 아닐 때만 보여지고, editmode로 들어오면 사라지게
//            if editMode == .inactive {
//                Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//            }
//            
//            if editMode == .active {
//                Button(action: {
//                    editVocabularyName = true
//                } ) {
//                    Image(systemName: "info.circle")
//                        .foregroundColor(.gray)
//                }
//                .buttonStyle(.plain) // List보다 버튼이 우선 순위를 갖도록
//            }
//        }
//        // overlay & opacity로 실제로는 있지만 안보이게 구현
//        .overlay(
//            NavigationLink(vocabulary.name ?? "", value: vocabulary)
//                .opacity(0)
//        )
        //단어장 고정하기 스와이프
        .swipeActions(edge: .leading) {
            Button {
                vm.updateFavoriteVocabulary(id: vocabulary.id!)
                pinnedCompletion()
            } label: {
                Image(systemName: vocabulary.isPinned ? "pin.slash.fill" : "pin.fill")
            }
            .tint(vocabulary.isPinned ? .gray : .yellow)
        }
        //단어장 삭제 스와이프
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                let words = vocabulary.words?.allObjects as? [Word] ?? []
                if words.isEmpty {
                    vm.updateDeletedData(id: vocabulary.id!)
                    deleteCompletion()
                } else if UIDevice.current.model == "iPhone" {
                    deleteActionSheet = true
                } else {
                    deleteAlert = true
                }
                selectedVocabulary = nil
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .contextMenu {
            Button {
                vm.updateFavoriteVocabulary(id: vocabulary.id!)
                pinnedCompletion()
            } label: {
                if vocabulary.isPinned {
                    HStack {
                        Text("단어장 고정 해제")
                        Spacer()
                        Image(systemName: "pin.slash")
                    }
                } else {
                    HStack {
                        Text("단어장 고정")
                        Spacer()
                        Image(systemName: "pin")
                    }
                }
            }

            Button {
                editVocabularyName.toggle()
            } label: {
                HStack {
                    Text("단어장 이름 변경")
                    Spacer()
                    Image(systemName: "pencil")
                }
            }
        }
        // MARK: 단어장 이름 수정 sheet
        .sheet(isPresented: $editVocabularyName) {
            pinnedCompletion()
        } content: {
            EditVocabularyView(vocabulary: vocabulary)
        }
        // MARK: iPhone에서 단어장을 삭제할 때 띄울 메세지
        .actionSheet(isPresented: $deleteActionSheet) {
            ActionSheet(title: Text("포함된 단어도 모두 삭제됩니다."), buttons: [
                .destructive(Text("단어장 삭제"), action: {
                    vm.updateDeletedData(id: vocabulary.id!)
                    deleteCompletion()
                }),
                .cancel(Text("취소"))
            ])
        }
        // MARK: iPad에서 단어장을 삭제할 때 띄울 메세지
        .alert(isPresented: $deleteAlert) {
            Alert(title: Text("포함된 단어도 모두 삭제됩니다."), primaryButton: .destructive(Text("단어장 삭제"), action: {
                vm.updateDeletedData(id: vocabulary.id!)
                deleteCompletion() //삭제 후 업데이트
            }), secondaryButton: .cancel(Text("취소")))
        }
        // !!!: 추후 confirmationDialog가 안정화 되면 actionSheet대신 적용
//        .confirmationDialog("단어장 삭제", isPresented: $deleteAlert) {
//            Button("단어장 삭제", role: .destructive) {
//                vm.updateDeletedData(id: vocabulary.id!)
//                deleteCompletion()
//            }
//        } message: {
//            Text("포함된 단어도 모두 삭제됩니다.")
//        }
    }
}

//struct VocabularyCell_Previews: PreviewProvider {
//    static var previews: some View {
//        VocabularyCell(vocabulary: .constant(Vocabulary()))
//    }
//}
