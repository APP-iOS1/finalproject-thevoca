//
//  PracticePersistence.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import CoreData

struct PracticePersistence {
    static let shared = PracticePersistence()

    static var preview: PracticePersistence = {
        let result = PracticePersistence(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newVocabulary = Vocabulary(context: viewContext)
            newVocabulary.createdAt = "\(Date())"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer// NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "GGomVoca")
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
        
        let localStoreLocation = URL(fileURLWithPath: "/path/to/local.store")
        let localStoreDescription = NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration = "Local"
        
        let cloudStoreLocation = URL(fileURLWithPath: "/path/to/cloud.store")
        let cloudStoreDescription = NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Cloud"
        
        cloudStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier : "com.my.container")
        
        container.persistentStoreDescriptions = [
        
            cloudStoreDescription,
            localStoreDescription
        ]
        
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
    
    func refrechContext() {
        let context = container.viewContext
        context.refreshAllObjects()
    }
}


