//
//  PracticeVocaListView.swift
//  GGomVoca
//
//  Created by JeongMin Ko on 2023/02/02.
//

import SwiftUI

//DI Container와 CloudKit 테스트를 위한 뷰입니다. (테스트 후 지울 예정)
struct PracticeVocaListView: View {
    var viewModel : PracticeVocaListViewModel
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PracticeVocaListView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeVocaListView(viewModel: PracticeVocaListViewModel(service: VocabularyServiceImpl(repo: CoreDataRepositoryImpl())))
    }
}
