//
//  VocabularyService.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine

protocol VocabularyService{
    
    //MARK: 데이터를 디스크에 저장
    func saveContext()
   //MARK: 단어장 리스트 불러오기
    func fetchVocabularyList() -> AnyPublisher<[Vocabulary], RepositoryError>
    //MARK: 단어장 추가하기
    func postVocaData(vocaName : String, nationality: String) -> AnyPublisher<Vocabulary, RepositoryError>
    //MARK: 단어장 고정 상태 업데이트
    //TODO: Publisher 반환타입 수정
    func updatePinnedVoca(id: UUID) -> AnyPublisher<String, RepositoryError>

    //MARK: 단어장 삭제
    //TODO: Publisher 반환타입 수정
    func deletedVocaData(id: UUID) -> AnyPublisher<String, RepositoryError>
}
