//
//  VocabularyListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct VocabularyListView: View {
    // MARK: CoreData Property
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: View Properties
    @StateObject var viewModel = VocabularyListViewModel(vocabularyList: [])
    //NavigationSplitView 선택 단어장 Id
    @State var selectedVocaId : Vocabulary.ID?
    //단어장 추가 뷰 show flag
    @State var isShowingAddVocabulary: Bool = false
    
//    @State private var editingVocabulary: Vocabulary = Vocabulary()
    
    var body: some View {
        NavigationSplitView {
            initVocaListView()
        } detail: {
            if let selectedVocaId,
               let nationality = getVocaItem(for: selectedVocaId ?? UUID()).nationality {
                
                switch nationality {
                case "KO":
                    KOWordListView(vocabularyID: selectedVocaId)
                case "EN":
                    ENWordListView(vocabularyID: selectedVocaId)
                case "JA":
                    JPWordListView(vocabularyID: selectedVocaId)
                case "FR":
                    FRWordListView(vocabularyID: selectedVocaId)
                default:
                    WordListView(vocabularyID: selectedVocaId)
                }
            }
        }
    }
    /*
     VocabularyList View
     */
    func initVocaListView() -> some View {
        List(selection: $selectedVocaId) {
            Section(header: Text("최근 본 단어장")) {
                if !viewModel.recentVocabularyList.isEmpty {
                    ForEach(viewModel.recentVocabularyList) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                print("cellClosure")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }
            
            // !가 앞에 붙으면 내용이 반전
            Section(header: Text("즐겨찾기")) {
                if viewModel.favoriteVoca.count > 0 {
                    ForEach(viewModel.favoriteVoca) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                } else {
                    VStack {
                        HStack {
                            VStack(spacing: 4) {
                                Text("즐겨찾기 된 단어장이 없습니다.")
                                Text("오른쪽으로 밀어 즐겨찾기")
                            }
                            .horizontalAlignSetting(.center)
                        }
                    }
                    .foregroundColor(.gray)
                }
            }
            
            if !viewModel.koreanVoca.isEmpty {
                Section(header: Text("한국어")) {
                    ForEach(viewModel.koreanVoca) { vocabulary in
                        if vocabulary.nationality == "KO" {
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        }
                    }
                }
            }
            
            if !viewModel.japaneseVoca.isEmpty {
                Section(header: Text("일본어")) {
                    ForEach(viewModel.japaneseVoca) { vocabulary in
                        if vocabulary.nationality == "JA" {
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        }
                    }
                }
            }
            
            if !viewModel.englishVoca.isEmpty {
                Section(header: Text("영어")) {
                    ForEach(viewModel.englishVoca) { vocabulary in
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }
            
            if !viewModel.chineseVoca.isEmpty {
                Section(header: Text("중국어")) {
                    ForEach(viewModel.chineseVoca) { vocabulary in
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }
            
            if !viewModel.frenchVoca.isEmpty {
                Section(header: Text("프랑스어")) {
                    ForEach(viewModel.frenchVoca) { vocabulary in
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                         
                    }
                }
            }
            
            if !viewModel.germanVoca.isEmpty {
                Section(header: Text("독일어")) {
                    ForEach(viewModel.germanVoca) { vocabulary in
                        
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        
                    }
                }
            }
            
            if !viewModel.spanishVoca.isEmpty {
                Section(header: Text("스페인어")) {
                    ForEach(viewModel.spanishVoca) { vocabulary in
                        
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        
                    }
                }
            }
            
            if !viewModel.italianVoca.isEmpty {
                Section(header: Text("이탈리아어")) {
                    ForEach(viewModel.italianVoca) { vocabulary in
                        
                            VocabularyCell(favoriteCompletion: {
                                print("click")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        
                    }
                }
            }
        }
        .navigationBarTitle("단어장")
        .navigationBarItems(trailing: Button(action: {
            isShowingAddVocabulary.toggle()
        }, label: { Image(systemName: "plus") }))
        .onAppear {
            //fetch 단어장 data
            viewModel.getVocabularyData()
            viewModel.recentVocabularyList = getRecentVocabulary()
        }
        .sheet(isPresented: $isShowingAddVocabulary) {
            AddVocabularyView(isShowingAddVocabulary: $isShowingAddVocabulary)
                .presentationDetents([.height(CGFloat(270))])
                .onDisappear {
                    //fetch 단어장 data
                    viewModel.getVocabularyData()
                }
        }
    }
    
    func getVocaItem(for itemID: UUID) -> Vocabulary {
        print(itemID)
        guard let vocaItem = viewModel.vocabularyList.first(where: {$0.id == itemID }) else {
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

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyListView()
    }
}
