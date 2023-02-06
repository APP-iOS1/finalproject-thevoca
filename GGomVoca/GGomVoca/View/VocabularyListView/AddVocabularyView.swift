//
//  AddVocabularyView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import SwiftUI

struct AddVocabularyView: View {
    // MARK: Environment Properties
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: View Properties
    @State var inputVocabularyName: String = ""
    @State var nationality: Nationality = Nationality.KO
    
    /// - 입력값 양옆 공백 제거
    var vocabularyName: String {
        inputVocabularyName.trimmingCharacters(in: .whitespaces)
    }
        
    var body: some View {
        NavigationStack {
            Form {
                Section("단어장 제목") {
                    TextField("단어장의 제목을 입력하세요.", text: $inputVocabularyName)
                }

                Picker(selection: $nationality, label: Text("공부하는 언어")) {
                    ForEach(Nationality.allCases, id: \.rawValue) { nationality in
                        Text(nationality.rawValue)
                            .tag(nationality)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("새로운 단어장")
            .toolbar {
                /// - 취소 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소", role: .cancel) { dismiss() }
                }
                /// - 추가 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        addVocabulary()
                        dismiss()
                    }
                    /// - 단어장 이름이 공백인 경우 버튼 비활성화
                    .disabled(vocabularyName.isEmpty)
                }
            }
        }
    }
    
    // MARK: 단어장 추가
    private func addVocabulary() { //name: String, nationality: String
        withAnimation {
            let newVocabulary = Vocabulary(context: viewContext)
            
            newVocabulary.id = UUID()
            newVocabulary.name = "\(self.vocabularyName)"
            newVocabulary.nationality = "\(self.nationality)"
            newVocabulary.createdAt = "\(Date())"
            newVocabulary.words = NSSet(array: [])
            
            saveContext()
        }
    }
    
    
    // MARK: saveContext
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct AddVocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        AddVocabularyView()
    }
}
