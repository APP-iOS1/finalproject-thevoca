//
//  WordService.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/06.
//

import Foundation
import Combine
protocol WordService{
    
    //MARK: 데이터를 디스크에 저장
    func saveContext()
    // MARK: 일치하는 id의 단어장 불러오기
    func fetchWordList() -> AnyPublisher<[Word], FirstPartyRepoError>
    // MARK: 단어 추가하기
    func postWordData(vocaName : String, nationality: String) -> AnyPublisher<Word, FirstPartyRepoError>
    
    // MARK: 단어 수정하기
    //TODO: Publisher 반환타입 수정
    func updateWord(id: UUID) -> AnyPublisher<String, FirstPartyRepoError>

    // MARK: 단어 삭제하기
    //TODO: Publisher 반환타입 수정
    func deleteWord(id: UUID) -> AnyPublisher<String, FirstPartyRepoError>
    
    
    
    

   
   
   
   
   
}
