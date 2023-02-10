//
//  WordSearchingView.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI

struct SearchingResultsInMyWordsView: View {
    // MARK: ViewModel
    var viewModel = SearchingResultsInMyWordsViewModel()
    
    // MARK: Super View Properties...
    @Binding var selectedVocabulary: Vocabulary?
    var keyword: String
    
    // MARK: View Properties
    @State private var searchResult: [Word] = []
    
    var body: some View {
        List(searchResult, selection: $selectedVocabulary) { word in
            SearchingResultInMyWordsCell(word: word, keyword: keyword)
        }
        .listStyle(InsetGroupedListStyle())
        .onChange(of: keyword) { newValue in
            searchResult = viewModel.searchKeyword(for: newValue)
        }
    }
}

//struct WordSearchingView_Previews: PreviewProvider {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    static var previews: some View {
//        WordSearchingView(keyword: .contains(""))
//    }
//}
