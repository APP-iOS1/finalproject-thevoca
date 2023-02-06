//
//  PracticePersistence.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import Foundation
import CoreData
import CloudKit

struct PracticePersistence {
    static let shared = PracticePersistence()

    
    let container: NSPersistentCloudKitContainer// NSPersistentContainer

    init() {
            container = NSPersistentCloudKitContainer(name: "GGomVoca")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        //NSManagedObjectContext. 스토어의 URL, 유형(예: SQLite), 마이그레이션 또는 버전 관리와 같은 옵션과 같은 스토어 구성 옵션을 제공
        //관리 개체 컨텍스트를 기본 영구 저장소에 연결하는 데 사용
            let description = NSPersistentStoreDescription()
            description.type = NSSQLiteStoreType
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.LikeLion.GGomVoca")
            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true
            
            container.persistentStoreDescriptions = [description]
            container.viewContext.automaticallyMergesChangesFromParent = true
        
        
       
        }
    
    // MARK: 데이터를 디스크에 저장하는 메서드
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
    
    func fetchVocabularyFromCoreData(withID id: String) -> Vocabulary? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest) as! [Vocabulary]
            return result.first
        } catch {
            print("Error fetching vocabulary from Core Data: \(error)")
            return nil
        }
    }
    
    
    func deleteVocabularyFromCoreData(withID id: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Vocabulary")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest) as! [Vocabulary]
            let vocabularyToDelete = result.first
            self.container.viewContext.delete(vocabularyToDelete!)
            try self.container.viewContext.save()
        } catch {
            print("Error deleting vocabulary from Core Data: \(error)")
        }
    }
    
    
    
    func refrechContext() {
        let context = container.viewContext
        context.refreshAllObjects()
    }
}


