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
    
    // Define the record types in CloudKit
    static let recordType = "Vocabulary"
    // CKRecord object -> Vocabulary object 변환
    static func from(ckRecord: CKRecord) -> Vocabulary? {
        guard let idString = ckRecord["id"] as? String,
              let id = UUID(uuidString: idString),
              let isPinned = ckRecord["isPinned"] as? Bool,
              let name = ckRecord["name"] as? String,
              //let deleatedAt = ckRecord["deleatedAt"] as? String,
              let createdAt = ckRecord["createdAt"] as? String,
              let nationality = ckRecord["nationality"] as? String,
              let updatedAt = ckRecord["updatedAt"] as? String
                
        else {
            print("from result : \(ckRecord) = fail")
            return nil
        }
        print("from result : \(ckRecord) = success")
        let vocabulary = Vocabulary(context: PersistenceController.shared.container.viewContext)
        vocabulary.id = id
        vocabulary.isPinned = isPinned
        vocabulary.name = name
        vocabulary.createdAt = createdAt
        //vocabulary.deleatedAt = deleatedAt
        vocabulary.nationality = nationality
        vocabulary.updatedAt = updatedAt
        return vocabulary
    }
    
    
    // Define a word record
    var ckRecord: CKRecord {
        let record = CKRecord(recordType: Vocabulary.recordType)
        record["id"] = id?.uuidString ?? ""
        record["isPinned"] = isPinned
        record["name"] = name
        record["createdAt"] = createdAt
        record["deleatedAt"] = deleatedAt
        record["nationality"] = nationality
        record["updatedAt"] = updatedAt
        return record
    }
}
