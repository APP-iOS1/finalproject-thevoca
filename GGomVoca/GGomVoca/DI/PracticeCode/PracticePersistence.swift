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
    
    func refrechContext() {
        let context = container.viewContext
        context.refreshAllObjects()
    }
}


