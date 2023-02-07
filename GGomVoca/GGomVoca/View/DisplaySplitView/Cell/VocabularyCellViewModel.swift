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
//            deleteRecentVoca(id: "\(id)")
            
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
    
    // MARK: 단어장을 UserDefaults에서 삭제
    func deleteVocaInAppdata(id: String) {
        var pinnedVocabularyIDs = UserDefaults.standard.stringArray(forKey: "pinnedVocabularyIDs")
        var koreanVocabularyIDs = UserDefaults.standard.stringArray(forKey: "koreanVocabularyIDs")
        var englishVocabularyIDs = UserDefaults.standard.stringArray(forKey: "englishVocabularyIDs")
        var japanishVocabularyIDs = UserDefaults.standard.stringArray(forKey: "japanishVocabularyIDs")
        var frenchVocabularyIDs = UserDefaults.standard.stringArray(forKey: "frenchVocabularyIDs")
        
        if ((pinnedVocabularyIDs?.contains(id)) != nil) {
            if let index = pinnedVocabularyIDs?.firstIndex(of: id) {
                pinnedVocabularyIDs?.remove(at: index)
                if pinnedVocabularyIDs?.isEmpty != nil { pinnedVocabularyIDs = nil }
            }
        } else if ((koreanVocabularyIDs?.contains(id)) != nil) {
            if let index = koreanVocabularyIDs?.firstIndex(of: id) {
                koreanVocabularyIDs?.remove(at: index)
                if koreanVocabularyIDs?.isEmpty != nil { koreanVocabularyIDs = nil }
            }
        } else if ((englishVocabularyIDs?.contains(id)) != nil) {
            if let index = englishVocabularyIDs?.firstIndex(of: id) {
                englishVocabularyIDs?.remove(at: index)
                if englishVocabularyIDs?.isEmpty != nil { englishVocabularyIDs = nil }
            }
        } else if ((japanishVocabularyIDs?.contains(id)) != nil) {
            if let index = japanishVocabularyIDs?.firstIndex(of: id) {
                japanishVocabularyIDs?.remove(at: index)
                if japanishVocabularyIDs?.isEmpty != nil { japanishVocabularyIDs = nil }
            }
        } else if ((frenchVocabularyIDs?.contains(id)) != nil) {
            if let index = frenchVocabularyIDs?.firstIndex(of: id) {
                frenchVocabularyIDs?.remove(at: index)
                if frenchVocabularyIDs?.isEmpty != nil { frenchVocabularyIDs = nil }
            }
        }
    }
    
//    // MARK: 최근 본 단어장을 UserDefault에서 삭제
//    func deleteRecentVoca(id : String) {
//        // [voca1, voca2]
//        var before =  UserManager.shared.recentVocabulary
//        if let idx = before.firstIndex(of: "\(id)"){
//            before.remove(at: idx)
//            print("최근본 단어장에서 삭제")
//        }
//        UserManager.shared.recentVocabulary = before
//    }
        
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
            objectUpdate.setValue(!objectUpdate.isPinned, forKey: "isPinned")
            print(objectUpdate)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } 
    }
    
    
}
