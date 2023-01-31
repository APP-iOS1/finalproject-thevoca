//
//  KOWordListView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct KOWordListView: View {
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    @StateObject var viewModel: KOWordListViewModel = KOWordListViewModel()
    
    // MARK: View Properties
    /// - onAppear 될 때 viewModel에서 값 할당
    @State private var navigationTitle: String = ""
    @State private var emptyMessage: String = ""
    @State private var selectedSegment: ProfileSection = .normal
    @State private var unmaskedWords: [Word.ID] = [] // segment에 따라 Word.ID가 배열에 있으면 보임, 없으면 안보임
    
    /// - 단어 추가 버튼 관련 State
    @State var addNewWord: Bool = false
    
    /// - 단어장 내보내기 관련 State
    @State var isExport: Bool = false
    
    /// - 단어장 편집모드 관련 State
    @State var isSelectionMode: Bool = false
    @State private var multiSelection: Set<Word> = Set<Word>()
    
    var body: some View {
        VStack(spacing: 0) {
            SegmentView(selectedSegment: $selectedSegment, unmaskedWords: $unmaskedWords)
            
            if viewModel.words.isEmpty {
                VStack(spacing: 10) {
                  EmptyWordListView(lang: viewModel.nationality)
                }
                .foregroundColor(.gray)
                .verticalAlignSetting(.center)
            } else {
                KOWordsTableView(viewModel: viewModel, selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection)
            }
            
            if !multiSelection.isEmpty {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color("toolbardivider"))
                        .frame(height: 1)
                    
                    HStack {
                        // TODO: 단어장 이동 버튼; sheet가 올라오고 단어장 목록이 나옴
                        Button {
                            
                        } label: {
                            Image(systemName: "folder")
                        }

                        Spacer()
                        
                        // TODO: 삭제하기 전에 OO개의 단어를 삭제할거냐고 확인하기 confirmationDialog...
                        Button(role: .destructive) {
                            for word in multiSelection {
                                viewModel.deleteWord(word: word)
                            }
                            isSelectionMode.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .padding()
                    }
                    .background(Color("toolbarbackground"))
                }
            }
        }
        .navigationTitle(isSelectionMode ? "선택된 단어 \(multiSelection.count)개" : navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getVocabulary(vocabularyID: vocabularyID)
            navigationTitle = viewModel.selectedVocabulary.name ?? ""
            emptyMessage = viewModel.getEmptyWord()
        }
        // 새 단어 추가 시트
        .sheet(isPresented: $addNewWord) {
            KOAddNewWordView(viewModel: viewModel, addNewWord: $addNewWord)
                .presentationDetents([.height(CGFloat(500))])
        }
        // 단어장 내보내기
        .fileExporter(isPresented: $isExport, document: CSVFile(initialText: viewModel.buildDataForCSV() ?? ""), contentType: .commaSeparatedText, defaultFilename: "\(navigationTitle)") { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .toolbar {
            // TODO: 편집모드에 따른 toolbar State 분기
            if !isSelectionMode { // 기존에 보이는 툴바
                ToolbarItem {
                    VStack(alignment: .center) {
                        Text("\(viewModel.words.count)")
                            .foregroundColor(.gray)
                    }
                }
                // + 버튼
                ToolbarItem {
                    Button {
                        addNewWord.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                // 햄버거 버튼
                ToolbarItem {
                    Menu {
                        Button {
                            viewModel.words.shuffle()
                        } label: {
                            HStack {
                                Text("단어 순서 섞기")
                                Image(systemName: "shuffle")
                            }
                        }
                        
                        Button {
                            isSelectionMode.toggle()
                        } label: {
                            HStack {
                                Text("단어장 편집하기")
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        
                        NavigationLink {
                            ImportCSVFileView(vocabulary: viewModel.selectedVocabulary)
                        } label: {
                            HStack {
                                Text("단어 가져오기")
                                Image(systemName: "square.and.arrow.down")
                            }
                        }
                        
                        Button {
                            isExport.toggle()
                        } label: {
                            HStack {
                                Text("단어 리스트 내보내기")
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            } else { // 편집모드에서 보이는 툴바
                ToolbarItem {
                    Button("취소", role: .cancel) {
                        isSelectionMode.toggle()
                        multiSelection.removeAll()
                    }
                }
            }
        }
    }
}
