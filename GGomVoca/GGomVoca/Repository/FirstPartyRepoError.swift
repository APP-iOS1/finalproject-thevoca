//
//  FirstPartyRepoError.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/06.
//

import Foundation
//Coredata, Cloudkit Repository Error Type
enum FirstPartyRepoError: Error{
    case notFoundDataFromCoreData
    case notFoundDataFromCloudKit
}
