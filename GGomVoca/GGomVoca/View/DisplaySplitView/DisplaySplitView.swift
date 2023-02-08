//
//  VocabularyListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct DisplaySplitView: View {
    // MARK: CoreData Property
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: UbiquitousStorage Property
    @UbiquitousStorage(key: "pinnedVocabularyIDs",   defaultValue: []) var pinnedVocabularyIDs  : [String]
    @UbiquitousStorage(key: "koreanVocabularyIDs",   defaultValue: []) var koreanVocabularyIDs  : [String]
    @UbiquitousStorage(key: "englishVocabularyIDs",  defaultValue: []) var englishVocabularyIDs : [String]
    @UbiquitousStorage(key: "japanishVocabularyIDs", defaultValue: []) var japanishVocabularyIDs: [String]
    @UbiquitousStorage(key: "frenchVocabularyIDs",   defaultValue: []) var frenchVocabularyIDs  : [String]
    
    // MARK: View Properties
    @StateObject var viewModel : DisplaySplitViewModel
    @State private var splitViewVisibility: NavigationSplitViewVisibility = .all
    //NavigationSplitView 선택 단어장 Id
    @State private var selectedVocabulary : Vocabulary?
    //단어장 추가 뷰 show flag
    @State private var isShowingAddVocabulary: Bool = false
    
    // 편집 모드 관련
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationSplitView(columnVisibility: $splitViewVisibility) {
            sidebarView()
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
                notSelectedVocabularyView()
            }
        }
        .navigationSplitViewStyle(.automatic)
        .onAppear {
            //fetch 단어장 data
//            UserManager.shared.japanishVocabularyIDs.removeAll()
//            UserManager.shared.englishVocabularyIDs.removeAll()
//            UserManager.shared.koreanVocabularyIDs.removeAll()
//            UserManager.shared.frenchVocabularyIDs.removeAll()
//            UserManager.shared.pinnedVocabularyIDs.removeAll()
//
            viewModel.getVocabularyData()
        }
    }
    
    // MARK: VocabularyList의 상태에 따라 분기되는 Sidebar View 및 공통 수정자
    func sidebarView() -> some View {
        Group {
            if viewModel.vocabularyList.isEmpty {
                emptyVocabularyListView()
            } else {
                vocabularyListView()
            }
        }
        .navigationBarTitle("단어장")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button {
                    isShowingAddVocabulary.toggle()
                } label: {
                    //                    Image(systemName: "plus.circle")
                    Image(systemName: "folder.badge.plus")
                    //                    Image(systemName: "doc.badge.plus")
                    //                    HStack(spacing: 3) {
                    //                        Image(systemName: "plus.circle")
                    //                        Text("단어장 추가")
                    //                    }
                }
                .disabled(editMode == .active)
            }
        }
        .sheet(isPresented: $isShowingAddVocabulary) {
            AddVocabularyView(addCompletion:{  name , nationality in
                viewModel.addVocabulary(name: name, nationality: nationality)})
           
                .presentationDetents([.height(CGFloat(270))])
        }
    }
    
    // MARK: VocabularyList가 비어있을 때 표시되는 sidebar View
    func emptyVocabularyListView() -> some View {
        VStack(spacing: 10) {
            Text("단어장 없음").font(.title3)
            Text("하단의 버튼을 눌러 단어장을 생성하세요")
        }
        .foregroundColor(.gray)
        .padding()
    }

    // MARK: VocabularyList가 비어있지 않을 때 표시되는 sidebar view
    func vocabularyListView() -> some View {
        List(selection: $selectedVocabulary) {
            // MARK: 고정된 단어장
            if !pinnedVocabularyIDs.isEmpty {
                Section("고정된 단어장") {
                    ForEach(pinnedVocabularyIDs, id: \.self) { vocabularyID in
                        let vocabulary = viewModel.getVocabulary(for: vocabularyID)
                        VocabularyCell(
                            pinnedCompletion: { vocaId in
                                viewModel.updateIsPinnedVocabulary(id: vocaId)
                            }, deleteCompletion: {
                                viewModel.getVocabularyData()
                            }, selectedVocabulary: $selectedVocabulary, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onDelete { indexSet in
                        for offset in indexSet {
                            let deleted = UserManager.editModeDeleteVocabulary(at: offset, in: "pinned")
                            viewModel.deleteVocabulary(id: deleted)
                        }
                    }
                    .onMove { from, to in
                        UserManager.shared.pinnedVocabularyIDs.move(fromOffsets: from, toOffset: to)
                    }
                }
            }

//            MARK: 최근 본 단어장; 최근 본 단어장이 없는 경우 나타나지 않음
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
            if !koreanVocabularyIDs.isEmpty {
                Section("한국어") {
                    ForEach(koreanVocabularyIDs, id: \.self) { vocabularyID in
                        let vocabulary = viewModel.getVocabulary(for: vocabularyID)
                        VocabularyCell(pinnedCompletion: { vocaId in
                            viewModel.updateIsPinnedVocabulary(id: vocaId)
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                        }, selectedVocabulary: $selectedVocabulary, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onDelete { indexSet in
                        for offset in indexSet {
                            let deleted = UserManager.editModeDeleteVocabulary(at: offset, in: "korean")
                            viewModel.deleteVocabulary(id: deleted)
                        }
                    }
                    .onMove { from, to in
                        UserManager.shared.koreanVocabularyIDs.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            
            // MARK: 영어
            if !englishVocabularyIDs.isEmpty {
                Section("영어") {
                    ForEach(englishVocabularyIDs, id: \.self) { vocabularyID in
                        let vocabulary = viewModel.getVocabulary(for: vocabularyID)
                        VocabularyCell(pinnedCompletion: {vocaId in
                            viewModel.updateIsPinnedVocabulary(id: vocaId )
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                        }, selectedVocabulary: $selectedVocabulary, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onDelete { indexSet in
                        for offset in indexSet {
                            let deleted = UserManager.editModeDeleteVocabulary(at: offset, in: "english")
                            viewModel.deleteVocabulary(id: deleted)
                        }
                    }
                    .onMove { from, to in
                        UserManager.shared.englishVocabularyIDs.move(fromOffsets: from, toOffset: to)
                    }
                }
            }

            // MARK: 일본어
            if !japanishVocabularyIDs.isEmpty {
                Section("일본어") {
                    ForEach(japanishVocabularyIDs, id: \.self) { vocabularyID in
                        let vocabulary = viewModel.getVocabulary(for: vocabularyID)
                        VocabularyCell(pinnedCompletion: { vocaId in
                            viewModel.updateIsPinnedVocabulary(id: vocaId )
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                        }, selectedVocabulary: $selectedVocabulary, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onDelete { indexSet in
                        for offset in indexSet {
                            let deleted = UserManager.editModeDeleteVocabulary(at: offset, in: "japanish")
                            viewModel.deleteVocabulary(id: deleted)
                        }
                    }
                    .onMove { from, to in
                        UserManager.shared.japanishVocabularyIDs.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
            
            // MARK: 프랑스어
            if !frenchVocabularyIDs.isEmpty {
                Section("프랑스어") {
                    ForEach(frenchVocabularyIDs, id: \.self) { vocabularyID in
                        let vocabulary = viewModel.getVocabulary(for: vocabularyID)
                        VocabularyCell(pinnedCompletion: { vocaId in
                            viewModel.updateIsPinnedVocabulary(id: vocaId )
                        }, deleteCompletion: {
                            viewModel.getVocabularyData()
                        }, selectedVocabulary: $selectedVocabulary, vocabulary: vocabulary, editMode: $editMode)
                    }
                    .onDelete { indexSet in
                        for offset in indexSet {
                            let deleted = UserManager.editModeDeleteVocabulary(at: offset, in: "french")
                            viewModel.deleteVocabulary(id: deleted)
                        }
                    }
                    .onMove { from, to in
                        UserManager.shared.frenchVocabularyIDs.move(fromOffsets: from, toOffset: to)
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
        /// - environment로 editmode를 구현하면 기본으로 제공되는 editbutton과 다르게 애니메이션이 없음. 그래서 직접 구현
        .animation(.default, value: editMode)
        .toolbar {
            /// - 편집 모드
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
                .onDisappear {
                    editMode = .inactive
                }
            }
        }
    }

    // MARK: selectedVocabulary가 nil이면서 vocabularyList의 상태에 따라 분기되는 Detail View 및 공통 수정자
    func notSelectedVocabularyView() -> some View {
        Group {
            if viewModel.vocabularyList.isEmpty {
                emptyVocabularyListDetailView()
            } else {
                vocabularyListDetailView()
            }
        }
        .navigationTitle("") // 이게 없으면, 보고 있던 단어장을 삭제했을 때 그 삭제한 단어장 이름이 계속 남아있음
        .foregroundColor(.gray)
        .padding(.top, 15)
    }
    
    // MARK: VocabularyList가 비어있을 때 표시되는 detail View
    func emptyVocabularyListDetailView() -> some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "sidebar.left")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Image(systemName: "arrow.right")
                Image(systemName: "folder.badge.plus")
//                        Image(systemName: "plus.circle")
                    .font(.largeTitle)
                    .fontWeight(.light)
                Image(systemName: "arrow.right")
                Image(systemName: "character.book.closed")
                    .font(.largeTitle)
                    .fontWeight(.light)
            }
            
            Text("왼쪽 사이드바에서 단어장을 추가하세요.")
        }
    }
    
    // MARK: VocabularyList가 비어있지 않을 때 표시되는 detail View
    func vocabularyListDetailView() -> some View {
        VStack(alignment:.leading, spacing: 10) {
            Text("왼쪽 사이드바에서 단어장을 선택하세요.")
                .font(.title2)
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "pin")
                    Text("단어장을 오른쪽(\(Image(systemName: "arrow.right")))으로 밀면 상단에 고정됩니다.")
                }
                HStack {
                    Image(systemName: "trash")
                    Text("단어장을 왼쪽(\(Image(systemName: "arrow.left")))으로 밀면 삭제할 수 있습니다.")
                }
                HStack {
                    Image(systemName: "pencil")
                    Text("단어장을 길게 누르면 단어장의 제목을 변경할 수 있습니다.")
                }
            }
        }
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
//        return result
//    }
}

struct VocabularyListView_Previews: PreviewProvider {
    static var previews: some View {
        DisplaySplitView(viewModel: DisplaySplitViewModel(vocabularyList: [], service: VocabularyServiceImpl(coreDataRepo: CoreDataRepositoryImpl(context: PersistenceController.shared.container.viewContext), cloudDataRepo: CloudKitRepositoryImpl())))
    }
}
