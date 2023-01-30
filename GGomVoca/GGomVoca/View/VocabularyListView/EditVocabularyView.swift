//
//  EditVocabularyView.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/30.
//

import SwiftUI

struct EditVocabularyView: View {
    // MARK: CoreData 관련 property
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: SuperView Properties
    var vocabulary: Vocabulary
    
    // MARK: View Properties
    @Environment(\.dismiss) private var dismiss
    @State var vocabularyNameInput: String = ""
    @State var nationality: String = ""
    @State var isShowingMessage: Bool = false
    
    private var vocabularyName: String {
        vocabularyNameInput.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        NavigationStack {
            if isShowingMessage {
                Text("\(Image(systemName: "exclamationmark.circle")) 단어장 이름을 입력해 주세요!")
                    .foregroundColor(.gray)
            }
            
            Form {
                TextField("단어장 이름을 입력하세요", text: $vocabularyNameInput)
                Picker(selection: $nationality, label: Text("언어")) {
                    ForEach(Nationality.allCases, id: \.rawValue) { nationality in
                        Text(nationality.rawValue)
                            .tag(nationality)
                    }
                }
                .disabled(true)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("단어장 수정")
            .onAppear {
                vocabularyNameInput = vocabulary.name ?? ""
                nationality = vocabulary.nationality ?? ""
            }
            .toolbar {
                /// - 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) {
                        dismiss()
                    }
                }
                /// - 수정버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("수정") {
                        if vocabularyName.isEmpty {
                            isShowingMessage = true
                        } else {
                            editVocabularyName(vocabulary: vocabulary, vocabularyName: vocabularyName)
                            dismiss()
                        }
                    }
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
