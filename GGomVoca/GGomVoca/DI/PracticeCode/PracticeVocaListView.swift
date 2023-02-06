//
//  PracticeVocaListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import SwiftUI

//DI Container와 CloudKit 테스트를 위한 뷰입니다. (테스트 후 지울 예정)
struct PracticeVocaListView: View {
    
    @StateObject var viewModel : PracticeVocaListViewModel
    
    // MARK: View Properties
   // @StateObject var viewModel = VocabularyListViewModel(vocabularyList: [])
    //NavigationSplitView 선택 단어장 Id
    @State var selectedVocaId : Vocabulary.ID?
    //단어장 추가 뷰 show flag
    @State var isShowingAddVocabulary: Bool = false
    
    @State private var editMode: EditMode = .inactive
        
    var body: some View {
        NavigationView {
            initVocaListView()
                .navigationViewStyle(.stack)
        }
    }

    // MARK: VocabularyList View
    func initVocaListView() -> some View {
      
            // !가 앞에 붙으면 내용이 반전
            Section(header: Text("즐겨찾기")) {
                if !viewModel.vocaList.isEmpty {
                    Section(header: Text("테스트")) {
                        ForEach(viewModel.vocaList) { vocabulary in
//                            VocabularyCell(favoriteCompletion: {
//                                print("click")
//                                //viewModel.getVocabularyData()
//                            }, deleteCompletion: {
//                                print("deleteCompletion")
//                                //viewModel.getVocabularyData()
//                               // viewModel.recentVocabularyList = getRecentVocabulary()
//                            }, vocabulary: vocabulary, editMode: $editMode)
                            
                        }
                    }
                }
                
                
        }
        .listStyle(.sidebar)
        .navigationBarTitle("단어장")
        .navigationBarItems(trailing: Button(action: {
            isShowingAddVocabulary.toggle()
        }, label: { Image(systemName: "plus") }))
        .onAppear {
            //fetch 단어장 data
            viewModel.getVocaListData()
            //viewModel.recentVocabularyList = getRecentVocabulary()
        }
        .sheet(isPresented: $isShowingAddVocabulary) {
            PracticeAddView(service: DependencyManager.shared.resolve(VocabularyService.self)!, isShowingAddVocabulary: $isShowingAddVocabulary)
                .presentationDetents([.height(CGFloat(270))])
                .onDisappear {
                    //fetch 단어장 data
                    //viewModel.getVocabularyData()
                }
        }
    }
    
    func getVocaItem(for itemID: UUID) -> Vocabulary {
        print(itemID)
        guard let vocaItem = viewModel.vocaList.first(where: {$0.id == itemID }) else {
            return Vocabulary()
        }
        
        return vocaItem
    }
    
    // 3개의 단어장 불러오기
    func getRecentVocabulary() -> [Vocabulary] {
        var result = [Vocabulary]()
        let vocaIds = UserManager.shared.recentVocabulary
        vocaIds.forEach{
            if let id = UUID(uuidString: $0) {
                result.append(getVocaItem(for: id))
            }
        }
        print( "getRecentVocabulary() :\(UserManager.shared.recentVocabulary)")
        return result
    }
}

struct PracticeVocaListView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeVocaListView(viewModel: PracticeVocaListViewModel(
            service: VocabularyServiceImpl(
                coreDataRepo: CoreDataRepositoryImpl(
                    context: PersistenceController.shared.container.viewContext),
                cloudDataRepo: CloudKitRepositoryImpl())))
    }
}
