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

    @Published var words: [Word] = []
    
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let allWords = selectedVocabulary.words?.allObjects as? [Word] ?? []
        words = allWords.filter { $0.deletedAt == "" || $0.deletedAt == nil }
    }
    
    func deleteWord(word: Word) {
        word.deletedAt = "\(Date())"
        if let tempIndex = words.firstIndex(of: word) {
            words.remove(at: tempIndex)
        }
    }
}
