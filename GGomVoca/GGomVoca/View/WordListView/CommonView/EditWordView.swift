//
//  EditWordView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/21.
//

import SwiftUI

//단어 수정 뷰
struct EditWordView: View {
    // MARK: ViewModel Object
    var viewModel: EditWordViewModel = EditWordViewModel()
    
    // MARK: Super View Properties
    var vocabularyNationality: String
    @Binding var selectedWord: Word
    
    // MARK: View Properties
    @Environment(\.dismiss) private var dismiss
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
                Section("단어") {
                    TextField("단어를 입력하세요.", text: $inputWord, axis: .vertical)
                }
                
                switch vocabularyNationality {
                case "JP":
                    Section("발음") {
                        TextField("발음을 입력하세요.", text: $inputOption, axis: .vertical)
                    }
                case "FR":
                    Section("성별") {
                        Picker("성별", selection: $inputOption) {
                            Text("남성형").tag("m")
                            Text("여성형").tag("f")
                        }
                        .pickerStyle(.segmented)
                    }
                default:
                    Text("")
                }
                
                Section("뜻") {
                    TextField("뜻을 입력하세요.", text: $inputMeaning, axis: .vertical)
                }
            }
            .navigationTitle("단어 수정")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                inputWord = selectedWord.word!
                inputOption = selectedWord.option ?? ""
                inputMeaning = selectedWord.meaning!
            }
            .toolbar {
                // 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) { dismiss() }
                }
                // 변경 내용 저장 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("변경") {
                        if !word.isEmpty && !meaning.isEmpty {
                            viewModel.editWord(editWord: selectedWord, word: word, meaning: meaning, option: option)
                            
                            inputWord = ""
                            inputMeaning = ""
                            inputOption = ""
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
   
}
