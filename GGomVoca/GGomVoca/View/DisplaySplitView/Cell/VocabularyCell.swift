//
//  VocabularyCell.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI
//단어장 셀 뷰
struct VocabularyCell: View {
    
    // TODO: 최근 본 단어장 코드 완전히 걷어 낼때 refreshCompletion으로 변경하고 deleteComletion 삭제
    //단어장 고정하기 completion Handler
    var pinnedCompletion: (UUID) -> ()
    //단어장 삭제 completion Handler
    var deleteCompletion : () -> ()
    @Binding var selectedVocabulary: Vocabulary?
    var vocabulary: Vocabulary
    
    // MARK: UserDefaults
    @AppStorage("pinnedVocabularyIDs")   var pinnedVocabularyIDs  : [String]?
    @AppStorage("koreanVocabularyIDs")   var koreanVocabularyIDs  : [String]?
    @AppStorage("englishVocabularyIDs")  var englishVocabularyIDs : [String]?
    @AppStorage("japanishVocabularyIDs") var japanishVocabularyIDs: [String]?
    @AppStorage("frenchVocabularyIDs")   var frenchVocabularyIDs  : [String]?
    
    // MARK: View Properties
    @State private var deleteActionSheet: Bool = false
    @State private var deleteAlert: Bool = false
    /// - 단어장 이름 수정 관련
    @State private var editVocabularyName: Bool = false
    /// - 편집 모드 관련
    @Binding var editMode: EditMode
    
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
    
    var body: some View {
        NavigationLink(value: vocabulary) {
            HStack {
                Text("\(natianalityIcon) \(vocabulary.name ?? "")")
                Spacer()
                Text("\(wordsCount)").foregroundColor(.gray)
            }
        }
        .isDetailLink(true)
        // 단어장 고정하기 스와이프
        .swipeActions(edge: .leading) {
            Button {
                //vm.updateFavoriteVocabulary(id: vocabulary.id!)
                pinnedCompletion(vocabulary.id!)
                UserManager.pinnedVocabulary(id: vocabulary.id!.uuidString, nationality: vocabulary.nationality!)
            } label: {
                Image(systemName: vocabulary.isPinned ? "pin.slash.fill" : "pin.fill")
            }
            .tint(vocabulary.isPinned ? .gray : .yellow)
        }
        // MARK: 단어장 삭제 Swipe
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                /// - 단어장에 단어가 하나도 없으면(deletedAt만 있거나) 바로 삭제, 그렇지 않으면 alert 띄움
                var words = vocabulary.words?.allObjects as? [Word] ?? []
                words = words.filter { $0.deletedAt != nil }
                if words.isEmpty {
                   
                    deleteCompletion()
                    UserManager.deleteVocabulary(id: vocabulary.id!.uuidString)
                } else if UIDevice.current.model == "iPhone" {
                    deleteActionSheet = true
                } else {
                    deleteAlert = true
                }
                
                /// - 삭제하는 단어장이 detail View에 띄워져 있는 경우 지워줌
                if selectedVocabulary == vocabulary {
                    selectedVocabulary = nil
                }                
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .contextMenu {
            Button {
               
                pinnedCompletion(vocabulary.id!)
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
                    Text("단어장 제목 변경")
                    Spacer()
                    Image(systemName: "pencil")
                }
            }
        }
        // MARK: 단어장 이름 변경 sheet
        .sheet(isPresented: $editVocabularyName) {
            pinnedCompletion(vocabulary.id!) // vocabularyListView를 re-render하게 함
        } content: {
            EditVocabularyView(vocabulary: vocabulary)
        }
        // MARK: iPhone에서 단어장을 삭제할 때 띄울 메세지
        .actionSheet(isPresented: $deleteActionSheet) {
            ActionSheet(title: Text("'\(vocabulary.name ?? "")' 단어장을 삭제 하시겠습니까?"),
                        message: Text("단어장에 포함된 모든 단어가 삭제됩니다.\n삭제된 단어장은 최근 삭제된 단어장에서 확인할 수 있습니다."),
                        buttons: [
                            .destructive(Text("단어장 삭제")) {
                               
                                deleteCompletion()
                                UserManager.deleteVocabulary(id: vocabulary.id!.uuidString)
                            },
                            .cancel(Text("취소"))
                        ])
        }
        // MARK: iPad에서 단어장을 삭제할 때 띄울 메세지
        .alert(isPresented: $deleteAlert) {
            Alert(title: Text("'\(vocabulary.name ?? "")' 단어장을 삭제 하시겠습니까?"),
                  message: Text("단어장에 포함된 모든 단어가 삭제됩니다.\n삭제된 단어장은 최근 삭제된 단어장에서 확인할 수 있습니다."),
                  primaryButton: .destructive(Text("단어장 삭제")) {
//                   
                    deleteCompletion() //삭제 후 업데이트
                   
                    },
                  secondaryButton: .cancel(Text("취소")))
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
