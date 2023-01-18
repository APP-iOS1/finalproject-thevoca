//
//  FRAddNewWordViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/16.
//

import Foundation

final class FRAddNewWordViewModel {
    var viewContext = PersistenceController.shared.container.viewContext
    
    // MARK: Add new Word
    func addNewWord(vocabularyID: Vocabulary.ID, word: String, meaning: String, option: String = "") {
        let newWord = Word(context: viewContext)
        newWord.vocabularyID = vocabularyID
        newWord.id = UUID()
        newWord.word = word
        newWord.meaning = meaning
        newWord.option = option
        
        saveContext()
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
