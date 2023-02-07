//
//  VocabularyListViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import Foundation
import SwiftUI
// -> Entity -> Model -> ViewModel(UI 데이터) -> View

//Server -> Repository(reposiroty pattern) -> ViewModel
class DisplaySplitViewModel : ObservableObject {
    internal init(repository: CoredataRepository = CoredataRepository(), vocabularyList: [Vocabulary] = [], pinnedVocabularyList: [Vocabulary] = [], koreanVoca: [Vocabulary] = [], englishVoca: [Vocabulary] = [], japaneseVoca: [Vocabulary] = [], frenchVoca: [Vocabulary] = []) {
        self.repository = repository
        self.vocabularyList = vocabularyList
        self.pinnedVocabularyList = pinnedVocabularyList
        self.koreanVoca = koreanVoca
        self.englishVoca = englishVoca
        self.japaneseVoca = japaneseVoca
        self.frenchVoca = frenchVoca
    }
    
    // MARK: Store Property
    var repository : CoredataRepository = CoredataRepository()
    
    // MARK: Published Properties
    @Published var vocabularyList       : [Vocabulary] = [] // all vocabularies
    @Published var pinnedVocabularyList : [Vocabulary] = [] // 즐겨찾기
    @Published var koreanVoca           : [Vocabulary] = [] // 한국어 단어장
    @Published var englishVoca          : [Vocabulary] = [] // 영어 단어장
    @Published var japaneseVoca         : [Vocabulary] = [] // 일본어 단어장
    @Published var frenchVoca           : [Vocabulary] = [] // 프랑스어 단어장
    
    init(vocabularyList: [Vocabulary]) {
        self.vocabularyList = vocabularyList
    }
    
    // MARK: Clear Vocabulary Lists
    func clearVoca() {
        vocabularyList = []
        pinnedVocabularyList = []
        koreanVoca = []
        japaneseVoca = []
        englishVoca = []
        frenchVoca = []
    }

    // MARK: Get Vocabulary Lists
    func getVocabularyData() {
        let results = repository.getVocabularyData()
        clearVoca()
        
        for voca in results {
            if voca.deleatedAt == nil {
                vocabularyList.append(voca)
                
                if voca.isPinned {
                    pinnedVocabularyList.append(voca)
                    continue
                }
                
                /// MARK: 단어 국가 설정은 이중으로 설정될 수 없기 때문에 continue
                if voca.nationality == "KO" {
                    koreanVoca.append(voca)
                    continue
                }
                
                if voca.nationality == "EN" {
                    englishVoca.append(voca)
                    continue
                }
                
                if voca.nationality == "JA" {
                    japaneseVoca.append(voca)
                    continue
                }
                
                if voca.nationality == "FR" {
                    frenchVoca.append(voca)
                    continue
                }
            }
        }
    }
    
    // MARK: Vocabualry.ID로 해당 단어장을 찾아오는 메서드
    func getVocabulary(for vocaId: String) -> Vocabulary {
        var vocabulary = Vocabulary()
        
        if let vocaIndex = vocabularyList.firstIndex(where: { $0.id?.uuidString ?? "" == vocaId }) {
            vocabulary = vocabularyList[vocaIndex]
        }
        
        return vocabulary
    }
    
    // MARK: 최근 본 단어장을 UserDefault에서 삭제
//    func deleteRecentVoca(id : String) {
//        // [voca1, voca2]
//        var before =  UserManager.shared.recentVocabulary
//        if let idx = before.firstIndex(of: "\(id)"){
//            before.remove(at: idx)
//        }
//        UserManager.shared.recentVocabulary = before
//    }

//    // MARK: 최근 본 단어장 관리 메서드
//    func manageRecentVocabulary(voca: Vocabulary) {
//        /// - 기존에 최근 본 단어장에 들어있는 단어장을 또 확인 한 경우 배열에서 지우고 배열의 첫번째 요소로 다시 삽입
//        deleteRecentVoca(id: "\(voca.id!)")
//        var before =  UserManager.shared.recentVocabulary
//
//        before.insert("\(voca.id!)", at: 0)
//
//        if before.count >= 4{
//            before.removeLast()
//        }
//
//        UserManager.shared.recentVocabulary = before
//    }
}
