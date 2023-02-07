//
//  CloudError.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/07.
//

import Foundation
enum CloudError: ErrorProtocol {
    //MARK: WORD
    case notFoundWordFromCloudKit
    case failPostWordFromCloudKit
    case failUpdateWordFromCloudData
    case failDeleteWordFromCloudData
    case failDeleteVocaFromCloudData
    case failUpdateVocaFromCloudData
    case failPostVocaFromCloudKit
    case notFoundVocaFromCloudKit
    var errorDescription: String? {
        switch self {
            //MARK: WORD ERROR errorDescription
            
        case .notFoundWordFromCloudKit:
            return "클라우드 DB로부터 단어를 찾을 수 없습니다."
            
            
        case .failPostWordFromCloudKit:
            return "단어 클라우드DB 추가 실패"
            
            
            
        case .failUpdateWordFromCloudData:
            return "클라우드 DB의 단어 수정 실패."
            
            
        case .failDeleteWordFromCloudData:
            return "클라우드 DB의 단어 삭제 실패"
            
        case .failDeleteVocaFromCloudData:
            return "클라우드 DB의 단어장 삭제 실패"
        case .failUpdateVocaFromCloudData:
            return "클라우드 DB의 단어장 수정 실패."
            
        case .failPostVocaFromCloudKit:
            return "단어장 클라우드DB 추가 실패"
        case .notFoundVocaFromCloudKit:
            return "클라우드 DB로부터 단어장을 찾을 수 없습니다."
        }
    }
}
