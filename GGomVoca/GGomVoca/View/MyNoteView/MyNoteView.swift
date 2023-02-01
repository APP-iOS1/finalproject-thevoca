//
//  MyNoteView.swift
//  GGomVoca
//
//  Created by 고도 on 2023/02/01.
//

import SwiftUI

struct MyNoteView: View {
    private let sectionHeaders = ["자주 틀린 단어", "헷갈리는 단어", "완벽히 외운 단어"]
    
    // 자주 틀린 단어
    private var frequentlyIncorrectedWords: [Word] {
        return words.getFrequentlyIncorrectedWords()
    }
    
    // 헷갈리는 단어
    private var confusedWords: [Word] {
        return words.getConfusedWords()
    }
    
    // 완벽히 외운 단어
    private var perfectlyMemorizedWords: [Word] {
        return words.getPerfectlyMemorizedWords()
    }
    
    var words: [Word]
    
    var body: some View {
        List {
            ForEach(sectionHeaders, id: \.self) { header in
                Section(header: HStack {
                    Text(header)
                }) {
                    if header == sectionHeaders[0] {
                        ForEach(frequentlyIncorrectedWords) { word in
                            Text(word.word ?? "")
                        }
                    } else if header == sectionHeaders[1] {
                        ForEach(confusedWords) { word in
                            Text(word.word ?? "")
                        }
                    } else {
                        ForEach(perfectlyMemorizedWords) { word in
                            Text(word.word ?? "")
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        
        .navigationTitle("단어장 세부 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Array<Word> {
    /// 단어들 중에서 오답의 빈도 수가 총 시험 횟수와 같은 경우 : 자주 틀린 단어
    func getFrequentlyIncorrectedWords() -> [Word] {
        return self.filter { $0.recentTestResults?.filter { $0 == false }.count == $0.recentTestResults?.count ?? -1 / 2 }
    }
    
    /// 단어들 중에서 정답의 빈도 수가 총 시험 횟수의 절반인 경우 : 헷갈리는 단어
    func getConfusedWords() -> [Word] {
        return self.filter { $0.recentTestResults?.filter { $0 == true }.count == $0.recentTestResults?.count ?? -1 / 2 }
    }
    
    /// 단어들 중에서 정답의 빈도 수가 총 시험 횟수와 같은 경우 : 완벽히 외운 단어
    func getPerfectlyMemorizedWords() -> [Word] {
        return self.filter { $0.recentTestResults?.filter { $0 == true }.count == $0.recentTestResults?.count }
    }
}

struct MyNoteView_Previews: PreviewProvider {
    static var viewModel: KOWordListViewModel = KOWordListViewModel()
    
    static var previews: some View {
        MyNoteView(words: viewModel.words)
    }
}
