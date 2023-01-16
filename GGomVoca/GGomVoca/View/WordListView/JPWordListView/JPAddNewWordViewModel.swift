//
//  JPAddNewWordViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/16.
//

import Foundation
import SwiftUI

class JPAddNewWordViewModel{
    var viewContext = PersistenceController.shared.container.viewContext
    
    func addNewWord(vocabulary:Vocabulary, word: String, meaning: String, option: String = "") {
        let newWord = Word(context: viewContext)
        newWord.id = UUID()
        newWord.word = word
        newWord.meaning = meaning
        newWord.option = option
        newWord.vocabulary = vocabulary
        newWord.vocabularyID = vocabulary.id
        
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
