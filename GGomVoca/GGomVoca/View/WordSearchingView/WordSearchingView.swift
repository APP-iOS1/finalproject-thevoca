//
//  WordSearchingView.swift
//  GGomVoca
//
//  Created by TEDDY on 12/20/22.
//

import SwiftUI
// 검색 탭 뷰
struct WordSearchingView: View {
    @Environment(\.managedObjectContext) private var viewContext

    func searchResults()
    -> [Vocabulary] {
        let vocabularyFetch = Vocabulary.fetchRequest()
//        vocabularyFetch.predicate = NSPredicate(format: "title CONTAINS[c] %@",searchingFor)
 //       vocabularyFetch.sortDescriptors = [NSSortDescriptor(key: \Vocabulary.createdAt, ascending: true)]
        let results = (try? self.viewContext.fetch(vocabularyFetch) as [Vocabulary]) ?? []
        print("전체 단어장 결과 \(results)")
        return results
    }
    
//    @FetchRequest(
//        entity: Vocabulary.entity(),
   //     sortDescriptors: [NSSortDescriptor(keyPath: \Vocabulary.createdAt, ascending: true)],
//        animation: .default)
//    private var vocabularies: FetchedResults<Vocabulary>

    @State var searchStr : String = ""
    @State var allWords : [SearchingWordModel] = []
    // @EnvironmentObject var wordsData : VocabularyStore
    var deviceWidth = UIScreen.main.bounds.size.width
    
    // 로컬에서 검색
    // DummyData.filter{} 필터
    // 텍스트 변화 -> api 호출
    var body: some View {
        NavigationStack {
            VStack{
                // MARK: TextField로 만드는 방법
                
                //            HStack{
                //                Image(systemName: "magnifyingglass")
                //                TextField("단어 검색", text: $searchStr)
                //                   }
                
                // MARK: .searchable 을 통해 검색바 만들기
                
                List{
                    if searchStr.count == 0 {
                        HStack{
                            Spacer()
                            VStack(alignment: .center){
                                Spacer()
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text("검색어를 입력해주세요")
                                    .font(.title3)
                                Spacer()
                            }
                            .foregroundColor(.gray)
//                            .onAppear {
//                                UIScrollView.appearance().bounces = false
//                            }
                            Spacer()
                        }
                        .padding(.vertical, 150)
                    }
                    else{
                        
                        ForEach(allWords) { word in
                            if word.meaning.lowercased().contains(searchStr.lowercased()) ?? false || ((word.word.lowercased().contains(searchStr.lowercased())) ?? false){
                                
                                SearchListCell(word: word)
                                    .padding(0)
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                .onAppear{
                    var vocabularyList = searchResults() as [Vocabulary]
                    allWords = toSearchwords(vocaList: vocabularyList)
                }
                .searchable(
                    text: $searchStr,
                    placement: .navigationBarDrawer,
                    prompt: "단어 검색"
                )
            }
            .navigationBarTitle("내단어검색")
        }
    }
    /*
     모든 단어장 단어 하나의 배열로 합치기 함수
     */
    func toSearchwords(vocaList: [Vocabulary]) -> [SearchingWordModel]{
        var allword: [SearchingWordModel] = []
        vocaList.forEach { voca in
            print("voca.words \(voca.words)")
            var originWords = (voca.words?.allObjects ?? []) as [Word]
            var vocaModel = SearchingVocaModel(words: [])
            originWords.forEach{
                var wordModel = SearchingWordModel(
                    vocabulary: voca.name ?? "",
                    word: $0.word ?? "",
                    meaning: $0.meaning ?? "",
                    recentTestResults: $0.recentTestResults ?? [],
                    correctCount: Int($0.correctCount ?? 0),
                    incorrectCount: Int16(Int($0.incorrectCount ?? 0)))
                vocaModel.words.append(wordModel)
            }
           
            
            allword.append(contentsOf: vocaModel.words)
        }
        print("toSearchwords(): \(allword)")
        return allword
    }
}

struct WordSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchingView()
    }
}
