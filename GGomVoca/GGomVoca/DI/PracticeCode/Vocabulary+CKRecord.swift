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
              let nationality = ckRecord["nationality"] as? String,
              let updatedAt = ckRecord["updatedAt"] as? String
                
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
        vocabulary.updatedAt = updatedAt
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
        record["updatedAt"] = updatedAt
        return record
    }
}
// 클라우드 데이터베이스(CloudKit 프레임워크 사용)에서 저장 및 가져오기를 처리 하는 클래스
//class VocabularyController {
//    //기본 싱글톤 인스턴스를 통해 얻은 private Cloud 데이터베이스 컨테이너
//    let database = CKContainer.default().privateCloudDatabase
//    
//    //MARK: Save New Vocabulary From Cloud Database
//    func saveVocabulary(vocabulary: Vocabulary) {
//        let record = vocabulary.ckRecord
//        
//        database.save(record) { (ckRecord, error) in
//            if let error = error {
//                print("Error saving vocabulary: \(error.localizedDescription)")
//                return
//            }
//            print("ckRecord : \(ckRecord)")
//            PracticePersistence.shared.saveContext()
//        }
//    }
//    
//    
//    //MARK: Fetch Vocabulary from Cloud Database
//    func fetchVocabulary(completion: @escaping ([Vocabulary]?) -> Void) {
//        let predicate =  NSPredicate(value: false)
//        let query = CKQuery(recordType: Vocabulary.recordType, predicate: predicate)
//        
//        var vocaList = [Vocabulary]()
//        
//        database.perform(query, inZoneWith: nil) { (records, error) in
//            if let error = error {
//                print("Error fetching vocabulary: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            print("fetch record : \(String(describing: records))")
//     
//            
//            //MARK:  Cloud와 CoreData에서 fetch한 각 Vocabulary의 버전 체크
//            records?.forEach{ record in
//                let cloudVocaId = record["id"] as? String
//                let cloudVocaUpdatedAt = record.modificationDate
//                
//                if let coreDataVocabulary = PracticePersistence.shared.fetchVocabularyFromCoreData(withID: cloudVocaId ?? ""){
//                    //MARK: Coredata가 최신인 경우.
//                    if coreDataVocabulary.updatedAt ?? "" > "\(String(describing: cloudVocaUpdatedAt))"{
//                        vocaList.append(coreDataVocabulary)
//                    }else{
//                        //MARK: Cloud가 최신인 경우
//                        //기존 Voca 제거
//                        PracticePersistence.shared.deleteVocabularyFromCoreData(withID: cloudVocaId ?? "")
//                        PracticePersistence.shared.saveContext()
//                        //Cloud 버전으로 New Vocabulary 생성
//                        if let cloudVocabulary = Vocabulary.from(ckRecord: record){
//                            vocaList.append(cloudVocabulary)
//                        }
//                    }
//                    
//                }else{
//                    //MARK: Coredata는 없고 Cloud만 존재하는 경우
//                    //Cloud 버전으로 New Vocabulary 생성
//                    if let cloudVocabulary = Vocabulary.from(ckRecord: record){
//                        vocaList.append(cloudVocabulary)
//                    }
//                }
//            }
//            
//            PracticePersistence.shared.saveContext()
//            completion(vocaList)
//        }
//    }
//}
