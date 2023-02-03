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
        print(" getVocaListData()")
        service.fetchVocabularyList()
            .sink(receiveCompletion: {_ in
                
            }, receiveValue: {
                vocaList in
                print(" getVocaListData \(vocaList)")
                self.vocaList = vocaList
            })
            
    }
}
