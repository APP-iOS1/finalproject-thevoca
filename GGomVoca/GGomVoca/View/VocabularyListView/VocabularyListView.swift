//
//  VocabularyListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct VocabularyListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @StateObject var viewModel = VocabularyListViewModel(vocabularyList: [])
    
    //단어장 추가 뷰 show flag
    @State var isShowingAddVocabulary: Bool = false
    
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var selectedItem: Vocabulary?
    
    
    func getVocaItem(for itemID: UUID) -> Vocabulary {
        
        let vocaItem = viewModel.vocabularyList.first(where: { $0.id == itemID })! as Vocabulary
                
        return vocaItem
    }
    
    // 3개의 단어장 불러오기
    func getRecentVocabulary() -> [Vocabulary] {
        var result = [Vocabulary]()
        var vocaIds = UserManager.shared.recentVocabulary
        vocaIds.forEach{
            if let id = UUID(uuidString: $0){
                result.append(getVocaItem(for: id))
            }
            
        }
        print( "getRecentVocabulary() :\(UserManager.shared.recentVocabulary)")
        return result
    }
    
    
    var body: some View {
  
    NavigationStack {
        List {
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
                if !viewModel.vocabularyList.isEmpty {
                    var favoriteList = viewModel.vocabularyList.filter {
                        $0.isFavorite == true
                    }
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
                            Spacer()
                            VStack(spacing: 4) {
                                Text("즐겨찾기 된 단어장이 없습니다.")
                                Text("오른쪽으로 밀어 즐겨찾기")
                            }
                            Spacer()
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
                        if vocabulary.nationality == "EN" {
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
            if !viewModel.chineseVoca.isEmpty {
                Section(header: Text("중국어")) {
                    ForEach(viewModel.chineseVoca) { vocabulary in
                        if vocabulary.nationality == "CH" {
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
            if !viewModel.frenchVoca.isEmpty {
                Section(header: Text("프랑스어")) {
                    ForEach(viewModel.frenchVoca) { vocabulary in
                        if vocabulary.nationality == "FR" {
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
            if !viewModel.germanVoca.isEmpty {
                Section(header: Text("독일어")) {
                    ForEach(viewModel.germanVoca) { vocabulary in
                        if vocabulary.nationality == "DE" {
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
            if !viewModel.spanishVoca.isEmpty {
                Section(header: Text("스페인어")) {
                    ForEach(viewModel.spanishVoca) { vocabulary in
                        if vocabulary.nationality == "ES" {
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
            if !viewModel.italianVoca.isEmpty {
                Section(header: Text("이탈리어")) {
                    ForEach(viewModel.italianVoca) { vocabulary in
                        if vocabulary.nationality == "IT" {
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
    }
}

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyListView()
    }
}
