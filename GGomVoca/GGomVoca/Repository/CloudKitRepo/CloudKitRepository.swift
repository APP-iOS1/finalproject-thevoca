//
//  CloudKitRepository.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/01.
//

import Foundation
import Combine

enum CloudRepoError: Error{
    case notFoundData
    
    
}


protocol CloudKitRepository {
    func fetchVocaData() -> AnyPublisher<String?, CloudRepoError>
    func postVocaData() -> AnyPublisher<String?, CloudRepoError>
    func updateVocaData() -> AnyPublisher<String?, CloudRepoError>
    func deleteVocaData() -> AnyPublisher<String?, CloudRepoError>
}
