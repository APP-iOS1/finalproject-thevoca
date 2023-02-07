//
//  WordSearchingView.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI

// 사용자가 등록한 단어에서만 검색해서 보여주는 탭
struct WordSearchingView: View {
    // MARK: Environment
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: View Properties...
    @State var searchStr : String = ""
    @State var allWords : [SearchingWordModel] = []
    
    var lowerCasedSearchWord: String {
        searchStr.lowercased()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 검색어가 입력되지 않았을 때 나타낼 Placeholder
                if searchStr.count == 0 {
                    HStack {
                        VStack(alignment: .center) {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("검색어를 입력해주세요")
                                .font(.title3)
                        }
                        .foregroundColor(.gray)
                        .verticalAlignSetting(.center)
                    }
                    .horizontalAlignSetting(.center)
                    
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                            Section {
                                ForEach(allWords) { word in
                                  if ( word.meaning.joined(separator: ", ").lowercased().contains(lowerCasedSearchWord) ||
                                         word.word.lowercased().contains(lowerCasedSearchWord) ) {
                                        
                                        VStack(spacing: 0) {
                                            SearchListCell(word: word)
                                            
                                            Rectangle()
                                                .foregroundColor(Color("toolbardivider"))
                                                .frame(height: 1)
                                        }
                                        
                                    }
                                }
                            } header: {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("단어장")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        Text("단어")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        Text("뜻")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .frame(height: 40)
                                    .background { Color("offwhite") }
                                    
                                    Rectangle()
                                        .foregroundColor(Color("toolbardivider"))
                                        .frame(height: 1)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("내단어검색")
            .onAppear {
                let vocabularyList = searchResults() as [Vocabulary]
                allWords = toSearchwords(vocaList: vocabularyList)
            }
        }.searchable(text: $searchStr, prompt: "단어를 입력해주세요.")
    }
    // MARK: vocabulary를 fetch 받아오는 함수
    func searchResults() -> [Vocabulary] {
        let vocabularyFetch = Vocabulary.fetchRequest()
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        
        return results
    }
    
    // MARK: 모든 단어장 단어 하나의 배열로 합치기 함수
    func toSearchwords(vocaList: [Vocabulary]) -> [SearchingWordModel] {
        var allword: [SearchingWordModel] = []
        
        for voca in vocaList {
            let originWords = (voca.words?.allObjects as? [Word] ?? [])
            var vocaModel = SearchingVocaModel(words: [])
            
            for word in originWords {
                let wordModel = SearchingWordModel(
                    vocabulary: voca.name ?? "",
                    word: word.word ?? "",
                    meaning: word.meaning ?? [],
                    recentTestResults: word.recentTestResults ?? [],
                    correctCount: Int(word.correctCount),
                    incorrectCount: Int(word.incorrectCount)
                )
                vocaModel.words.append(wordModel)
            }
            
            allword.append(contentsOf: vocaModel.words)
        }
        
        return allword
    }
}

struct WordSearchingView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) private var viewContext
    
    static var previews: some View {
        WordSearchingView()
    }
}
