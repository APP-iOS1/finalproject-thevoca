//
//  PracticeAddView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import SwiftUI

struct PracticeAddView: View {
    
    var service : VocabularyService
    
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var isShowingAddVocabulary: Bool
    @State var vocabularyName: String = ""
    @State var nationality: Nationality = Nationality.KO
    @State var isShowingMessage: Bool = false
    
    //@Binding var viewModel : VocabularyListViewModel
    
    var body: some View {
        NavigationStack {
            if isShowingMessage {
                Text("\(Image(systemName: "exclamationmark.circle")) 단어장 이름을 입력해 주세요!")
                    .foregroundColor(.gray)
            }
            
            Form {
                TextField("단어장 이름을 입력하세요", text: $vocabularyName)
                Picker(selection: $nationality, label: Text("언어")) {
                    ForEach(Nationality.allCases, id: \.rawValue) { nationality in
                        Text(nationality.rawValue)
                            .tag(nationality)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("단어장 추가")
            .navigationBarItems(
                leading: Button("취소", action: {
                    isShowingAddVocabulary.toggle()
                }), trailing: Button("추가", action: {
                    if vocabularyName.isEmpty {
                        isShowingMessage = true
                    } else {
                        //TODO: Add 단어장
                        addVocabulary()
                        isShowingAddVocabulary.toggle()
                    }
                }))
        }
    }
    
    /*
     Post 단어장 추가
     */
    private func addVocabulary() { //name: String, nationality: String
        
        service.postVocaData(vocaName: "\(self.vocabularyName)", nationality: "\(self.nationality)")
            .sink(receiveCompletion: {value in
                
                
            }, receiveValue: {value in
                print(value.name)
                print("postVocaData result : \(value)")
                service.saveContext()
            })

    }
    
    
    // MARK: saveContext
    func saveContext() {
        do {
            print("saveContext")
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

struct PracticeAddView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeAddView(service: DependencyManager.shared.resolve(VocabularyService.self)!, isShowingAddVocabulary: .constant(false))
    }
}
