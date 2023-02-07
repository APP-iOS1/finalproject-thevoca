//
//  CoredataRepository.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine
import CoreData



protocol CoreDataRepository {
    //MARK: 데이터를 디스크에 저장
    func saveContext()
    //MARK: 단어장 리스트 불러오기
    func fetchVocaListData() -> AnyPublisher<[Vocabulary], RepositoryError>
    
    
    //MARK: 단어장 id로 불러오기
    func getVocabularyFromID(vocabularyID: UUID) -> AnyPublisher<Vocabulary, RepositoryError>
    
    //MARK: 단어리스트 불러오기
    func getWordListFromVoca(voca : Vocabulary) -> AnyPublisher<[Word], RepositoryError>
    
    //MARK: 단어장 추가하기
    func postVocaData(vocaName : String, nationality: String) -> AnyPublisher<Vocabulary, RepositoryError>
    
    // MARK: 단어 추가하기
    //TODO: Publisher 반환타입 수정
    func addNewWord(word: String, meaning: [String], option: String, voca: Vocabulary) -> AnyPublisher<Word, RepositoryError>
    
    //MARK: 단어장 고정 상태 업데이트
    //TODO: Publisher 반환타입 수정
    func updatePinnedVoca(id: UUID) -> AnyPublisher<String, RepositoryError>
    
    //MARK: 단어 수정하기
    // MARK: 단어 수정하기
    func updateWord(editWord: Word, word: String, meaning: [String], option: String) -> AnyPublisher<Word, RepositoryError>
      


    //MARK: 단어장 삭제
    //TODO: Publisher 반환타입 수정
    func deletedVocaData(id: UUID) -> AnyPublisher<String, RepositoryError>
    
    //MARK: 단어 삭제
    func deleteWord(word: Word) -> AnyPublisher<String, RepositoryError>
     
    
}
