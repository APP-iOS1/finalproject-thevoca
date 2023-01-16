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
class VocabularyListViewModel : ObservableObject {
    
    var repository : CoredataRepository = CoredataRepository() //Store
    //@Environment(\.managedObjectContext) private var viewContext -> Environment 래퍼 프로퍼티 정의 다시 공부하기(여기서 사용하면 안 됨)
    @Published var vocabularyList : [Vocabulary]  = []
    @Published  var recentVocabularyList : [Vocabulary]  = []
    //즐겨찾기
    @Published var favoriteVoca : [Vocabulary] = []
    //한국어
    @Published var koreanVoca : [Vocabulary] = []
    //일본어
    @Published var japaneseVoca : [Vocabulary] = []
    //영어
    @Published var englishVoca : [Vocabulary] = []
    //중국어
    @Published var chineseVoca : [Vocabulary] = []
    //프랑스어
    var frenchVoca : [Vocabulary] = []
    //독일어
    var germanVoca : [Vocabulary] = []
    //스페인어
    var spanishVoca : [Vocabulary] = []
    //이탈리아어
    var italianVoca : [Vocabulary] = []
    
    init(vocabularyList: [Vocabulary]) {
        self.vocabularyList = vocabularyList
    }
    
    /*
     Get Vocabulary List
     */
    func getVocabularyData()
    -> [Vocabulary] {
        let vocabularyFetch = Vocabulary.fetchRequest()

        var results = (try? repository.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        self.vocabularyList = results.filter{
            $0.deleatedAt == nil || $0.deleatedAt?.count == 0
        }
        print("반환 결과getVocabularyData() : \(results)")
        
        favoriteVoca = vocabularyList.filter {
            $0.isFavorite == true && $0.deleatedAt == nil
        }
        koreanVoca = results.filter {
            $0.nationality == "KO" && $0.deleatedAt == nil
        }
        japaneseVoca = results.filter {
            $0.nationality == "JA" && $0.deleatedAt == nil
        }
        englishVoca = results.filter {
            $0.nationality == "EN" && $0.deleatedAt == nil
        }
        chineseVoca = results.filter {
            $0.nationality == "CH" && $0.deleatedAt == nil
        }
        frenchVoca = results.filter {
            $0.nationality == "FR" && $0.deleatedAt == nil
        }
        germanVoca = results.filter {
            $0.nationality == "DE" && $0.deleatedAt == nil
        }
        spanishVoca = results.filter {
            $0.nationality == "ES" && $0.deleatedAt == nil
        }
        italianVoca = results.filter {
            $0.nationality == "IT" && $0.deleatedAt == nil
        }
        
        
        
        return results
    }
    
    
    
}
