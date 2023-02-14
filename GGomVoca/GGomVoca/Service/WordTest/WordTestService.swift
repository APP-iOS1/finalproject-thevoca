//
//  WordTestService.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/13.
//

import Foundation
import Combine

protocol WordTestService {
    
    //MARK: 데이터를 디스크에 저장
    func saveContext()
    
    // MARK: 일치하는 id의 단어장 불러오기
    func getVocabularyFromId(vocabularyID: Vocabulary.ID) -> AnyPublisher<Vocabulary, RepositoryError>
    
    // MARK: 단어리스트 불러오기
    func fetchWordList(vocabulary: Vocabulary) -> AnyPublisher<[Word], RepositoryError>
    
    // MARK: - Core Data에 시험결과 저장
    func testResult()

}
