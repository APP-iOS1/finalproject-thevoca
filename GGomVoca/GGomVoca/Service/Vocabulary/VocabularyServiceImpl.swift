//
//  VocabularyServiceImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine

class VocabularyServiceImpl: VocabularyService{
    
    
    var repository  : CoreDataRepository
    
    init(repo : CoreDataRepository){
        self.repository = repo
    }
    //MARK: 단어장 리스트 불러오기
    func fetchVocabularyList() -> AnyPublisher<[Vocabulary], CoredataRepoError> {
        return repository.fetchVocaData()
    }
}
