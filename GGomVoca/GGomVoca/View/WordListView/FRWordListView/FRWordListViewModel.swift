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
    
    @Published var words: [Word] = [] {
        didSet {
            print("words changed")
            filteredWords = words.filter { $0.deletedAt == "" || $0.deletedAt == nil }
        }
    }
    
    var filteredWords: [Word] = []
    
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        words = selectedVocabulary.words?.allObjects as? [Word] ?? []
    }
}
