//
//  JPAddNewWordView.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/20.
//

import SwiftUI

struct JPAddNewWordView: View {
    // MARK: Super View Properties
    var viewModel : JPWordListViewModel
    
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
                        .disableAutocorrection(true)
                        .focused($wordFocused)
                } header: {
                    HStack {
                        Text("단어")
                        if isWordEmpty {
                            Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                        }
                    }
                }
                
                Section(header: Text("발음")) {
                    TextField("발음을 입력하세요.", text: $inputOption, axis: .vertical)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
                
                Section {
                    ForEach(meanings.indices, id: \.self) { index in
                        FieldView(value: Binding<String>(get: {
                            guard index < meanings.count else { return "" }
                            return meanings[index]
                        }, set: { newValue in
                            guard index < meanings.count else { return }
                            meanings[index] = newValue
                        })) {
                            if meanings.count > 1 {
                                meanings.remove(at: index)
                            } else {
                                // MARK: 최소 뜻 개수 1개 보장
                                
                            }
                        }
                    }
                    // Button("\(Image(systemName: "plus.circle")) \(meanings.count + 1)번째 뜻 추가하기") { meanings.append("") }
                    Button {
                        meanings.append("")
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("\(meanings.count + 1)번째 뜻 추가하기")
                        }
                    }

                } header: {
                    HStack {
                        Text("뜻")
                        if isMeaningEmpty {
                            Text("\(Image(systemName: "exclamationmark.circle")) 사용하지 않는 입력 필드는 삭제해주세요.")
                        }
                    }
                }
                .buttonStyle(.borderless)
            }
            .shakeEffect(trigger: isWordEmpty || isMeaningEmpty)
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
                        
                        // MARK: 뜻이 입력되지 않은 element check
                        meanings.contains("") ? (isMeaningEmpty = true) : (isMeaningEmpty = false)
                        
                        // MARK: 뜻 내부 String trim
                        for i in meanings.indices {
                            meanings[i] = meanings[i].trimmingCharacters(in: .whitespaces)
                        }
                        if !isWordEmpty && !isMeaningEmpty {
                            /// - 단어 추가
                            viewModel.addNewWord(word: word, meaning: meanings, option: option)
                            
                            /// - 단어 추가 후 textField 비우기
                            inputWord = ""
                            meanings = [""]
                            inputOption = ""
                            
                            /// - isContinue 상태에 따라 sheet를 닫지 않고 유지함
                            if !isContinue {
                                dismiss()
                            }
                            /// - 단어를 입력하는 TextField로 Focus 이동
                            wordFocused = true
                        }
                    }
                    .disabled(word.isEmpty || meanings[0].isEmpty)
                }
            }
        }
    }
}

//struct JPAddNewWordView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            JPAddNewWordView(vocabulary: , isShowingAddWordView: .constant(true))
//        }
//    }
//}
