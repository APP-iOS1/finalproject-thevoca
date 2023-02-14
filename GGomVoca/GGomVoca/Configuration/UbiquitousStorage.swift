//
//  UbiquitousStore.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/07.
//

import Foundation

// MARK: NSUbiquitousKeyValueStore를 마치 @AppStorage처럼 쓸 수 있게 해주는 프로퍼티래퍼
@propertyWrapper
struct UbiquitousStorage<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            NSUbiquitousKeyValueStore().object(forKey: key) as? T ?? defaultValue
        }
        set {
            NSUbiquitousKeyValueStore().set(newValue, forKey: key)
            NSUbiquitousKeyValueStore().synchronize()
        }
    }
}

// MARK: NSUbiquitousKeyValueStore 객체를 생성하지 않고 바로 점표기법으로 접근하기 위한 extension
/// - 하지만, 우리 앱에서는 이것들을 만질 메서드도 잔뜩 필요하기 때문에 일단 사용하지 않고 UserManager에서 관리하기로 함!
//extension NSUbiquitousKeyValueStore {
//    @UbiquitousStorage(key: "pinnedVocabularyIDs",   defaultValue: []) static var pinnedVocabularyIDs  : [String]
//    @UbiquitousStorage(key: "koreanVocabularyIDs",   defaultValue: []) static var koreanVocabularyIDs  : [String]
//    @UbiquitousStorage(key: "englishVocabularyIDs",  defaultValue: []) static var englishVocabularyIDs : [String]
//    @UbiquitousStorage(key: "japanishVocabularyIDs", defaultValue: []) static var japanishVocabularyIDs: [String]
//    @UbiquitousStorage(key: "frenchVocabularyIDs",   defaultValue: []) static var frenchVocabularyIDs  : [String]
//}
