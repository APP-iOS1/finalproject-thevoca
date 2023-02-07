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
    
    // MARK: UserDefaults
    @AppStorage("koreanVocabularyIDs")   var koreanVocabularyIDs  : [String]?
    @AppStorage("englishVocabularyIDs")  var englishVocabularyIDs : [String]?
    @AppStorage("japanishVocabularyIDs") var japanishVocabularyIDs: [String]?
    @AppStorage("frenchVocabularyIDs")   var frenchVocabularyIDs  : [String]?
    
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
            
            switch newVocabulary.nationality {
            case "KO":
                print("추가 시작")
                if var koreanVocabularyIDs {
                    koreanVocabularyIDs.append(newVocabulary.id?.uuidString ?? "")
                } else {
                    koreanVocabularyIDs = [newVocabulary.id?.uuidString ?? ""]
                }
            case "EN":
                if var englishVocabularyIDs {
                    englishVocabularyIDs.append(newVocabulary.id?.uuidString ?? "")
                } else {
                    englishVocabularyIDs = [newVocabulary.id?.uuidString ?? ""]
                }
            case "JA":
                if var japanishVocabularyIDs {
                    japanishVocabularyIDs.append(newVocabulary.id?.uuidString ?? "")
                } else {
                    japanishVocabularyIDs = [newVocabulary.id?.uuidString ?? ""]
                }
            case "FR":
                if var frenchVocabularyIDs {
                    frenchVocabularyIDs.append(newVocabulary.id?.uuidString ?? "")
                } else {
                    frenchVocabularyIDs = [newVocabulary.id?.uuidString ?? ""]
                }
            default:
                break
            }
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
