//
//  UserManager.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/17.
//

import Foundation
//
class UserManager{
    static var shared = UserManager()
    
    var recentVocabulary : [String]{
       
        get {
            let defaults = UserDefaults.standard
            return defaults.array(forKey: "RecentVocabulary") as? [String] ?? []
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "RecentVocabulary")
        }
        
    }
    
    
   
}
