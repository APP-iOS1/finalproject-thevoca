//
//  JPEditWordView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/21.
//

import SwiftUI

//단어 수정 뷰
struct JPEditWordView: View {
    // MARK: Data Properties
    var viewModel: JPWordListViewModel
    
    // MARK: Super View Properties
    @Binding var editWord: Bool
    @Binding var editingWord: Word
    
    // MARK: View Properties
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

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("단어를 입력하세요.", text: $inputWord, axis: .vertical)
                        .textInputAutocapitalization(.never)
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
                  Button("뜻 추가하기") {
                    meanings.append("")
                  }
                } header: {
                  HStack {
                    Text("뜻")
                    if isMeaningEmpty {
                      Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")

                    }
                  }
                }
                .buttonStyle(.borderless)
              }
              .shakeEffect(trigger: isWordEmpty || isMeaningEmpty)
            .navigationTitle("단어 수정")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                inputWord = editingWord.word!
                inputOption = editingWord.option ?? ""
                inputMeaning = editingWord.meaning![0]
              meanings = editingWord.meaning!
            }
            .toolbar {
                // 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) { editWord.toggle() }
                }
                // 변경 내용 저장 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("변경") {
                        word.isEmpty ? (isWordEmpty = true) : (isWordEmpty = false)
                      // MARK: 뜻이 입력되지 않은 element check
                      meanings.contains("") ? (isMeaningEmpty = true) : (isMeaningEmpty = false)
                      print("meanings : \(meanings)")
                      print("isWordEmpty : \(isWordEmpty)")
                      print("isMeaningEmpty : \(isMeaningEmpty)")

                      // MARK: 뜻 내부 String trim
                      print("count: \(meanings.count)")
                      for i in 0..<meanings.count {
                        meanings[i] = meanings[i].trimmingCharacters(in: .whitespaces)
                        print("meaning \(i): \(meanings[i])")
                      }
                        if !isWordEmpty && !isMeaningEmpty {
                            viewModel.updateWord(editWord: editingWord, word: word, meaning: meanings, option: option)

                            editWord.toggle()
                        }
                    }
                }
            }
        }
    }
}
