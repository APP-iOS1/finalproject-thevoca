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
    // 3개의 단어장 불러오기
    func getRecentVocabulary() -> [Vocabulary] {
        let vocabularyFetch = RecentVocabulary.fetchRequest()
        var results = (try? self.viewContext.fetch(vocabularyFetch) as [RecentVocabulary]) ?? []
        
        var vocaList = (results.first?.vocabularies ?? []).allObjects as [Vocabulary]
        vocaList = vocaList.filter{
            word in word.deleatedAt == nil
        }
        return vocaList
    }
    
    
    var body: some View {
  
    NavigationStack {
        List {
            Section(header: Text("최근 본 단어장")) {
                if !viewModel.recentVocabularyList.isEmpty {
                    ForEach(viewModel.recentVocabularyList) { vocabulary in
                        VocabularyCell(
                            cellClosure: {
                            print("cellClosure")
                            viewModel.vocabularyList = viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            print("deleteCompletion")
                            viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            cellClosure: {
                            print("click")
                            viewModel.vocabularyList = viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            print("deleteCompletion")
                            viewModel.vocabularyList = viewModel.getVocabularyData()
                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary)
                    }
                } else {
                    VStack {
                        Image("nedpark")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 100, height: 100)
                            .padding(.vertical, 2)
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
                            VocabularyCell(cellClosure: {
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
                            VocabularyCell(cellClosure: {
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
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
                            VocabularyCell(cellClosure: {
                                print("click")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.vocabularyList = viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            //fetch 단어장 data
            viewModel.vocabularyList = viewModel.getVocabularyData()
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
                        viewModel.vocabularyList = viewModel.getVocabularyData()
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