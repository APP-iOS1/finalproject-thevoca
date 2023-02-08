//
//  Word+CKRecord.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/06.
//

import Foundation
import CoreData
import CloudKit
//CoreData Word Type <-> CloudKit Word Type
extension Word{
    static let recordType = "Word"
    
    // CKRecord object -> Vocabulary object 변환
    static func from(ckRecord: CKRecord) -> Word? {
        guard let idString = ckRecord["id"] as? String,
              let id = UUID(uuidString: idString),
              let correctCount = ckRecord["correctCount"] as? Int,
              let incorrectCount = ckRecord["incorrectCount"] as? Int,
              let isMemorized = ckRecord["isMemorized"] as? Bool,
              let meaning = ckRecord["meaning"] as? [String],
              let option = ckRecord["option"] as? String,
              let recentTestResults = ckRecord["recentTestResults"] as? [String],
              let createdAt = ckRecord["createdAt"] as? String,
              let vocabularyIDStr = ckRecord["vocabularyID"] as? String,
              let vocabularyID = UUID(uuidString: vocabularyIDStr),
              let word = ckRecord["word"] as? String
             // let updatedAt = ckRecord["updatedAt"] as? String
                
        else {
            print("from result : \(ckRecord) = fail")
            return nil
        }
        print("from result : \(ckRecord) = success")
        let newWord = Word(context: PersistenceController.shared.container.viewContext)
        newWord.id = id
        newWord.correctCount = Int16(correctCount)
        newWord.incorrectCount = Int16(incorrectCount)
        newWord.isMemorized = isMemorized
        newWord.meaning = meaning
        newWord.option = option
        newWord.recentTestResults = recentTestResults
        newWord.vocabularyID = vocabularyID
        newWord.word = word
        newWord.createdAt = createdAt
        //newWord.updatedAt = updatedAt
        //word.deleatedAt = deleatedAt
        return newWord
    }
    
   
    
    func ckRecord(vocaOfWord : Vocabulary) -> CKRecord{
        
        let record = CKRecord(recordType: Word.recordType)
        record["id"] = id?.uuidString ?? ""
        record["correctCount"] = correctCount
        record["incorrectCount"] = incorrectCount
        record["isMemorized"] = isMemorized
        record["meaning"] = meaning
        record["option"] = option
        record["recentTestResults"] = recentTestResults
        record["createdAt"] = createdAt
        record["vocabularyID"] = vocabularyID?.uuidString
        record["word"] = word
        // Add a reference to the associated vocabulary
        let vocabularyRecordID = CKRecord.ID(recordName: vocaOfWord.id?.uuidString ?? "")
        record["vocabulary"] = CKRecord.Reference(recordID: vocabularyRecordID, action: .deleteSelf)

        return record
    }
    
}
