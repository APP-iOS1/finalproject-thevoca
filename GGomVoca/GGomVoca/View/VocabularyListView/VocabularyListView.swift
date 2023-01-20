//
//  VocabularyListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct VocabularyListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //뷰모델
    @StateObject var viewModel = VocabularyListViewModel(vocabularyList: [])
    //NavigationSplitView 선택 단어장 Id
    @State var selectedVocaId : UUID?
    //단어장 추가 뷰 show flag
    @State var isShowingAddVocabulary: Bool = false
    
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedItem: Vocabulary?
    
    
    
    var body: some View {
        if #available(iOS 16, *) {
           // [iOS 16.0 버전 이상 인 경우 SplitView ]
            NavigationSplitView(sidebar: {
                
                initVocaListView()
            }, detail: {
              //Navigation Split DetailView 단어장 화면 (WordListView)
                VStack{
                    
                    if
                        let vocaId = self.selectedVocaId,
                        let nationality = getVocaItem(for: vocaId).nationality{
                        switch nationality{
                        case "JA":
                           
                            JPWordListView( vocabulary: getVocaItem(for: vocaId))
                            //TODO: 최근본 단어장 추가
                        case "FR":
                           
                            FRWordListView(vocabularyID: vocaId)
                            //TODO: 최근본 단어장 추가

                        //TODO: 영어(En) 케이스 추가
                        case "EN":
                            FRWordListView(vocabularyID: vocaId)
                        case "KO":
                            JPWordListView( vocabulary: getVocaItem(for: vocaId))
                        default:
                           
                            FRWordListView(vocabularyID: vocaId)
                        }


                    }
                    
                    
                    //
                }
                
                    
                
                
                
            })
        }
        else {
           // [iOS 16.0 버전 미만 인 경우 ]
            NavigationStack {
                initVocaListView()
            }
        }

    }
    /*
     VocabularyList View
     */
    func initVocaListView() -> some View{
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
//                                Spacer()
                            VStack(spacing: 4) {
                                Text("즐겨찾기 된 단어장이 없습니다.")
                                Text("오른쪽으로 밀어 즐겨찾기")
                            }
                            .horizontalAlignSetting(.center)
//                                Spacer()
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
        .onAppear(perform: {
            //fetch 단어장 data
            viewModel.getVocabularyData()
            viewModel.recentVocabularyList = getRecentVocabulary()
            
        })
        
        .navigationBarTitle("단어장")
        .navigationBarItems(trailing: Button(action: {
            isShowingAddVocabulary.toggle()
        }, label: {
            Image(systemName: "plus")
        })
            .sheet(isPresented: $isShowingAddVocabulary, content: {
                AddVocabularyView(isShowingAddVocabulary: $isShowingAddVocabulary)
                    .presentationDetents([.height(CGFloat(270))])
                    .onDisappear(perform: {
                        //fetch 단어장 data
                        viewModel.getVocabularyData()
                    })
            })
        )
    }
    
    
    func getVocaItem(for itemID: UUID) -> Vocabulary {
        print(itemID)
        guard let vocaItem = viewModel.vocabularyList.first(where: { $0.id == itemID }) as? Vocabulary else{
            
            return Vocabulary()
        }
        
        return vocaItem
    }
    
    // 3개의 단어장 불러오기
    func getRecentVocabulary() -> [Vocabulary] {
        var result = [Vocabulary]()
        let vocaIds = UserManager.shared.recentVocabulary
        vocaIds.forEach{
            if let id = UUID(uuidString: $0){
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
