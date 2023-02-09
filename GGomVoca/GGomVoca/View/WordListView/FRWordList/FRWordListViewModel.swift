//
//  FRFRWordListViewModel.swift
//  GGomVoca
//
//  Created by Roen White on 2023/01/25.
//

import Foundation
import Combine
class FRFRWordListViewModel: ObservableObject {
    // MARK: CoreData ViewContext
    var viewContext = PersistenceController.shared.container.viewContext
    var coreDataRepository = CoredataRepository()
    
    // MARK: Vocabulary Properties
    var selectedVocabulary: Vocabulary = Vocabulary()
    var nationality: String = "FR"

    //MARK: Service
    var service : WordListService
    private var bag : Set<AnyCancellable> = Set<AnyCancellable>()
    
    init( service: WordListService) {
        self.service = service
    }
    
    @Published var words: [Word] = []
    
    // MARK: saveContext
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: 일치하는 id의 단어장 불러오기
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let allWords = selectedVocabulary.words?.allObjects as? [Word] ?? []
        words = allWords.filter { $0.deletedAt == "" || $0.deletedAt == nil }
    }
    
    // MARK: 단어 삭제하기
    func deleteWord(word: Word) {
        word.deletedAt = "\(Date())"
        
        saveContext()
        
        if let tempIndex = words.firstIndex(of: word) {
            words.remove(at: tempIndex)
        }
    }
    
    // MARK: 단어 수정하기
    func updateWord(editWord: Word, word: String, meaning: [String], option: String = "") {
        guard let tempIndex = words.firstIndex(of: editWord) else { return }

        editWord.word = word
        editWord.meaning = meaning
        editWord.option = option
        
        saveContext()

        words[tempIndex] = editWord
    }
    
    // MARK: 단어 추가하기
    func addNewWord(word: String, meaning: [String], option: String = "") {
        let newWord = Word(context: viewContext)
        newWord.vocabularyID = selectedVocabulary.id
        newWord.vocabulary = selectedVocabulary
        newWord.id = UUID()
        newWord.word = word
        newWord.meaning = meaning
        newWord.option = option
        
        saveContext()
        
        words.append(newWord)
    }
    
    // MARK: 단어장의 word 배열이 비어있을 때 나타낼 Empty 메세지의 다국어 처리
    // TODO: Vocabulary 구조체 자체의 property로 넣을 수 없을지?
    func getEmptyWord() -> String {
        var emptyMsg: String {
            switch nationality {
            case "KO":
                return "비어 있는"
            case "EN":
                return "Empty"
            case "JA":
                return "空っぽの"
            case "FR":
                return "Vide"
            case "CH":
                return "空"
            case "DE":
                return "Geleert"
            case "ES":
                return "Vacío"
            case "IT":
                return "Vida"
            default :
                return " "
            }
        }
        return emptyMsg
    }

  // MARK: Build Data For CSV
  func buildDataForCSV() -> String? {
    var fullText = "word,option,meaning\n"

    for word in words {
      var aLine = ""
      var tmpMeaning = word.meaning!.joined(separator: ",")
      tmpMeaning = tmpMeaning.multiCheck ? tmpMeaning.reformForCSV : tmpMeaning
      if word.deletedAt == nil {
        aLine = "\(String(describing: word.word ?? "")),\(String(describing: word.option ?? "")),\(tmpMeaning)"
        fullText += aLine + "\n"
      }
    }
    return fullText
  }

}
