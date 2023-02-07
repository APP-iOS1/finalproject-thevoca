//
//  WordService.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/06.
//

import Foundation
import Combine
protocol WordListService{
    
    //MARK: 데이터를 디스크에 저장
    func saveContext()
    
    // MARK: 일치하는 id의 단어장 불러오기
    func getVocabularyFromId(vocabularyID: Vocabulary.ID) -> AnyPublisher<Vocabulary, RepositoryError>
    
    // MARK: 단어리스트 불러오기
    func fetchWordList(vocabulary: Vocabulary) -> AnyPublisher<[Word], RepositoryError>
    // MARK: 단어 추가하기
    func postWordData(word: String, meaning: [String], option: String, voca: Vocabulary) -> AnyPublisher<Word, RepositoryError>
//
    // MARK: 단어 수정하기
    //TODO: Publisher 반환타입 수정
    func updateWord(editWord: Word, word: String, meaning: [String], option: String) -> AnyPublisher<Word, RepositoryError>
    
    // MARK: 단어 삭제하기
    func deleteWord(word: Word) -> AnyPublisher<String, RepositoryError>

//    //TODO: Publisher 반환타입 수정
//    func deleteWord(id: UUID) -> AnyPublisher<String, FirstPartyRepoError>
    

   
   
   
   
   
}
