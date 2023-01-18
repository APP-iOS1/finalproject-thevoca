//
//  FRWordListViewModel.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/18.
//

import Foundation

class FRWordListViewModel: ObservableObject {
    // MARK: CoreData ViewContext
    var viewContext = PersistenceController.shared.container.viewContext
    var coreDataRepository = CoredataRepository()
    
    // MARK: View properties
    var selectedVocabulary: Vocabulary = Vocabulary()
    
    // MARK: 빈 화면 Placeholder 관련 property
    
    
    @Published var words: [Word] = [] {
        didSet {
            print("words changed")
            filteredWords = words.filter { $0.deletedAt == "" || $0.deletedAt == nil }
        }
    }
    
    @Published var filteredWords: [Word] = []
    
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        words = selectedVocabulary.words?.allObjects as? [Word] ?? []
        print("getVocabulary", words, selectedVocabulary)
    }
    
    func getEmptyWord(vocabularyID: Vocabulary.ID) -> String {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let na = selectedVocabulary.nationality ?? "KO"
        print("getEmptyWord", na)
        var emptyMsg: String {
            get {
                switch na {
                case "CH":
                    return "空"
                case "DE":
                    return "Geleert"
                case "EN":
                    return "Empty"
                case "ES":
                    return "Vacío"
                case "FR":
                    return "Vide"
                case "IT":
                    return "Vida"
                case "KO":
                    return "비어있는"
                case "JA":
                    return "空"
                default :
                    return " "
                }
            }
        }
        return emptyMsg
    }

}
