//
//  FRWordListView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/19.
//

import SwiftUI
import CoreData

struct FRWordListView: View {
    
    @State private var selectedSegment: ProfileSection = .normal
    /// - 단어 가리기/뜻 가리기 segment에서 현재 가려지 않은 단어
    @State private var unmaskedWords: [UUID] = []
    
    // MARK: 단어 추가 버튼 관련 State
    @State var isShowingAddWordView: Bool = false
    
    @State var vocabulary: Vocabulary
    
    @State var words: [Word] = [] {
        didSet {
            print("words changed")
            filteredWords = words.filter({ $0.deletedAt == "" || $0.deletedAt == nil })
        }
    }
    
    @State var filteredWords: [Word] = []
    @State private var showOption: Bool = false
    
    var body: some View {
        VStack {
            SegmentView(selectedSegment: $selectedSegment, unmaskedWords: $unmaskedWords)
            if viewModel.words.count <= 0 {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                    HStack {
                        Text("\(viewModel.getEmptyWord(vocabularyID: vocabularyID)) : ")
                            .bold()
                        Text("비어있는")
                    }
                }
                .foregroundColor(.gray)
            } else {
                FRWordsTableView(viewModel: viewModel, selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords)
                    .padding()
            }
            
        }
        // 새 단어 추가 시트
        .sheet(isPresented: $isShowingAddWordView) {
            FRAddNewWordView(viewModel: viewModel, vocabulary: viewModel.selectedVocabulary)
                .presentationDetents([.height(CGFloat(500))])
        }
        .sheet(isPresented: $showOption) {
            OptionSheetView(words: $filteredWords, vocabulary: vocabulary)
                .presentationDetents([.height(CGFloat(350))])
            //                    .presentationDetents([.medium, .large, .height(CGFloat(100))])
        }
        .onAppear(perform: {
            words = vocabulary.words?.allObjects as! [Word]
            
        })
        .navigationTitle("\(vocabulary.name ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                VStack(alignment: .center) {
                    Text("\(viewModel.words.count)")
                        .foregroundColor(.gray)
                }
            }
            // + 버튼
            ToolbarItem {
                Button {
                    isShowingAddWordView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem {
                // 햄버거 버튼일 때
                Menu {
                    Button {
                        words.shuffle()
                    } label: {
                        HStack {
                            Text("단어 순서 섞기")
                            Image(systemName: "shuffle")
                        }
                    }
                    
                    Button {
                        print("전체 단어 재생하기")
                    } label: {
                        HStack {
                            Text("전체 단어 재생하기")
                            Image(systemName: "play.fill")
                        }
                    }
                    .disabled(true)
                    
                    NavigationLink {
                        ImportCSVFileView(vocabulary: vocabulary)
                    } label: {
                        HStack {
                            Text("단어 가져오기")
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    
                    Button {
                        print("export")
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
        }
    }
}
