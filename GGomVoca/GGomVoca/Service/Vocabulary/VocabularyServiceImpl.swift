//
//  VocabularyServiceImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine

class VocabularyServiceImpl: VocabularyService{
    //Repository
    var coreDataRepo : CoreDataRepository
    var cloudDataRepo : CloudKitRepository
    
    init(coreDataRepo : CoreDataRepository, cloudDataRepo : CloudKitRepository ){
        self.coreDataRepo = coreDataRepo
        self.cloudDataRepo = cloudDataRepo
    }
    //MARK: 데이터를 디스크에 저장
    func saveContext() {
        coreDataRepo.saveContext()
    }
    
    
    //MARK: 단어장 리스트 불러오기
    func fetchVocabularyList() -> AnyPublisher<[Vocabulary], FirstPartyRepoError> {
        var cloudControlloer =  VocabularyController() //test
        
        cloudControlloer.fetchVocabulary(completion: {voca in
            
        })
        return coreDataRepo.fetchVocaData()
        
    }
    
    //MARK: 단어장 추가하기
    func postVocaData(vocaName: String, nationality: String) -> AnyPublisher<Vocabulary, FirstPartyRepoError> {
        return coreDataRepo.postVocaData(vocaName: vocaName, nationality: nationality)
    }
    //MARK: 단어장 고정 상태 업데이트
    //TODO: Publisher 반환타입 수정
    func updatePinnedVoca(id: UUID) -> AnyPublisher<String, FirstPartyRepoError> {
        return coreDataRepo.updatePinnedVoca(id: id)
    }
    
    //MARK: 단어장 삭제
    //TODO: Publisher 반환타입 수정
    func deletedVocaData(id: UUID) -> AnyPublisher<String, FirstPartyRepoError> {
        return coreDataRepo.deletedVocaData(id: id)
    }
}
