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
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .all
    //NavigationSplitView 선택 단어장 Id
    @State private var selectedVocabulary : Vocabulary?
    //단어장 추가 뷰 show flag
    @State private var isShowingAddVocabulary: Bool = false
    
    // 편집 모드 관련
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            if viewModel.vocabularyList.isEmpty {
                emptyVocabularyView()
            } else {
                initVocaListView()
            }
        } detail: {
            if let selectedVocabulary {
                NavigationStack {
                    switch selectedVocabulary.nationality {
                    case "KO":
                        KOWordListView(vocabularyID: selectedVocabulary.id)
                            .id(selectedVocabulary.id)
                            .toolbar(.hidden, for: .tabBar)
                    case "EN" :
                        ENWordListView(vocabularyID: selectedVocabulary.id)
                            .id(selectedVocabulary.id)
                            .toolbar(.hidden, for: .tabBar)
                    case "JA" :
                        JPWordListView(vocabularyID: selectedVocabulary.id)
                            .id(selectedVocabulary.id)
                            .toolbar(.hidden, for: .tabBar)
                    case "FR" :
                        FRWordListView(vocabularyID: selectedVocabulary.id)
                            .id(selectedVocabulary.id)
                            .toolbar(.hidden, for: .tabBar)
                    default:
                        WordListView(vocabularyID: selectedVocabulary.id)
                            .id(selectedVocabulary.id)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            } else {
                if viewModel.vocabularyList.isEmpty {
                    Text("왼쪽 사이드바에서 단어장을 추가하고 선택하세요.")
                } else {
                    Text("왼쪽에서 단어장을 선택하세요")
                }
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            //fetch 단어장 data
            viewModel.getVocabularyData()
        }
    }

    // MARK: VocabularyList View
    func initVocaListView() -> some View {
        List(selection: $selectedVocabulary) {
            // MARK: 고정된 단어장;
            if !viewModel.pinnedVocabularyList.isEmpty {
                Section("고정된 단어장") {
                    ForEach(viewModel.pinnedVocabularyList) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
//                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: { source, destination in
                        move(from: source, to: destination, type: "recent")
                    })
                    .onDelete(perform: { source in
                        delete(at: source, type: "recent")
                    })
                }
            }
            
//             MARK: 최근 본 단어장; 최근 본 단어장이 없는 경우 나타나지 않음
//            if !viewModel.recentVocabularyList.isEmpty {
//                Section("최근 본 단어장") {
//                    ForEach(viewModel.recentVocabularyList) { vocabulary in
//                        VocabularyCell(
//                            favoriteCompletion: {
//                                viewModel.getVocabularyData()
//                            }, deleteCompletion: {
//                                viewModel.getVocabularyData()
//                                viewModel.recentVocabularyList = getRecentVocabulary()
//                            }, vocabulary: vocabulary, editMode: $editMode)
//                    }
//                    .onMove(perform: { source, destination in
//                        move(from: source, to: destination, type: "favorite")
//                    })
//                    .onDelete(perform: { source in
//                        delete(at: source, type: "favorite")
//                    })
//                } else {
//                    VStack {
//                        HStack {
//                            VStack(spacing: 4) {
//                                Text("즐겨찾기 된 단어장이 없습니다.")
//                                Text("오른쪽으로 밀어 즐겨찾기")
//                            }
//                            .horizontalAlignSetting(.center)
//                        }
//                    }
//                    .foregroundColor(.gray)
//                }
//            }
            
            // MARK: 한국어
            if !viewModel.koreanVoca.isEmpty {
                Section("한국어") {
                    ForEach(viewModel.koreanVoca) { vocabulary in
                        VocabularyCell(favoriteCompletion: {
                            viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
//                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: { source, destination in
                        move(from: source, to: destination, type: "KR")
                    })
                    .onDelete(perform: { source in
                        delete(at: source, type: "KR")
                    })
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
//                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: { source, destination in
                        move(from: source, to: destination, type: "EN")
                    })
                    .onDelete(perform: { source in
                        delete(at: source, type: "EN")
                    })
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
//                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: { source, destination in
                        move(from: source, to: destination, type: "JA")
                    })
                    .onDelete(perform: { source in
                        delete(at: source, type: "JA")
                    })
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
//                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: { source, destination in
                        move(from: source, to: destination, type: "FR")
                    })
                    .onDelete(perform: { source in
                        delete(at: source, type: "FR")
                    })
                }
            }
        }
        .navigationBarTitle("단어장")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    if editMode == .inactive {
                        editMode = .active
                    } else {
                        editMode = .inactive
                    }
                } label: {
                    Text(editMode == .inactive ? "편집" : "완료")
                }
                
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
        .environment(\.editMode, $editMode)
        .animation(.default, value: editMode) // environment로 editmode를 구현하면 기본으로 제공되는 editbutton과 다르게 애니메이션이 없음. 그래서 직접 구현
    }
    
    func getVocaItem(for itemID: UUID) -> Vocabulary {
        guard let vocaItem = viewModel.vocabularyList.first(where: {$0.id == itemID }) else {
            return Vocabulary()
        }
        
        return vocaItem
    }
    
//    // 3개의 단어장 불러오기
//    func getRecentVocabulary() -> [Vocabulary] {
//        var result = [Vocabulary]()
//        print("아직 돌기전", result)
//        let vocaIds = UserManager.shared.recentVocabulary
//        print("vocaIds", vocaIds)
//        for vocaId in vocaIds {
//            if let id = UUID(uuidString: vocaId) {
//                print(id)
//                result.append(getVocaItem(for: id))
//            }
//        }
//
//        print("결과받아라", result)
//        return result
//    }
    
    func move(from source: IndexSet, to destination: Int, type: String) {
        switch type {
        case "KR":
            viewModel.koreanVoca.move(fromOffsets: source, toOffset: destination)
        case "EN":
            viewModel.englishVoca.move(fromOffsets: source, toOffset: destination)
        case "JA":
            viewModel.japaneseVoca.move(fromOffsets: source, toOffset: destination)
        case "FR":
            viewModel.frenchVoca.move(fromOffsets: source, toOffset: destination)
//        case "recent":
//            viewModel.recentVocabularyList.move(fromOffsets: source, toOffset: destination)
        case "favorite":
            viewModel.pinnedVocabularyList.move(fromOffsets: source, toOffset: destination)
        default:
            break
        }
    }
    
    func delete(at offsets: IndexSet, type: String) {
        switch type {
        case "KR":
            viewModel.koreanVoca.remove(atOffsets: offsets)
        case "EN":
            viewModel.englishVoca.remove(atOffsets: offsets)
        case "JA":
            viewModel.japaneseVoca.remove(atOffsets: offsets)
        case "FR":
            viewModel.frenchVoca.remove(atOffsets: offsets)
//        case "recent":
//            viewModel.recentVocabularyList.remove(atOffsets: offsets)
        case "favorite":
            viewModel.pinnedVocabularyList.remove(atOffsets: offsets)
        default:
            break
        }
    }
}

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyListView()
    }
}
