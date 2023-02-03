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
    @State var selectedVocabulary : Vocabulary?
    //단어장 추가 뷰 show flag
    @State var isShowingAddVocabulary: Bool = false
        
    @State var temp: Vocabulary?
    var body: some View {
        NavigationSplitView {
            if viewModel.vocabularyList.isEmpty {
                emptyVocabularyView()
            } else {
                initVocaListView()
            }
        } detail: {
            if let selectedVocabulary {
                switch selectedVocabulary.nationality {
                case "KO":
                    KOWordListView(vocabularyID: selectedVocabulary.id)
                        .id(selectedVocabulary.id)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            viewModel.manageRecentVocabulary(voca: selectedVocabulary)
                        }
                case "EN" :
                    ENWordListView(vocabularyID: selectedVocabulary.id)
                        .id(selectedVocabulary.id)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            viewModel.manageRecentVocabulary(voca: selectedVocabulary)
                        }
                case "JA" :
                    JPWordListView(vocabularyID: selectedVocabulary.id)
                        .id(selectedVocabulary.id)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            viewModel.manageRecentVocabulary(voca: selectedVocabulary)
                        }
                case "FR" :
                    FRWordListView(vocabularyID: selectedVocabulary.id)
                        .id(selectedVocabulary.id)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            viewModel.manageRecentVocabulary(voca: selectedVocabulary)
                        }
                default:
                    WordListView(vocabularyID: selectedVocabulary.id)
                        .id(selectedVocabulary.id)
                        .toolbar(.hidden, for: .tabBar)
                        .onAppear {
                            viewModel.manageRecentVocabulary(voca: selectedVocabulary)
                        }
                }
            } else {
                Text("단어장을 선택하세요")
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
        .onAppear {
            //fetch 단어장 data
            viewModel.getVocabularyData()
            viewModel.recentVocabularyList = getRecentVocabulary()
        }
    }

    // MARK: VocabularyList View
    func initVocaListView() -> some View {
        List(selection: $selectedVocabulary) {
            // MARK: 고정된 단어장;
            if !viewModel.favoriteVoca.isEmpty {
                Section("고정된 단어장") {
                    ForEach(viewModel.favoriteVoca) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }
            
            // MARK: 최근 본 단어장; 최근 본 단어장이 없는 경우 나타나지 않음
            if !viewModel.recentVocabularyList.isEmpty {
                Section("최근 본 단어장") {
                    ForEach(viewModel.recentVocabularyList) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }
            
            // MARK: 한국어
            if !viewModel.koreanVoca.isEmpty {
                Section("한국어") {
                    ForEach(viewModel.koreanVoca) { vocabulary in
                        VocabularyCell(favoriteCompletion: {
                            viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary)
                    }
                }
            }
            
            // MARK: 영어
            if !viewModel.englishVoca.isEmpty {
                Section("영어") {
                    ForEach(viewModel.englishVoca) { vocabulary in
                            VocabularyCell(favoriteCompletion: {
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)
                    }
                }
            }

            // MARK: 일본어
            if !viewModel.japaneseVoca.isEmpty {
                Section("일본어") {
                    ForEach(viewModel.japaneseVoca) { vocabulary in
                        VocabularyCell(favoriteCompletion: {
                            viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary)
                    }
                }
            }

            // MARK: 프랑스어
            if !viewModel.frenchVoca.isEmpty {
                Section("프랑스어") {
                    ForEach(viewModel.frenchVoca) { vocabulary in
                            VocabularyCell(favoriteCompletion: {
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary)

                    }
                }
            }
        }
        .navigationBarTitle("단어장")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingAddVocabulary.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
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
    
    // MARK: VocabularyList가 하나도 없을 때 나타낼 View
    func emptyVocabularyView() -> some View {
        VStack(spacing: 10) {
            Text("단어장 없음").font(.title3)
            Text("+ 버튼을 눌러 단어장을 생성하세요")
        }
        .foregroundColor(.gray)
//        .verticalAlignSetting(.top)
        .padding()
        .navigationBarTitle("단어장")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingAddVocabulary.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
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
        return result
    }
}

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyListView()
    }
}
