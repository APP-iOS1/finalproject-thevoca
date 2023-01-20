//
//  FRWordListView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/19.
//

import SwiftUI
import CoreData

struct FRWordListView: View {
    // MARK: Data Properties
    var vocabularyID: UUID
    @StateObject var viewModel: FRWordListViewModel = FRWordListViewModel()
    
    // MARK: View Properties
    @State var navigationTitle: String = ""
    @State private var selectedSegment: ProfileSection = .normal
    /// - 단어 가리기/뜻 가리기 segment에서 현재 가려지 않은 단어
    @State private var unmaskedWords: [UUID] = []
    
    // MARK: 단어 추가 버튼 관련 State
    @State var isShowingAddWordView: Bool = false
    
    var body: some View {
        VStack {
            SegmentView(selectedSegment: $selectedSegment, unmaskedWords: $unmaskedWords)
            if viewModel.words.count <= 0 {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                    Text("EMPTY : 비어 있는")
                }
                .foregroundColor(.gray)
                .verticalAlignSetting(.center)
                
            } else {
                FRWordsTableView(viewModel: viewModel, selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords)
                    .padding()
            }
            
        }
        
        // 새 단어 추가 시트
        .sheet(isPresented: $isShowingAddWordView) {
            FRAddNewWordView(vocabulary: viewModel.selectedVocabulary)
                .presentationDetents([.height(CGFloat(500))])
                .onDisappear {
                    viewModel.getVocabulary(vocabularyID: vocabularyID)
                }
        }
        /// - View가 보여질 때 Vocabulary의 ID값으로 해당하는 Vocabulary 객체를 가져옴
        /// - Vocabulary객체를 가져온 후 navigationTitle을 Vocabulary의 이름으로 가져옴
        .onAppear {
            viewModel.getVocabulary(vocabularyID: vocabularyID)
            navigationTitle = viewModel.selectedVocabulary.name ?? ""
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            /// - 현재 단어장의 단어 개수
            ToolbarItem {
                VStack(alignment: .center) {
                    Text("\(viewModel.words.count)")
                        .foregroundColor(.gray)
                }
            }
            /// - 새 단어 추가 버튼
            ToolbarItem {
                Button {
                    isShowingAddWordView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            /// - 햄버거 버튼
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
                    
//                    Button {
//                        print("전체 단어 재생하기")
//                    } label: {
//                        HStack {
//                            Text("전체 단어 재생하기")
//                            Image(systemName: "play.fill")
//                        }
//                    }
//                    .disabled(true)
                    
                    NavigationLink {
                        ImportCSVFileView(vocabulary: viewModel.selectedVocabulary)
                    } label: {
                        HStack {
                            Text("단어 가져오기")
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    
//                    Button {
//                        print("export")
//                    } label: {
//                        HStack {
//                            Text("단어 리스트 내보내기")
//                            Image(systemName: "square.and.arrow.up")
//                        }
//                    }
//                    .disabled(true)
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                }
            }
        }
    }
}
