//
//  Vocabulary+CKRecord.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/03.
//

import Foundation

import CoreData
import CloudKit

//CoreData Vocabulary Type <-> CloudKit Vocabulary Type
extension Vocabulary {
    static let recordType = "Vocabulary"
    // CKRecord object -> Vocabulary object 변환
    static func from(ckRecord: CKRecord) -> Vocabulary? {
        guard let idString = ckRecord["id"] as? String,
              let id = UUID(uuidString: idString),
              let isPinned = ckRecord["isPinned"] as? Bool,
              let name = ckRecord["name"] as? String,
              let deleatedAt = ckRecord["deleatedAt"] as? String,
              let createdAt = ckRecord["createdAt"] as? String,
              let nationality = ckRecord["nationality"] as? String
                
        else {
            return nil
        }
        
        let vocabulary = Vocabulary(context: PracticePersistence.shared.container.viewContext)
        vocabulary.id = id
        vocabulary.isPinned = isPinned
        vocabulary.name = name
        vocabulary.createdAt = createdAt
        vocabulary.deleatedAt = deleatedAt
        vocabulary.nationality = nationality
        
        return vocabulary
    }
    
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Vocabulary.recordType)
        record["id"] = id?.uuidString
        record["isPinned"] = isPinned
        record["name"] = name
        record["createdAt"] = createdAt
        record["deleatedAt"] = deleatedAt
        record["nationality"] = nationality
        
        return record
    }
}
//test용 바꿀예정
class VocabularyController {
    let database = CKContainer.default().privateCloudDatabase
    
    func saveVocabulary(vocabulary: Vocabulary) {
        let record = vocabulary.ckRecord
        
        database.save(record) { (ckRecord, error) in
            if let error = error {
                print("Error saving vocabulary: \(error.localizedDescription)")
                return
            }
            print("ckRecord : \(ckRecord)")
            PracticePersistence.shared.saveContext()
        }
    }
    
    func fetchVocabulary(withID id: String, completion: @escaping (Vocabulary?) -> Void) {
        let predicate = NSPredicate(format: "id == %@", id)
        let query = CKQuery(recordType: Vocabulary.recordType, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching vocabulary: \(error.localizedDescription)")
                completion(nil)
                return
            }
            print("fetch record : \(records)")
            guard let record = records?.first,
                let vocabulary = Vocabulary.from(ckRecord: record) else {
                    completion(nil)
                    return
            }
            
            completion(vocabulary)
        }
    }
    
    func fetchVocabulary(completion: @escaping (Vocabulary?) -> Void) {
        let predicate =  NSPredicate(value: false)
       
        let query = CKQuery(recordType: Vocabulary.recordType, predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching vocabulary: \(error.localizedDescription)")
                completion(nil)
                return
            }
            print("fetch record : \(records)")
            guard let record = records?.first,
                let vocabulary = Vocabulary.from(ckRecord: record) else {
                    completion(nil)
                    return
            }
            
            completion(vocabulary)
        }
    }
}
