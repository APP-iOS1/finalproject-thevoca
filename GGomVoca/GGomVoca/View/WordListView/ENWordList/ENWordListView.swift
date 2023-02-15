//
//  ENWordListView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI
import UIKit
struct ENWordListView: View {
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    
    @StateObject var viewModel: ENENWordListViewModel = DependencyManager.shared.resolve(ENENWordListViewModel.self)!
    @StateObject var speechSynthesizer = SpeechSynthesizer()
    
    // MARK: View Properties
    /// - onAppear 될 때 viewModel에서 값 할당
    @State private var navigationTitle: String = ""
    @State private var emptyMessage: String = ""
    @State private var unmaskedWords: [Word.ID] = [] // segment에 따라 Word.ID가 배열에 있으면 보임, 없으면 안보임
    
    // MARK: UIKit Menu
    @State var isImportVoca: Bool = false
    @State var isCheckResult: Bool = false
    @State var selectedSegment: ProfileSection = .normal

    @State var selectedOrder: String = "등록순 정렬"
    @State var speakOn: Bool = false

    @State var isVocaEmpty: Bool = false

    /// - 단어 추가 버튼 관련 State
    @State var addNewWord: Bool = false
    
    /// - 단어장 내보내기 관련 State
    @State var isExport: Bool = false
    
    /// - 단어장 편집모드 관련 State
    @State var isSelectionMode: Bool = false
    @State private var multiSelection: Set<Word> = Set<Word>()
    // 단어 여러 개 삭제 시 확인 메시지
    @State var confirmationDialog: Bool = false // iPhone
    @State var removeAlert: Bool = false // iPad
    
    /// - 단어 시험모드 관련 State
    @State private var isTestMode: Bool = false
    
    // 전체 발음 듣기 관련 State
    @State private var isSpeech = false
    
    /// 단어 듣기 관련 프로퍼티
    private var selectedWords: [Word] {
        var array = [Word]()
        
        self.multiSelection.forEach { word in
            array.append(word)
        }
        
        return array
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                if viewModel.words.isEmpty {
                    VStack(spacing: 10) {
                        EmptyWordListView(lang: viewModel.nationality)
                    }
                    .foregroundColor(.gray)
                    .verticalAlignSetting(.center)
                } else {
                    ENWordsTableView(viewModel: viewModel, speechSynthesizer: speechSynthesizer, selectedSegment: selectedSegment, unmaskedWords: $unmaskedWords, isSelectionMode: $isSelectionMode, multiSelection: $multiSelection)
                        .padding(.top, 15)
                }
                
            }
            .navigationDestination(isPresented: $isImportVoca, destination: {
                ImportCSVFileView(vocabulary: viewModel.selectedVocabulary)
            })
            .navigationDestination(isPresented: $isCheckResult, destination: {
                MyNoteView(words: viewModel.words)
            })
            .navigationTitle(isSelectionMode ? "선택된 단어 \(multiSelection.count)개" : "\(navigationTitle)")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.getVocabulary(vocabularyID: vocabularyID)
                navigationTitle = viewModel.selectedVocabulary.name ?? ""
                if viewModel.words.isEmpty {
                    isVocaEmpty = true
                }
                emptyMessage = viewModel.getEmptyWord()
            }
            // 시험 모드 시트
            .fullScreenCover(isPresented: $isTestMode, content: {
                if viewModel.words.isEmpty {
                    EmptyTestModeView()
                } else {
                    TestScopeSelectView(isTestMode: $isTestMode, vocabularyID: vocabularyID)
                }
            })
            // 단어 여러 개 삭제 여부 (iPhone)
            .confirmationDialog("단어 삭제", isPresented: $confirmationDialog, actions: {
                Button(role: .destructive) {
                    for word in multiSelection {
                        viewModel.deleteWord(word: word)
                    }
                    multiSelection.removeAll()
                    confirmationDialog.toggle()
                    isSelectionMode.toggle()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("\(multiSelection.count)개의 단어 삭제")
                    }
                }
            })
            // 단어 여러 개 삭제 여부 (iPad)
            .alert("\(multiSelection.count)개의 단어를 삭제하시겠습니까?", isPresented: $removeAlert, actions: {
                Button(role: .cancel) {
                    removeAlert.toggle()
                } label: {
                    Text("Cancel")
                }
                
                Button(role: .destructive) {
                    for word in multiSelection {
                        viewModel.deleteWord(word: word)
                    }
                    multiSelection.removeAll()
                    removeAlert.toggle()
                    isSelectionMode.toggle()
                } label: {
                    Text("OK")
                }
                
            })
            // 새 단어 추가 시트
            .sheet(isPresented: $addNewWord) {
                ENAddNewWordView(viewModel: viewModel)
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
                if !isSelectionMode, speechSynthesizer.isPlaying { // 전체 발음 듣기 모드
                    ToolbarItem {
                        Button("취소", role: .cancel) {
                            speechSynthesizer.stopSpeaking()
                        }
                    }
                } else if isSelectionMode {  // 편집 모드
                    ToolbarItem {
                        Button("취소", role: .cancel) {
                            isSelectionMode.toggle()
                            multiSelection.removeAll()
                            speechSynthesizer.stopSpeaking()
                        }
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "folder")
//                        }
//                        .disabled(multiSelection.isEmpty ? true : false)
                            
                        Button("선택한 단어 듣기") {
                            speechSynthesizer.speakWordsAndMeanings(selectedWords, to: "en-US")
                        }
                        .disabled(multiSelection.isEmpty ? true : false)
                        
                        Button(role: .destructive) {
                            if UIDevice.current.model == "iPhone" {
                                confirmationDialog.toggle()
                            } else if UIDevice.current.model == "iPad" {
                                removeAlert.toggle()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .disabled(multiSelection.isEmpty ? true : false)
                    }
                    
                } else {
                    // MARK: 새 단어 추가 버튼
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            addNewWord.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("새 단어 추가")
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // MARK: 미트볼 버튼
                    ToolbarItem {
                        CustomMenu(currentMode: $selectedSegment, orderMode: $selectedOrder, speakOn: $speakOn, testOn: $isTestMode, editOn: $isSelectionMode, isImportVoca: $isImportVoca, isExportVoca: $isExport, isCheckResult: $isCheckResult, isVocaEmpty: $isVocaEmpty)
                            .onChange(of: selectedSegment) { _ in
                                unmaskedWords = []
                            }
                            .onChange(of: selectedOrder) { value in
                                switch value {
                                case "랜덤 정렬":
                                    viewModel.words.shuffle()
                                case "사전순 정렬":
                                    viewModel.words.shuffle()
                                default:
                                    viewModel.words.shuffle()
                                }
                            }
                            .onChange(of: speakOn) { value in
                                if speakOn {
                                    speechSynthesizer.speakWordsAndMeanings(viewModel.words, to: "en-US")
                                    speakOn.toggle() // speakOn를 false로
                                }
                            }
                        
                    }
                }
            }
            .onDisappear {
                speechSynthesizer.stopSpeaking()
            }
            .onChange(of: viewModel.words.isEmpty) { value in
              isVocaEmpty = value
            }
        }
    }
}
