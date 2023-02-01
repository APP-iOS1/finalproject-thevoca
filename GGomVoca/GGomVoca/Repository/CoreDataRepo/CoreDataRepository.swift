//
//  CoredataRepository.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine
import CoreData
enum CoredataRepoError: Error{
    case notFoundData
  
    
}


protocol CoreDataRepository {
    //MARK: 데이터를 디스크에 저장
    func saveContext()
    //MARK: 단어장 불러오기
    func fetchVocaData() -> AnyPublisher<[Vocabulary], CoredataRepoError>
    //MARK: 단어장 추가하기
    func postVocaData(vocaName : String, nationality: Nationality) -> AnyPublisher<Vocabulary, CoredataRepoError>
//    func updateVocaData() -> AnyPublisher<String?, CoredataRepoError>
//    func deleteVocaData() -> AnyPublisher<String?, CoredataRepoError>
}
