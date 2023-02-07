//
//  CloudKitRepository.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine
import CoreData
import CloudKit


protocol CloudKitRepository {
    //MARK: CloudKit으로부터 Voca 동기화
    func syncVocaData() -> AnyPublisher<[Vocabulary], FirstPartyRepoError>
    
    
    
    //MARK: Post New Voca CloudKit
    func postVocaData(vocabulary: Vocabulary) -> AnyPublisher<Vocabulary, FirstPartyRepoError>
    //MARK: Update Voca  CloudKit
    func updateVocaData(vocabulary: Vocabulary) -> AnyPublisher<String, FirstPartyRepoError>
    //MARK: Delete Voca CloudKit
    func deleteVocaData(record: CKRecord) -> AnyPublisher<String, FirstPartyRepoError>
}
