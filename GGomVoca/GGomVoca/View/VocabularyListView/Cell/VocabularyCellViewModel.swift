//
//  VocabularyCellViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/17.
//

import Foundation
//단어장 셀 뷰모델
class VocabularyCellViewModel{
    var viewContext = PersistenceController.shared.container.viewContext
    /*
     단어장 삭제 후 반영 함수
     */
    func updateDeletedData(id: UUID) {
        let managedContext = viewContext
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
    
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        do {
            let objectUpdate = results[0] // as! NSManagedObject
            objectUpdate.setValue("\(Date())", forKey: "deleatedAt")
            
            /// - 단어장 삭제 시 최근 본 단어장에서도 삭제
            deleteRecentVoca(id: "\(id)")
            
            try self.viewContext.save()
           
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: 최근 본 단어장을 UserDefault에서 삭제
    func deleteRecentVoca(id : String) {
        // [voca1, voca2]
        var before =  UserManager.shared.recentVocabulary
        if let idx = before.firstIndex(of: "\(id)"){
            before.remove(at: idx)
        }
        UserManager.shared.recentVocabulary = before
    }
        
    func saveContext() {
        do {
            print("saveContext")
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    /*
     즐겨찾기 업데이트
     */
    func updateFavoriteVocabulary(id: UUID) {

        let managedContext = viewContext
        let vocabularyFetch = Vocabulary.fetchRequest()
        vocabularyFetch.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        //vocabularyFetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        do {

            let objectUpdate = results[0]
            objectUpdate.setValue(!objectUpdate.isFavorite, forKey: "isFavorite")
            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } 
    }
    
    
}
