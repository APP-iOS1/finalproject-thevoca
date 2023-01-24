//
//  WordListView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

struct WordListView: View {
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    @StateObject var viewModel: WordListViewModel = WordListViewModel()
    
    // MARK: View Properties
    /// - onAppear 될 때 viewModel에서 값 할당
    @State var navigationTitle: String = ""
    @State private var emptyMessage: String = ""
    @State private var selectedSegment: ProfileSection = .normal
    @State private var unmaskedWords: [Word.ID] = [] // segment에 따라 Word.ID가 배열에 있으면 보임, 없으면 안보임
    
    /// - 단어 추가 버튼 관련 State
    @State var addNewWord: Bool = false
    
    // MARK: 단어장 내보내기 관련 State
    @State var isExport: Bool = false
    
    // MARK: 단어장 편집모드 관련 State
    @State var isSelectionMode: Bool = false
    @State private var multiSelection: Set<String> = Set<String>()
    
    var body: some View {
        VStack{
            SegmentView(selectedSegment: $selectedSegment, unmaskedWords: $unmaskedWords)
            
            if viewModel.words.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                    HStack {
                        Text("\(emptyMessage) : ")
                            .bold()
                        Text("비어있는")
                    }
                }
                .foregroundColor(.gray)
                .verticalAlignSetting(.center)
                
            } else {
                WordsTableView(viewModel: viewModel, selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection)
            }
            
            if !multiSelection.isEmpty {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color("toolbardivider"))
                        .frame(height: 1)
                    
                    HStack {
                        Spacer()
                        
                        Button("삭제", role: .destructive) {
                            // TODO: 단어삭제를 위한 메서드 작성
                        }
                        .padding()
                    }
                    .background(Color("toolbarbackground"))
                }
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getVocabulary(vocabularyID: vocabularyID)
            navigationTitle = viewModel.selectedVocabulary.name ?? ""
            emptyMessage = viewModel.getEmptyWord()
        }
        // 새 단어 추가 시트
        .sheet(isPresented: $addNewWord) {
            AddNewWordView(viewModel: viewModel, addNewWord: $addNewWord)
                .presentationDetents([.height(CGFloat(500))])
        }
        .toolbar {
            // TODO: toolbar State 분기
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
                        .disabled(true)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            } else { // 새롭게 보이는 툴바
                ToolbarItem {
                    VStack(alignment: .center) {
                        Text("\(multiSelection.count)")
                            .foregroundColor(.gray)
                    }
                }
                
                ToolbarItem {
                    Button {
                        isSelectionMode.toggle()
                        multiSelection.removeAll()
                    } label: {
                        Text("취소")
                    }
                }
            }
        }
    }
}