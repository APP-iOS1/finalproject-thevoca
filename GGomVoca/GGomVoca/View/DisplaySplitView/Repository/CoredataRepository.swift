//
//  CoredataRepository.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import Foundation
import CoreData
import SwiftUI
//삭제 예정 (구 Repository)
struct CoredataRepository{
    static var shared = CoredataRepository()
    
    let persistenceController : PersistenceController
    let viewContext : NSManagedObjectContext
    //@Environment(\.managedObjectContext) private var viewContext  Environment 래퍼 프로퍼티 정의 다시 공부하기(여기서 사용하면 안 됨)
    
    init(){
        persistenceController = PersistenceController.shared
        viewContext = persistenceController.container.viewContext
    }
    /*
     Get Vocabulary List
     */
    func getVocabularyData()
    -> [Vocabulary] {
        let vocabularyFetch = Vocabulary.fetchRequest()
//        vocabularyFetch.predicate = NSPredicate(format: "title CONTAINS[c] %@",searchingFor)
        //vocabularyFetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
       
        return results
    }
    
    func getVocabularyFromID(vocabularyID: UUID) -> Vocabulary {
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id == %@", vocabularyID as CVarArg)
        
        let result = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        return result.first ?? Vocabulary()
    }
}
