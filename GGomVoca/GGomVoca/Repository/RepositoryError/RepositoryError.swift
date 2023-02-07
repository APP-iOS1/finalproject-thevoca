//
//  RepositoryError.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/07.
//

import Foundation
enum RepositoryError: Error, ErrorProtocol {
    case cloudRepositoryError(error: CloudError)
    case coreDataRepositoryError(error: CoreDataError)

    var errorDescription: String? {
        switch self {
        case .cloudRepositoryError(let error):
            return error.errorDescription
        case .coreDataRepositoryError(let error):
            return error.errorDescription
        }
    }
}
