//
//  UserManager.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/01/17.
//

import SwiftUI

final class UserManager {
    static var shared = UserManager()
    
    @UbiquitousStorage(key: "pinnedVocabularyIDs",   defaultValue: []) var pinnedVocabularyIDs  : [String]
    @UbiquitousStorage(key: "koreanVocabularyIDs",   defaultValue: []) var koreanVocabularyIDs  : [String]
    @UbiquitousStorage(key: "englishVocabularyIDs",  defaultValue: []) var englishVocabularyIDs : [String]
    @UbiquitousStorage(key: "japanishVocabularyIDs", defaultValue: []) var japanishVocabularyIDs: [String]
    @UbiquitousStorage(key: "frenchVocabularyIDs",   defaultValue: []) var frenchVocabularyIDs  : [String]
    
    // MARK: 단어장 추가
    static func addVocabulary(id: String, nationality: String) {
        switch nationality {
        case "KO":
            shared.koreanVocabularyIDs.append(id)
        case "EN":
            shared.englishVocabularyIDs.append(id)
        case "JA":
            shared.japanishVocabularyIDs.append(id)
        case "FR":
            shared.frenchVocabularyIDs.append(id)
        default:
            break
        }
    }
    
    // MARK: 단어장 삭제
    static func deleteVocabulary(id: String) {
        if let index = shared.pinnedVocabularyIDs.firstIndex(of: id) {
            shared.pinnedVocabularyIDs.remove(at: index)
        } else if let index = shared.koreanVocabularyIDs.firstIndex(of: id) {
            shared.koreanVocabularyIDs.remove(at: index)
        } else if let index = shared.englishVocabularyIDs.firstIndex(of: id) {
            shared.englishVocabularyIDs.remove(at: index)
        } else if let index = shared.japanishVocabularyIDs.firstIndex(of: id) {
            shared.japanishVocabularyIDs.remove(at: index)
        } else if let index = shared.frenchVocabularyIDs.firstIndex(of: id) {
            shared.frenchVocabularyIDs.remove(at: index)
        }
    }
    
    // MARK: EditMode에서 단어장 삭제
    static func editModeDeleteVocabulary(at offset: IndexSet.Element, in group: String) -> String {
        var result = ""
        
        switch group {
        case "pinned":
            result = UserManager.shared.pinnedVocabularyIDs.remove(at: offset)
        case "korean":
            result = UserManager.shared.koreanVocabularyIDs.remove(at: offset)
        case "english":
            result = UserManager.shared.englishVocabularyIDs.remove(at: offset)
        case "japanish":
            result = UserManager.shared.japanishVocabularyIDs.remove(at: offset)
        case "french":
            result = UserManager.shared.frenchVocabularyIDs.remove(at: offset)
        default:
            break
        }
        
        return result
    }
    
    // MARK: 단어장 고정
    static func pinnedVocabulary(id: String, nationality: String) {
        if let index = shared.pinnedVocabularyIDs.firstIndex(of: id) {
            shared.pinnedVocabularyIDs.remove(at: index)
            addVocabulary(id: id, nationality: nationality)
        } else {
            shared.pinnedVocabularyIDs.append(id)
            
            if let index = shared.koreanVocabularyIDs.firstIndex(of: id) {
                shared.koreanVocabularyIDs.remove(at: index)
            } else if let index = shared.englishVocabularyIDs.firstIndex(of: id) {
                shared.englishVocabularyIDs.remove(at: index)
            } else if let index = shared.japanishVocabularyIDs.firstIndex(of: id) {
                shared.japanishVocabularyIDs.remove(at: index)
            } else if let index = shared.frenchVocabularyIDs.firstIndex(of: id) {
                shared.frenchVocabularyIDs.remove(at: index)
            }
        }
    }
    
    var recentVocabulary : [String] {
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
