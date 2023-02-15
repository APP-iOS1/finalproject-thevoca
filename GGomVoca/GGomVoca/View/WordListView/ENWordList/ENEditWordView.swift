//
//  ENEditWordView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/21.
//

import SwiftUI

//단어 수정 뷰
struct ENEditWordView: View {
    // MARK: Data Properties
    var viewModel: ENENWordListViewModel
    
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
        NavigationStack {
            Form {
                Section {
                    TextField("단어를 입력하세요.", text: $inputWord, axis: .vertical)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } header: {
                    HStack {
                        Text("단어")
                        if isWordEmpty {
                            Text("\(Image(systemName: "exclamationmark.circle")) 필수 입력 항목입니다.")
                        }
                    }
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
                    Button("\(Image(systemName: "plus.circle.fill")) \(meanings.count + 1)번째 뜻 추가하기") { meanings.append("") }
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
            .navigationTitle("단어 수정")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                inputWord = editingWord.word!
                inputOption = editingWord.option ?? ""
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
                      for i in meanings.indices {
                        meanings[i] = meanings[i].trimmingCharacters(in: .whitespaces)
                      }
                        if !isWordEmpty && !isMeaningEmpty {
                            viewModel.updateWord(editWord: editingWord, word: word, meaning: meanings, option: option)

                            editWord.toggle()
                        }
                    }
                    .disabled(word.isEmpty || meanings[0].isEmpty)
                }
            }
        }
    }
}
