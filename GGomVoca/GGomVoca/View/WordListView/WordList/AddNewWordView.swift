//
//  AddNewWordView.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/20.
//

import SwiftUI

// TODO: 입력값 디테일 잡기
// [x] 공백일 때 경고메세지 보여주기
// [x] 추가 완료 후 TextFeild Focus word칸으로 잡아주기
// [x] 자동 대문자 방지
// [] 입력 언어에 맞는 키보드

struct AddNewWordView: View {
    // MARK: Super View Properties
    var viewModel : WordListViewModel
    
    // MARK: View Properties
    @Environment(\.dismiss) private var dismiss
    @State private var isContinue: Bool = false
    /// - 입력값 관련
    @State private var inputWord: String = ""
    @State private var inputOption: String = ""
    @State private var inputMeaning: String = ""
    @State private var meanings: [String] = [""]
    
    // 입력값 공백 제거
    private var word: String {
        inputWord.trimmingCharacters(in: .whitespaces)
    }
    private var option: String {
        inputOption.trimmingCharacters(in: .whitespaces)
    }
    private var meaning: [String] {
        [inputMeaning.trimmingCharacters(in: .whitespaces)]
    }
    
    // 입력값이 공백일 때 경고메세지 출력 조건
    @State private var isWordEmpty: Bool = false
    @State private var isMeaningEmpty: Bool = false
    
    // 추가 후 TextFeildFocus 이동
    @FocusState private var wordFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Toggle("입력창 고정하기", isOn: $isContinue)
                    .toggleStyle(.switch)
                
                Section {
                    TextField("단어를 입력하세요.", text: $inputWord, axis: .vertical)
                        .textInputAutocapitalization(.never)
                        .focused($wordFocused)
                } header: {
                    HStack {
                        Text("단어")
                        if isWordEmpty {
                            Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                        }
                    }
                }
                
                switch viewModel.selectedVocabulary.nationality {
                case "KO", "JA":
                    Section(header: Text("발음")) {
                        TextField("발음을 입력하세요.", text: $inputOption, axis: .vertical)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                    
                case "FR":
                    Section(header: Text("성별")) {
                        Picker("성별", selection: $inputOption) {
                            Text("성별 없음").tag("")
                            Text("남성형").tag("m")
                            Text("여성형").tag("f")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                case "EN":
                    EmptyView()
                    
                default:
                    Text("default")
                }
                
                Section {
                  ForEach($meanings, id: \.self) { $mean in
                    TextField("뜻을 입력하세요.", text: $mean, axis: .vertical)
                      .textInputAutocapitalization(.never)
                      .disableAutocorrection(true)
                  }
                } header: {
                    HStack {
                        Text("뜻")
                      Button("+") {
                        meanings.append("")
                      }
                        if isMeaningEmpty {
                            Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("새 단어 추가")
            .onAppear { wordFocused = true }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("추가") {
                        word.isEmpty ? (isWordEmpty = true) : (isWordEmpty = false)
                        meaning.isEmpty ? (isMeaningEmpty = true) : (isMeaningEmpty = false)

                        if !isWordEmpty && !isWordEmpty {
                            /// - 단어 추가
                            viewModel.addNewWord(word: word, meaning: meanings, option: option)
                            
                            /// - 단어 추가 후 textField 비우기
                            inputWord = ""
                            inputMeaning = ""
                            inputOption = ""

                            /// - isContinue 상태에 따라 sheet를 닫지 않고 유지함
                            if !isContinue {
                                dismiss()
                            }
                            /// - 단어를 입력하는 TextField로 Focus 이동
                            wordFocused = true
                        }
                    }
                }
            }
        }
    }
}

//struct AddNewWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            AddNewWordView(vocabulary: , isShowingAddWordView: .constant(true))
//        }
//    }
//}
