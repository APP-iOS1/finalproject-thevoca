//
//  EditWordViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/16.
//

import Foundation

class EditWordViewModel {
    var viewContext = PersistenceController.shared.container.viewContext
    
    func editWord(editWord: Word, word: String, meaning: String, option: String = "") {
        editWord.word = word
        editWord.meaning = meaning
        editWord.option = option
        
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
