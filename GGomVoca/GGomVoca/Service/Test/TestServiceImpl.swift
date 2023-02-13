//
//  TestServiceImpl.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/13.
//

import Foundation
class TestServiceImpl : TestService{
    
    //Repository
    var coreDataRepo : CoreDataRepository
    var cloudDataRepo : CloudKitRepository
    
    init(coreDataRepo : CoreDataRepository, cloudDataRepo : CloudKitRepository ){
        self.coreDataRepo = coreDataRepo
        self.cloudDataRepo = cloudDataRepo
    }
    
    //디스크에 저장.
    func saveContext() {
        coreDataRepo.saveContext()
    }
    
    
}
