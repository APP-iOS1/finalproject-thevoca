//
//  CoredataRepositoryImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine
import CoreData
class CoreDataRepositoryImpl : CoreDataRepository {
   

    // CloudKit database와 동기화하기 위해서는 NSPersistentCloudKitContainer로 변경
    
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    
    /*
    MARK: 데이터를 디스크에 저장하는 메서드
     */
    func saveContext() {
        let context = context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    /*
    MARK: 단어장 리스트 불러오기
     */
    func fetchVocaListData() -> AnyPublisher<[Vocabulary], RepositoryError> {
        return Future<[Vocabulary], RepositoryError>{observer in
            let vocabularyFetch = Vocabulary.fetchRequest()
            
            do {
                let results = (try self.context.fetch(vocabularyFetch) as [Vocabulary])
                observer(.success(results))
            }catch{
                observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
        }.eraseToAnyPublisher()
        
    }
    
    /*
    MARK: 단어장 id로 불러오기
     */
    
    func getVocabularyFromID(vocabularyID: UUID) -> AnyPublisher<Vocabulary, RepositoryError>{
        return Future<Vocabulary, RepositoryError>{observer in
            let vocabularyFetch = Vocabulary.fetchRequest()
            vocabularyFetch.predicate = NSPredicate(format: "id == %@", vocabularyID as CVarArg)
            
            do {
                let results = (try self.context.fetch(vocabularyFetch) as [Vocabulary])
                let voca = results.first ?? Vocabulary()
                observer(.success(voca))
            }catch{
                print("\(error)")
                observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
            
        }.eraseToAnyPublisher()
        
    }
    
    //MARK: 단어리스트 불러오기
    func getWordListFromVoca(voca: Vocabulary) -> AnyPublisher<[Word], RepositoryError> {
        return Future<[Word], RepositoryError>{observer in
            var words = [Word]()
            let allWords = voca.words?.allObjects as? [Word] ?? []
            words = allWords.filter { $0.deletedAt == "" || $0.deletedAt == nil }
            observer(.success(words))
        }.eraseToAnyPublisher()
        
    }
    
    
    /*
     MARK: 단어장 추가하기
     */
    func postVocaData(vocaName : String, nationality: String) -> AnyPublisher<Vocabulary, RepositoryError> {
      
        return Future<Vocabulary, RepositoryError>{[weak self] observer in
            
            guard let viewContext = self?.context else{
                return observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
            
            let newVocabulary = Vocabulary(context: viewContext)
            newVocabulary.id = UUID()
            newVocabulary.name = "\(vocaName)" // name
            newVocabulary.nationality = "\(nationality)" //"\(self.nationality)" // nationality
            newVocabulary.createdAt = "\(Date())"
            newVocabulary.words = NSSet(array: [])
            newVocabulary.updatedAt = "\(Date())"
            print("newVocabulary \(newVocabulary)")
//            self?.saveContext()
           
            observer(.success(newVocabulary))
        }.eraseToAnyPublisher()
        
    }
    
    // MARK: 단어 추가하기
    func addNewWord(word: String, meaning: [String], option: String, voca: Vocabulary) -> AnyPublisher<Word, RepositoryError> {
        return Future<Word, RepositoryError>{[weak self] observer in
            guard let viewContext = self?.context else{
                return  observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
            let newWord = Word(context: viewContext)
            newWord.vocabularyID = voca.id
            newWord.vocabulary = voca
            newWord.id = UUID()
            newWord.word = word
            newWord.meaning = meaning
            newWord.option = option

            self?.saveContext()
            observer(.success(newWord))
        }.eraseToAnyPublisher()
    }
    
   
    
    /*
    MARK: 단어장 고정 상태 업데이트하기
     */
    func updatePinnedVoca(id: UUID) -> AnyPublisher<String, RepositoryError> {
        
        return Future<String, RepositoryError>{[weak self] observer in
            
            guard let viewContext = self?.context else{
                return  observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
            
            let vocabularyFetch = Vocabulary.fetchRequest()
            vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            let results = (try? viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
            do {
                let objectUpdate = results[0]
                objectUpdate.setValue(!objectUpdate.isPinned, forKey: "isPinned")
                print(objectUpdate)
                observer(.success("\(objectUpdate)"))
            }
        }.eraseToAnyPublisher()
       
    }
    //MARK: 단어 수정하기
    func updateWord(editWord: Word, word: String, meaning: [String], option: String) -> AnyPublisher<Word, RepositoryError> {
        return Future<Word, RepositoryError>{[weak self] observer in
            editWord.word = word
            editWord.meaning = meaning
            editWord.option = option

            self?.saveContext()
            observer(.success(editWord))
        }.eraseToAnyPublisher()
    }
    
 
    
    /*
     MARK: 단어장 삭제 후 반영 함수
     */
    func deletedVocaData(id: UUID) -> AnyPublisher<String, RepositoryError> {
        return Future<String, RepositoryError>{observer in
            /// - 단어장 id로 단어장 객체 찾아오기
            let vocabularyFetch = Vocabulary.fetchRequest()
            vocabularyFetch.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = (try self.context.fetch(vocabularyFetch) as [Vocabulary])
                let voca = results.first ?? Vocabulary()
                voca.deleatedAt = "\(Date())"
            }catch{
                print("\(error)")
                observer(.failure(RepositoryError.coreDataRepositoryError(error: .notFoundDataFromCoreData)))
            }
            
            observer(.success(""))
            
        }.eraseToAnyPublisher()
    }
    
    //MARK: 단어 삭제
    func deleteWord(word: Word) -> AnyPublisher<String, RepositoryError> {
        return Future<String, RepositoryError>{[weak self] observer in
            
            word.deletedAt = "\(Date())"

            self?.saveContext()
            observer(.success("로컬DB 단어 삭제 성공"))
        }.eraseToAnyPublisher()
       

    }
   

    
    
//    //MARK: 단어장 이름 업데이트
//    func updateVocaName(id : UUID, vocaName : String) -> AnyPublisher<String, CoredataRepoError>{
//
//    }
    
    
}
