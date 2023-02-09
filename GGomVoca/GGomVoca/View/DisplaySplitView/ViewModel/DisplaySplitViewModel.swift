//
//  VocabularyListViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2022/12/20.
//

import Foundation
import SwiftUI
import Combine
// -> Entity -> Model -> ViewModel(UI 데이터) -> View

//Server -> Repository(reposiroty pattern) -> ViewModel
class DisplaySplitViewModel : ObservableObject {

    // MARK: Service Property
    var service : VocabularyService
    private var bag : Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: Published Properties
    @Published var vocabularyList:[Vocabulary] = [] // all vocabularies

    
    init(vocabularyList: [Vocabulary], service : VocabularyService) {
        self.vocabularyList = vocabularyList
        self.service = service
    }

    // MARK: Get Vocabulary Lists
    func getVocabularyData() {
        service.fetchVocabularyList()
            .sink(receiveCompletion: { observer in
                switch observer {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: { [weak self] vocaList in
                let list = vocaList.filter{ $0.deleatedAt == nil}
                self?.vocabularyList = list
                print("getVocabularyData \(list)")
           
            })
            .store(in: &bag)
    }
    
    /*
     Post 단어장 추가
     */
    func addVocabulary(name: String, nationality: String) { //name: String, nationality: String
        
        service.postVocaData(vocaName: "\(name)", nationality: "\(nationality)")
            .sink(receiveCompletion: {value in
                
                
            }, receiveValue: {[weak self] value in
                
               
                print("postVocaData result : \(value)")
                self?.service.saveContext()
                
                self?.getVocabularyData()
                //context에 저장 -> 전체 단어장 배열 다시 불러오기 -> 다음 유비쿼터스에 추가
                UserManager.addVocabulary(id: value.id!.uuidString, nationality: "\(value.nationality ?? "")")
            })
            .store(in: &bag)

    }
    
    
    /*
     즐겨찾기 업데이트
     */
    func updateIsPinnedVocabulary(id: UUID) {
        service.updatePinnedVoca(id: id)
            .sink(receiveCompletion: {observer in
                switch observer {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
                
            }, receiveValue: { [weak self] result in
                print(result)
                self?.service.saveContext()
                self?.getVocabularyData()
            
                
            }).store(in: &bag)

    }
    
    // MARK: Vocabualry.ID로 해당 단어장을 찾아오는 메서드
    func getVocabulary(for vocaId: String) -> Vocabulary {
        var vocabulary = Vocabulary()
        
        if let vocaIndex = vocabularyList.firstIndex(where: { $0.id?.uuidString ?? "" == vocaId }) {
            vocabulary = vocabularyList[vocaIndex]
        }
        
        return vocabulary
    }
    
    
    
    // MARK: 단어장 삭제 함수
    func deleteVocabulary(id: String) {
        //UpdatedCode
        guard let uuid = UUID(uuidString: id) else { return }
        service.deletedVocaData(id: uuid)
            .sink(receiveCompletion: { observer in
                switch observer {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: {[weak self] value in
                print(value)
                self?.service.saveContext() //저장
                self?.getVocabularyData() //불러오기
                //MARK: 유비쿼터스 삭제
                UserManager.deleteVocabulary(id: id)
            }).store(in: &bag)
        
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
