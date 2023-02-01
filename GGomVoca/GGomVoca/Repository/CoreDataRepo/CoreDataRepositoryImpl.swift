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
    let container: NSPersistentCloudKitContainer //NSPersistentContainer에서 변경
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "GGomVoca")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /*
    MARK: 데이터를 디스크에 저장하는 메서드
     */
    func saveContext() {
        let context = container.viewContext
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
    MARK: 단어장 불러오기
     */
    func fetchVocaData() -> AnyPublisher<[Vocabulary], CoredataRepoError> {
        
        return Future<[Vocabulary], CoredataRepoError>{observer in
            let vocabularyFetch = Vocabulary.fetchRequest()

            let results = (try? self.container.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
            
            observer(.success(results))
        }.eraseToAnyPublisher()
        
    }
    /*
    MARK: 단어장 추가하기
     */
    func postVocaData(vocaName : String, nationality: Nationality) -> AnyPublisher<Vocabulary, CoredataRepoError> {
        
        return Future<Vocabulary, CoredataRepoError>{[weak self] observer in
            
            guard let viewContext = self?.container.viewContext else{
                return observer(.failure(CoredataRepoError.notFoundData))
            }
            
            let newVocabulary = Vocabulary(context: viewContext)
            newVocabulary.id = UUID()
            newVocabulary.name = "\(vocaName)" // name
            newVocabulary.nationality = "\(nationality)" //"\(self.nationality)" // nationality
            newVocabulary.createdAt = "\(Date())"
            newVocabulary.words = NSSet(array: [])
            print("newVocabulary \(newVocabulary)")
            observer(.success(newVocabulary))
        }.eraseToAnyPublisher()
        
    }
    
    /*
    MARK: 단어장 좋아요 업데이트하기
     */
    func updateVocaLike(id: UUID) -> AnyPublisher<String, CoredataRepoError> {
        
        return Future<String, CoredataRepoError>{[weak self] observer in
            
            guard let viewContext = self?.container.viewContext else{
                return observer(.failure(CoredataRepoError.notFoundData))
            }
            
            let vocabularyFetch = Vocabulary.fetchRequest()
            vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            let results = (try? viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
            do {
                let objectUpdate = results[0]
                objectUpdate.setValue(!objectUpdate.isFavorite, forKey: "isFavorite")
                print(objectUpdate)
                observer(.success("\(objectUpdate)"))
            }
        }.eraseToAnyPublisher()
       
    }
 
    
    /*
     MARK: 단어장 삭제 후 반영 함수
     */
    func deletedVocaData(id: UUID) -> AnyPublisher<String, CoredataRepoError> {
        return Future<String, CoredataRepoError>{observer in
            observer(.success(""))
            
        }.eraseToAnyPublisher()
    }
    
//    //MARK: 단어장 이름 업데이트
//    func updateVocaName(id : UUID, vocaName : String) -> AnyPublisher<String, CoredataRepoError>{
//
//    }
    
    
}
