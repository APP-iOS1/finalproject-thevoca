//
//  PracticeVocaListViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import Foundation
import Combine

class PracticeVocaListViewModel : ObservableObject{
    var service : VocabularyService
    init(service: VocabularyService) {
        self.service = service
    }
    
    private var bag = Set<AnyCancellable>()
    @Published var vocaList : [Vocabulary] = []
    
    func getVocaListData(){
       
        service.fetchVocabularyList()
            .sink(receiveCompletion: {observer in
                switch observer {
                case .failure(let error):
                    print(error)
                    return
                case .finished:
                    return
                }
            }, receiveValue: {
                vocaList in
                self.vocaList = vocaList
            })
            .store(in: &bag)
            
    }
}
