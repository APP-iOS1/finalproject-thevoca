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
                switch header {
                case sectionHeaders[0]:
                    Section(header: HStack {
                        Text(header)
                        
                        Spacer()
                        
                        NavigationLink(destination: MyNoteDetailView(
                            navigationTitle: header,
                            words: frequentlyIncorrectedWords)
                        ) {
                            
                            Text("더보기")
                                .font(.callout)
                        }
                    }) {
                        if frequentlyIncorrectedWords.count >= 6 {
                            ForEach(frequentlyIncorrectedWords[0..<5]) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        } else {
                            // 단어가 5개 이하일 때는 변환 과정 없이 그대로
                            ForEach(frequentlyIncorrectedWords) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        }
                    }
                case sectionHeaders[1]:
                    Section(header: HStack {
                        Text(header)
                        
                        Spacer()
                        
                        NavigationLink(destination: MyNoteDetailView(
                            navigationTitle: header,
                            words: frequentlyIncorrectedWords)
                        ) {
                            Text("더보기")
                                .font(.callout)
                        }
                    }) {
                        if confusedWords.count >= 6 {
                            ForEach(confusedWords[0..<5]) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        } else {
                            // 단어가 5개 이하일 때는 변환 과정 없이 그대로
                            ForEach(confusedWords) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        }
                    }
                case sectionHeaders[2]:
                    Section(header: HStack {
                        Text(header)
                        
                        Spacer()
                        
                        NavigationLink(destination: MyNoteDetailView(
                            navigationTitle: header,
                            words: frequentlyIncorrectedWords)
                        ) {
                            Text("더보기")
                                .font(.callout)
                        }
                    }) {
                        if perfectlyMemorizedWords.count >= 6 {
                            ForEach(perfectlyMemorizedWords[0..<5]) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        } else {
                            // 단어가 5개 이하일 때는 변환 과정 없이 그대로
                            ForEach(perfectlyMemorizedWords) { word in
                                HStack(spacing: 0) {
                                    Text(word.word ?? "")
                                    
                                    Spacer()
                                    
                                    ForEach(word.recentTestResults ?? [], id: \.self) { result in
                                        Image(systemName: result == "O" ? "circle" : "xmark")
                                            .foregroundColor(result == "O" ? .green : .red)
                                    }
                                }
                            }
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
        .listStyle(.insetGrouped)
        
        .navigationTitle("단어장 세부 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension Array<Word> {
    /// 단어들 중에서 오답의 빈도 수가 총 시험 횟수와 같은 경우 : 자주 틀린 단어
    func getFrequentlyIncorrectedWords() -> [Word] {
        return self.filter { $0.recentTestResults?.filter { $0 == false }.count == $0.recentTestResults?.count }
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
