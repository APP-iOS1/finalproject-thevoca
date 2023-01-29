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
    @State var isShowingDeleteAlert: Bool = false
    
    var body: some View {
        NavigationLink {
            WordListView(vocabularyID: vocabulary.id)
            
            //                switch vocabulary.nationality! {
            //                case "JA" :
            //                    JPWordListView(vocabulary: vocabulary)
            //                        .onAppear {
            //                            vm.manageRecentVocabulary(voca: vocabulary)
            //                            print("gesture \(vocabulary.name)")
            //                        }
            //
            //                case "FR" :
            //                    FRWordListView(vocabularyID: vocabulary.id ?? UUID())
            //                        .onAppear {
            //                            vm.manageRecentVocabulary(voca: vocabulary)
            //                            print("gesture \(vocabulary.name)")
            //                        }
            //                case "EN" :
            //                    FRWordListView(vocabularyID: vocabulary.id ?? UUID())
            //                        .onAppear {
            //                            vm.manageRecentVocabulary(voca: vocabulary)
            //                            print("gesture \(vocabulary.name)")
            //                        }
            //                case "KO" :
            //                    JPWordListView(vocabulary: vocabulary)
            //                        .onAppear {
            //                            vm.manageRecentVocabulary(voca: vocabulary)
            //                            print("gesture \(vocabulary.name)")
            //                        }
            //
            //                default:
            //                    FRWordListView(vocabularyID: vocabulary.id ?? UUID())
            //                        .onAppear {
            //                            vm.manageRecentVocabulary(voca: vocabulary)
            //                            print("gesture")
            //                        }
            //                }
            //
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
                //updateData(id: vocabulary.id!)
                isShowingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            
            Alert(title: Text("단어장을 삭제하면, \n 포함된 단어도 모두 삭제됩니다.\n 단어장을 삭제 하시겠습니까?"), primaryButton: .destructive(Text("삭제"), action: {
                vm.updateDeletedData(id: vocabulary.id!)
                //deleteRecentVocabulary(vocaId: vocabulary.id!)
                deleteCompletion() //삭제 후 업데이트
                
            }), secondaryButton: .cancel(Text("취소")))
        }
}
}

//struct VocabularyCell_Previews: PreviewProvider {
//    static var previews: some View {
//        VocabularyCell(vocabulary: .constant(Vocabulary()))
//    }
//}
