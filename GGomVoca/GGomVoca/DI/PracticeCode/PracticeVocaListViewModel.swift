//
//  PracticeVocaListViewModel.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import Foundation
class PracticeVocaListViewModel : ObservableObject{
    var service : VocabularyService
    init(service: VocabularyService) {
        self.service = service
    }
}
