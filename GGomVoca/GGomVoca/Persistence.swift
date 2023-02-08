//
//  Persistence.swift
//  GGomVoca
//
//  Created by Roen White on 2022/12/19.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

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
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newVocabulary = Vocabulary(context: viewContext)
//            newVocabulary.createdAt = "\(Date())"
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "GGomVoca")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//
//    // MARK: 데이터를 디스크에 저장하는 메서드
//    func saveContext() {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
//    func refrechContext() {
//        let context = container.viewContext
//        context.refreshAllObjects()
//    }
}
