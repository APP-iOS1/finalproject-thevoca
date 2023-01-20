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
    
    // MARK: 일치하는 id의 단어장 불러오기
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let allWords = selectedVocabulary.words?.allObjects as? [Word] ?? []
        words = allWords.filter { $0.deletedAt == "" || $0.deletedAt == nil }
    }
    
    // MARK: 단어 삭제하기
    func deleteWord(word: Word) {
        word.deletedAt = "\(Date())"
        if let tempIndex = words.firstIndex(of: word) {
            words.remove(at: tempIndex)
        }
    }
    
    // MARK: 단어 수정하기
    func updateWord(editWord: Word, word: String, meaning: String, option: String = "") {
        guard let tempIndex = words.firstIndex(of: editWord) else { return }

        editWord.word = word
        editWord.meaning = meaning
        editWord.option = option
        
        saveContext()
        
        words[tempIndex] = editWord
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
