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
    
    // 편집 모드 관련
    @State private var editMode: EditMode = .inactive
        
    @State var temp: Vocabulary?
    var body: some View {
        NavigationSplitView {
            initVocaListView()
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
            // MARK: 최근 본 단어장; 최근 본 단어장이 없는 경우 나타나지 않음
            if !viewModel.recentVocabularyList.isEmpty {
                Section(header: Text("최근 본 단어장")) {
                    ForEach(viewModel.recentVocabularyList) { vocabulary in
                        VocabularyCell(
                            favoriteCompletion: {
                                print("cellClosure")
                                viewModel.getVocabularyData()
                            }, deleteCompletion: {
                                print("deleteCompletion")
                                viewModel.getVocabularyData()
                                viewModel.recentVocabularyList = getRecentVocabulary()
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                
            }

            // MARK: 즐겨찾기; 비어 있더라도 해당 기능을 알리기 위해 section 필요
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
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
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
            
            // MARK: 한국어
            if !viewModel.koreanVoca.isEmpty {
                Section(header: Text("한국어")) {
                    ForEach(viewModel.koreanVoca) { vocabulary in
                        VocabularyCell(favoriteCompletion: {
                            print("click")
                            viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            print("deleteCompletion")
                            viewModel.getVocabularyData()
                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }
            
            // MARK: 영어
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
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }

            // MARK: 일본어
            if !viewModel.japaneseVoca.isEmpty {
                Section(header: Text("일본어")) {
                    ForEach(viewModel.japaneseVoca) { vocabulary in
                        VocabularyCell(favoriteCompletion: {
                            print("click")
                            viewModel.getVocabularyData()
                        }, deleteCompletion: {
                            print("deleteCompletion")
                            viewModel.getVocabularyData()
                            viewModel.recentVocabularyList = getRecentVocabulary()
                        }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
            }

            // MARK: 프랑스어
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
                            }, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
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
        .environment(\.editMode, $editMode)
        .animation(.default, value: editMode) // environment로 editmode를 구현하면 기본으로 제공되는 editbutton과 다르게 애니메이션이 없음. 그래서 직접 구현
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
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.vocabularyList.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        viewModel.vocabularyList.remove(atOffsets: offsets)
    }
}

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyListView()
    }
}
