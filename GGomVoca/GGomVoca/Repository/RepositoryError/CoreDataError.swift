//
//  CoreDataError.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/07.
//

import Foundation
enum CoreDataError: ErrorProtocol{
    case notFoundDataFromCoreData
 
    
    //MARK: VOCABULARY
    case notFoundVocaFromCoreData
    case failPostVocaFromCoreData
    case failUpdateVocaFromCoreData
    case failDeleteVocaFromCoreData
    case failDeleteWordFromCoreData
    case failUpdateWordFromCoreData
    case failPostWordFromCoreData
    case notFoundWordFromCoreData
   
    var errorDescription: String? {
        switch self {
            
        case .notFoundDataFromCoreData:
            return "로컬 DB로부터 데이터를 찾을 수 없습니다."
       
            //MARK: VOCABULARY ERROR errorDescription
        case .notFoundVocaFromCoreData:
            return "로컬 DB로부터 단어장을 찾을 수 없습니다."
            
        case .failPostVocaFromCoreData:
            return "단어장 로컬DB 추가 실패"
            
            
        case .failUpdateVocaFromCoreData:
            return "로컬DB의 단어장 수정 실패"
            
        case .failDeleteVocaFromCoreData:
            return "로컬DB의 단어장 삭제 실패"
        case .failDeleteWordFromCoreData:
            return "로컬DB의 단어 삭제 실패"
        case .failUpdateWordFromCoreData:
            return "로컬DB의 단어 수정 실패"
        case .failPostWordFromCoreData:
            return "단어 로컬DB 추가 실패"
            
        case .notFoundWordFromCoreData:
            return "로컬 DB로부터 단어를 찾을 수 없습니다."
            
            
        }
    }
}
