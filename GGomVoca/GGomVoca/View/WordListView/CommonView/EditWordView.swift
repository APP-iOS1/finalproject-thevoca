//
//  EditWordView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/21.
//

import SwiftUI
//단어 수정 뷰
struct EditWordView: View {
    
    var vocabulary: Vocabulary
    var viewModel : EditWordViewModel = EditWordViewModel()
    @Binding var editShow: Bool
    @Binding var bindingWord: Word
    @Binding var filteredWords: [Word]
    @Binding var words: [Word]
    
    @State private var isContinue: Bool = false
    // MARK: Super View Properties
    // @Binding var editingWord: Word
    
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

    
    var body: some View {
        NavigationStack {
            
            Form {
                Section(header: Text("단어")) {
                    TextField("단어를 입력하세요.", text: $inputWord)
                }
                
                switch vocabulary.nationality {
                case "JA":
                    Section(header: Text("발음")) {
                        TextField("발음을 입력하세요.", text: $inputOption)
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
                
                Section(header: Text("뜻")) {
                    TextField("뜻을 입력하세요.", text: $inputMeaning)
                }
            }
            .onAppear(perform: {
                inputWord = bindingWord.word!
                inputOption = bindingWord.option ?? ""
                inputMeaning = bindingWord.meaning!
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("단어 수정")
            .onAppear {
                inputWord = editingWord.word!
                inputOption = editingWord.option ?? ""
                inputMeaning = editingWord.meaning!
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        editShow = false
                    } label: {
                        Text("취소").foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !word.isEmpty && !meaning.isEmpty {
                            viewModel.editWord(vocabulary: vocabulary, editWord: bindingWord, word: word, meaning: meaning, option: option)
                            
                            inputWord = ""
                            inputMeaning = ""
                            inputOption = ""

                            editShow = false
                        }
                        
                    } label: {
                        Text("변경")
                    }
                }
            }
        }
    }
}
