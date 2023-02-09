//
//  EditVocabularyView.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/30.
//

import SwiftUI

struct EditVocabularyView: View {
    // MARK: Environment Properties
    var viewContext = PersistenceController.shared.container.viewContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: SuperView Properties
    var vocabulary: Vocabulary
    
    // MARK: View Properties
    @State var inputVocabularyName: String = ""
    @State var nationality: String = ""
    @State var isShowingMessage: Bool = false
    
    /// - 입력값 양옆 공백 제거
    private var vocabularyName: String {
        inputVocabularyName.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("단어장 제목") {
                    TextField("단어장의 제목을 입력하세요", text: $inputVocabularyName)
                }
                
                Picker(selection: $nationality, label: Text("공부하는 언어")) {
                    ForEach(Nationality.allCases, id: \.rawValue) { nationality in
                        Text(nationality.rawValue)
                            .tag(nationality)
                    }
                }
                .disabled(true)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("단어장 제목 변경")
            .onAppear {
                inputVocabularyName = vocabulary.name ?? ""
                nationality = vocabulary.nationality ?? ""
            }
            .toolbar {
                /// - 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) { dismiss() }
                }
                /// - 완료 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        editVocabularyName(vocabulary: vocabulary, vocabularyName: inputVocabularyName)
                        dismiss()
                    }
                    /// - 단어장 이름이 공백인 경우 버튼 비활성화
                    .disabled(vocabularyName.isEmpty)
                }
            }
        }
    }
    
    // MARK: 단어장 이름 수정
    private func editVocabularyName(vocabulary: Vocabulary, vocabularyName: String) {
        vocabulary.name = vocabularyName
        saveContext()
    }
    
    // MARK: SaveContext
    private func saveContext() {
        do {
            print("saveContext")
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

}

//struct EditVocabularyView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            EditVocabularyView()
//        }
//    }
//}
