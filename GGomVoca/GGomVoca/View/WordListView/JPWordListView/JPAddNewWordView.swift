//
//  JPAddNewWordView.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/20.
//

import SwiftUI
//일본어 단어 추가 시트 뷰
struct JPAddNewWordView: View {
   
    var vocabulary: Vocabulary
    var viewModel : JPAddNewWordViewModel = JPAddNewWordViewModel()
    @Binding var isShowingAddWordView: Bool
    @Binding var words: [Word]
    @Binding var filteredWords: [Word]
    
    @State private var isContinue: Bool = false
    
    @State private var inputWord: String = ""
    @State private var inputOption: String = ""
    @State private var inputMeaning: String = ""
    
    // 입력값 공백 제거
    private var word: String {
        inputWord.trimmingCharacters(in: .whitespaces)
    }
    private var option: String {
        inputOption.trimmingCharacters(in: .whitespaces)
    }
    private var meaning: String {
        inputMeaning.trimmingCharacters(in: .whitespaces)
    }
    
    // 입력값이 공백일 때 경고메세지 출력 조건
    @State private var isWordEmpty: Bool = false
    @State private var isMeaningEmpty: Bool = false
    
    // 추가 후 TextFeildFocus 이동
    @FocusState private var wordFocused: Bool
    
    var body: some View {
        NavigationStack {
            
            Form {
                Toggle("계속 이어서 입력하기", isOn: $isContinue)
                    .toggleStyle(.switch)
                
                Section(header: HStack {
                    Text("단어")
                    if isWordEmpty {
                        Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                    }
                }) {
                    TextField("단어를 입력하세요.", text: $inputWord)
                        .textInputAutocapitalization(.never)
                        .focused($wordFocused)
                }
                .padding(0)
                
                Section(header: Text("발음")) {
                    TextField("발음을 입력하세요.", text: $inputOption)
                        .textInputAutocapitalization(.never)
                }
                
                Section(header: HStack {
                    Text("뜻")
                    if isMeaningEmpty {
                        Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                    }
                }) {
                    TextField("뜻을 입력하세요.", text: $inputMeaning)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("새 단어 추가")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowingAddWordView = false
                    } label: {
                        Text("취소").foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        word.isEmpty ? (isWordEmpty = true) : (isWordEmpty = false)
                        meaning.isEmpty ? (isMeaningEmpty = true) : (isMeaningEmpty = false)
                        
                        if !word.isEmpty && !meaning.isEmpty {
                            //post 단어추가
                            viewModel.addNewWord(vocabulary: vocabulary, word: word, meaning: meaning, option: option)
                            
                            inputWord = ""
                            inputMeaning = ""
                            inputOption = ""
                            // isContinue 상태에 따라 sheet를 닫지 않고 유지함
                            if !isContinue {
                                isShowingAddWordView = false
                            }
                            wordFocused = true
                        }
                    } label: {
                        Text("추가")
                    }
                }
            }
        }
    }
}
