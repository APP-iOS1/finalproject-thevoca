//
//  CloudKitRepositoryImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import CloudKit
import Combine
class CloudKitRepositoryImpl : CloudKitRepository {

    //기본 싱글톤 인스턴스를 통해 얻은 private Cloud 데이터베이스 컨테이너
    let database = CKContainer.default().privateCloudDatabase
    //MARK:  VocaList Cloud와 Coredata 동기화
    func syncVocaData() -> AnyPublisher<[Vocabulary], RepositoryError> {
        let predicate =  NSPredicate(value: true)
        //let query = CKQuery(recordType: Vocabulary.recordType, predicate: predicate)
        let query = CKQuery(recordType: "Vocabulary", predicate: predicate)
        var vocaList = [Vocabulary]()
        return Future<[Vocabulary], RepositoryError>{[weak self]observer in
            self?.database.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error fetching vocabulary: \(error.localizedDescription)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                    return
                }
                
                //MARK:  Cloud와 CoreData에서 fetch한 각 Vocabulary의 버전 체크
                records?.forEach{ record in
                    let cloudVocaId = record["id"] as? String
                    let cloudVocaUpdatedAt = record.modificationDate
                    
                    if let coreDataVocabulary = PersistenceController.shared.fetchVocabularyFromCoreData(withID: cloudVocaId ?? ""){
                        //MARK: Coredata가 최신인 경우.
                        if coreDataVocabulary.updatedAt ?? "" > "\(cloudVocaUpdatedAt!)"{
                            vocaList.append(coreDataVocabulary)
                            print("CoreData가 최신 \(coreDataVocabulary)")
                        }else if coreDataVocabulary.updatedAt ?? "" < "\(cloudVocaUpdatedAt!)"{
                            //MARK: Cloud가 최신인 경우
                            //기존 Voca 제거
                          
                            PersistenceController.shared.deleteVocabularyFromCoreData(withID: cloudVocaId ?? "")
                            PersistenceController.shared.saveContext()
                            //Cloud 버전으로 New Vocabulary 생성
                            if let cloudVocabulary = Vocabulary.from(ckRecord: record){
                                vocaList.append(cloudVocabulary)
                            }
                        }
                        
                    }else{
                        //MARK: Coredata는 없고 Cloud만 존재하는 경우
                        //Cloud 버전으로 New Vocabulary 생성
                        
                        if let cloudVocabulary = Vocabulary.from(ckRecord: record){
                            print("Cloud만 존재 \(cloudVocabulary)")
                          
                            vocaList.append(cloudVocabulary)
                        }
                    }
                }
                
                PersistenceController.shared.saveContext()
                observer(.success(vocaList))
            }
            
        }.eraseToAnyPublisher()
        
    }
    
    //MARK:  WordList Cloud와 Coredata 동기화
    func syncVocaData(voca : Vocabulary) -> AnyPublisher<[Word], RepositoryError> {
        let query = CKQuery(recordType: "Word", predicate: NSPredicate(format: "recordID == %@", voca.ckRecord.recordID))
        return Future<[Word], RepositoryError>{[weak self] observer in
            self?.database.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error retrieving word record: \(error)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                } else if let records = records, records.count > 0 {
                    let wordRecord = records[0]
                    let name = wordRecord["name"] as? String
                    let definition = wordRecord["definition"] as? String
                   
                    print("Word: \(name ?? ""), Definition: \(definition ?? "")")
                } else {
                    print("No records found")
                }
                observer(.success([Word]()))
            }
            
        }.eraseToAnyPublisher()
    }
    
    
    
    //MARK: Post New Voca CloudKit
    func postVocaData(vocabulary: Vocabulary) -> AnyPublisher<Vocabulary, RepositoryError> {
        let record = vocabulary.ckRecord
        return Future<Vocabulary, RepositoryError>{[weak self]observer in
            self?.database.save(record){(CKRecord, error) in
                if let error = error{
                    print("ERROR save Vocabulary : \(error.localizedDescription)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                    return
                }
                print("ckRecord: \(String(describing: CKRecord))")
                PersistenceController.shared.saveContext()
                observer(.success(vocabulary))
            }
        }.eraseToAnyPublisher()
        
    }
    
    //MARK: Post New Word CloudKit
    func postWordData(word : Word,vocabulary: Vocabulary) -> AnyPublisher<Vocabulary, RepositoryError> {
        let vocaRecord = vocabulary.ckRecord
        let wordRecord = word.ckRecord(vocaOfWord: vocabulary)
        
        return Future<Vocabulary, RepositoryError>{[weak self]observer in
            let saveOperation = CKModifyRecordsOperation(recordsToSave: [vocaRecord, wordRecord], recordIDsToDelete: nil)
            //handle the results of the operation. It provides the saved records, deleted records (if any), and any error that might have occurred.
            saveOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                if let error = error {
                    print("Error saving records: \(error)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                } else {
                    print("Records saved successfully")
                    // records to the CloudKit
                    self?.database.add(saveOperation)
                    observer(.success(vocabulary))
                }
            }
         
           
        }.eraseToAnyPublisher()
        
    }
    
    //MARK: Update New Word CloudKit
    func updateVocaData(vocabulary: Vocabulary) -> AnyPublisher<String, RepositoryError> {
        //동일한 레코드 가 데이터베이스에 이미 존재하는 경우 기존 레코드가 새 데이터로 업데이트됩니다.
        //레코드가 없으면 새 레코드가 생성됩니다.
        let record = vocabulary.ckRecord
        return Future<String, RepositoryError>{[weak self]observer in
            self?.database.save(record){(CKRecord, error) in
                if let error = error{
                    print("ERROR save Vocabulary : \(error.localizedDescription)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                    return
                }
                print("ckRecord: \(String(describing: CKRecord))")
                PersistenceController.shared.saveContext()
                observer(.success("Cloud update complete"))
            }
        }.eraseToAnyPublisher()
    }
    
    //코어데이터에 저장 후 실행
    //MARK: Update Word CloudKit
    func updateWordData(word : Word,vocabulary: Vocabulary) -> AnyPublisher<Vocabulary, RepositoryError> {
        let vocaRecord = vocabulary.ckRecord
        let wordRecord = word.ckRecord(vocaOfWord: vocabulary)
        
        return Future<Vocabulary, RepositoryError>{[weak self]observer in
            let saveOperation = CKModifyRecordsOperation(recordsToSave: [vocaRecord, wordRecord], recordIDsToDelete: nil)
            //handle the results of the operation. It provides the saved records, deleted records (if any), and any error that might have occurred.
            saveOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                if let error = error {
                    print("Error saving records: \(error)")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                } else {
                    print("Records saved successfully")
                    // records to the CloudKit
                    self?.database.add(saveOperation)
                    observer(.success(vocabulary))
                }
            }
         
           
        }.eraseToAnyPublisher()
        
    }
    
    
    
    func deleteVocaData(record: CKRecord) -> AnyPublisher<String, RepositoryError> {
      
        return Future<String, RepositoryError>{[weak self] observer in
            self?.database.delete(withRecordID: record.recordID) { (recordID, error) -> Void in
                guard let _ = error else {
                    print("ERROR delete Vocabulary : \(String(describing: error?.localizedDescription))")
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                  return
                }
                
                observer(.success("Cloud 데이터 삭제 완료"))
              }
            
        }.eraseToAnyPublisher()
         
    }
    
    //MARK: delete Word CloudKit
    func deleteWordData(word : Word,vocabulary: Vocabulary) -> AnyPublisher<String, RepositoryError> {
        _ = vocabulary.ckRecord
        let wordRecord = word.ckRecord(vocaOfWord: vocabulary)
        
        return Future<String, RepositoryError>{[weak self]observer in
            
            self?.database.delete(withRecordID: wordRecord.recordID){ (recordID, error) in
                guard let _ = error else {
                     
                    observer(.failure(RepositoryError.cloudRepositoryError(error: .failPostWordFromCloudKit)))
                      return
                    }
                observer(.success("Cloud에서 삭제되었습니다."))
            
            }
        }.eraseToAnyPublisher()
         
    }
    
   
    
  
}
