//
//  RepositoryErrorProtocol.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/07.
//

import Foundation
//Error 타입 프로토콜
//Coredata, Cloudkit Repository Error Type
//Repository, Service 각각의 Error타입으로 세분화 할 예정
protocol ErrorProtocol: Error, LocalizedError {
    var errorDescription: String? { get }

}
