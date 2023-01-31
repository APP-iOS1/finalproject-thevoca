//
//  VocabularyCell.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI
//단어장 셀 뷰
struct VocabularyCell: View {
    
    var vm : VocabularyCellViewModel = VocabularyCellViewModel()
    //단어장 즐겨찾기 completion Handler
    var favoriteCompletion: () -> ()
    //단어장 삭제 completion Handler
    var deleteCompletion : () -> ()
    
    var vocabulary: Vocabulary
    @State private var deleteActionSheet: Bool = false
    @State private var deleteAlert: Bool = false
    
    /// - 단어장 이름 수정 관련
    @State private var editVocabularyName: Bool = false
    
    var body: some View {
        NavigationLink {
            switch vocabulary.nationality! {
            case "KO" :
                KOWordListView(vocabularyID: vocabulary.id)
                    .toolbar(.hidden, for: .tabBar)
                    .onAppear {
                        vm.manageRecentVocabulary(voca: vocabulary)
                    }
                
            case "EN" :
                ENWordListView(vocabularyID: vocabulary.id)
                    .toolbar(.hidden, for: .tabBar)
                    .onAppear {
                        vm.manageRecentVocabulary(voca: vocabulary)
                    }
                
            case "JA" :
                JPWordListView(vocabularyID: vocabulary.id)
                    .toolbar(.hidden, for: .tabBar)
                    .onAppear {
                        vm.manageRecentVocabulary(voca: vocabulary)
                    }
                
            case "FR" :
                FRWordListView(vocabularyID: vocabulary.id)
                    .toolbar(.hidden, for: .tabBar)
                    .onAppear {
                        vm.manageRecentVocabulary(voca: vocabulary)
                    }
            default:
                WordListView(vocabularyID: vocabulary.id)
                    .toolbar(.hidden, for: .tabBar)
                    .onAppear {
                        vm.manageRecentVocabulary(voca: vocabulary)
                    }
            }
        } label: {
            Text(vocabulary.name ?? "")
        }
        //단어장 즐겨찾기 추가 스와이프
        .swipeActions(edge: .leading) {
            Button {
                vm.updateFavoriteVocabulary(id: vocabulary.id!)
                favoriteCompletion()
                print("clickclick")
            } label: {
                Image(systemName: vocabulary.isFavorite ? "star.slash" : "star")
            }
            .tint(vocabulary.isFavorite ? .gray : .yellow)
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
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .contextMenu {
            Button("단어장 이름 수정") {
                editVocabularyName.toggle()
            }
        }
        // MARK: 단어장 이름 수정 sheet
        .sheet(isPresented: $editVocabularyName) {
            favoriteCompletion()
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
//        .confirmationDialog("단어장 삭제", isPresented: $isDeleteVocabulary) {
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
