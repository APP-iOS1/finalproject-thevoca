//
//  VocabularyService.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine

protocol VocabularyService{
   //MARK: 단어장 리스트 불러오기
    func fetchVocabularyList() -> AnyPublisher<[Vocabulary], CoredataRepoError>
}


