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
    
    func syncVocaData() -> AnyPublisher<[Vocabulary], FirstPartyRepoError> {
        let predicate =  NSPredicate(value: false)
        let query = CKQuery(recordType: Vocabulary.recordType, predicate: predicate)
        
        var vocaList = [Vocabulary]()
        return Future<[Vocabulary], FirstPartyRepoError>{[weak self]observer in
            self?.database.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error fetching vocabulary: \(error.localizedDescription)")
                    observer(.failure(FirstPartyRepoError.notFoundDataFromCloudKit))
                    return
                }
                print("fetch record : \(String(describing: records))")
                
                //MARK:  Cloud와 CoreData에서 fetch한 각 Vocabulary의 버전 체크
                records?.forEach{ record in
                    let cloudVocaId = record["id"] as? String
                    let cloudVocaUpdatedAt = record.modificationDate
                    
                    if let coreDataVocabulary = PracticePersistence.shared.fetchVocabularyFromCoreData(withID: cloudVocaId ?? ""){
                        //MARK: Coredata가 최신인 경우.
                        if coreDataVocabulary.updatedAt ?? "" > "\(String(describing: cloudVocaUpdatedAt))"{
                            vocaList.append(coreDataVocabulary)
                        }else{
                            //MARK: Cloud가 최신인 경우
                            //기존 Voca 제거
                            PracticePersistence.shared.deleteVocabularyFromCoreData(withID: cloudVocaId ?? "")
                            PracticePersistence.shared.saveContext()
                            //Cloud 버전으로 New Vocabulary 생성
                            if let cloudVocabulary = Vocabulary.from(ckRecord: record){
                                vocaList.append(cloudVocabulary)
                            }
                        }
                        
                    }else{
                        //MARK: Coredata는 없고 Cloud만 존재하는 경우
                        //Cloud 버전으로 New Vocabulary 생성
                        if let cloudVocabulary = Vocabulary.from(ckRecord: record){
                            vocaList.append(cloudVocabulary)
                        }
                    }
                }
                
                PracticePersistence.shared.saveContext()
                observer(.success(vocaList))
            }
            
        }.eraseToAnyPublisher()
        
    }
    //MARK: Post New Voca CloudKit
    func postVocaData(vocabulary: Vocabulary) -> AnyPublisher<Vocabulary, FirstPartyRepoError> {
        let record = vocabulary.ckRecord
        return Future<Vocabulary, FirstPartyRepoError>{[weak self]observer in
            self?.database.save(record){(CKRecord, error) in
                if let error = error{
                    print("ERROR save Vocabulary : \(error.localizedDescription)")
                    observer(.failure(FirstPartyRepoError.notFoundDataFromCloudKit))
                    return
                }
                print("ckRecord: \(String(describing: CKRecord))")
                PracticePersistence.shared.saveContext()
                observer(.success(vocabulary))
            }
        }.eraseToAnyPublisher()
        
    }
    
    func updateVocaData(vocabulary: Vocabulary) -> AnyPublisher<String, FirstPartyRepoError> {
        //동일한 레코드 가 데이터베이스에 이미 존재하는 경우 기존 레코드가 새 데이터로 업데이트됩니다.
        //레코드가 없으면 새 레코드가 생성됩니다.
        let record = vocabulary.ckRecord
        return Future<String, FirstPartyRepoError>{[weak self]observer in
            self?.database.save(record){(CKRecord, error) in
                if let error = error{
                    print("ERROR save Vocabulary : \(error.localizedDescription)")
                    observer(.failure(FirstPartyRepoError.notFoundDataFromCloudKit))
                    return
                }
                print("ckRecord: \(String(describing: CKRecord))")
                PracticePersistence.shared.saveContext()
                observer(.success("Cloud update complete"))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteVocaData(record: CKRecord) -> AnyPublisher<String, FirstPartyRepoError> {
      
        return Future<String, FirstPartyRepoError>{[weak self] observer in
            self?.database.delete(withRecordID: record.recordID) { (recordID, error) -> Void in
                guard let _ = error else {
                    print("ERROR delete Vocabulary : \(String(describing: error?.localizedDescription))")
                    observer(.failure(FirstPartyRepoError.notFoundDataFromCloudKit))
                  return
                }
                
                observer(.success("Cloud 데이터 삭제 완료"))
              }
            
        }.eraseToAnyPublisher()
         
    }
    
    
   
    
  
}
