//
//  MyNoteView.swift
//  GGomVoca
//
//  Created by 고도 on 2023/02/01.
//

import SwiftUI

struct MyNoteView: View {
    // MARK: SuperView Property
    var words: [Word]
    
    // MARK: View Property
    /// - 최근 자주 틀리는 단어 == recentTestResults.hasSuffix("XXX")
    private var frequentlyIncorrectedWords: [Word] {
        words.filter {
            let recentResultsString: String = $0.recentTestResults?.joined() ?? ""
            return recentResultsString.hasSuffix("XXX")
        }
    }
    
    /// - 자꾸 헷갈리는 단어: recentTestResults의 길이가 5일때 O와 X의 개수 비율이 2:3, 3:2인 경우
    private var confusedWords: [Word] {
        let resultsCount5: [Word] = words.filter { $0.recentTestResults?.count ?? 0 == 5 }
        if resultsCount5.isEmpty {
            return []
        } else {
            return resultsCount5.filter {
                let countO: Int = $0.recentTestResults?.filter { $0 == "O" }.count ?? 0
                let countX: Int = $0.recentTestResults?.filter { $0 == "X" }.count ?? 0
                return (countO >= 2 && countX >= 2)
            }
        }
    }
    
    /// - 오답률 높은 단어 : 오답률이 50%를 넘는 단어
    private var highIncorrectRateWords: [Word] {
        let temp = words.filter {
            let incorrectRate: Double = Double($0.incorrectCount) / Double($0.incorrectCount + $0.correctCount)
            return incorrectRate >= 0.5
        }
        
        if temp.isEmpty {
            return []
        } else {
            return temp.sorted {
                let first: Double = Double($0.incorrectCount) / Double($0.incorrectCount + $0.correctCount)
                let second: Double = Double($1.incorrectCount) / Double($1.incorrectCount + $1.correctCount)
                return first > second
            }
        }
    }
    
    /// - 완벽히 외운 단어 : isMemorized == true
    private var perfectlyMemorizedWords: [Word] {
        words.filter { $0.isMemorized }
    }
    
    
    var body: some View {
        List {
            // MARK: 모든 단어 데이터
            NavigationLink {
                if UIDevice.current.model == "iPad" {
                    iPadWordsDetailDataView(words: words, navigationTitle: "모든 단어 데이터")
                } else {
                    iPhoneWordsDetailDataView(words: words, navigationTitle: "모든 단어 데이터")
                }
            } label: {
                HStack {
                    Image(systemName: "list.bullet.rectangle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.indigo)
                        .font(.largeTitle)
                    Text("모든 단어 데이터 보기")
                        .eachDeviceFontSize()
                }
            }
            .disabled(words.isEmpty)
            
            // MARK: 최근 자주 틀린 단어
            Section {
                if !frequentlyIncorrectedWords.isEmpty {
                    ForEach(frequentlyIncorrectedWords.prefix(5)) { word in
                        WordMeaningAndRecentResultsCell(word: word)
                    }
                } else {
                    Text("단어 시험 결과가 3개 이상 있어야 제공됩니다.")
                        .foregroundColor(.gray)
                }
            } header: {
                HStack {
                    Text("최근 자주 틀린 단어")
                        .offset(x: -15)
                    Spacer()
                    NavigationLink("더보기") {
                        if UIDevice.current.model == "iPad" {
                            iPadWordsDetailDataView(words: frequentlyIncorrectedWords, navigationTitle: "최근 자주 틀린 단어")
                        } else {
                            iPhoneWordsDetailDataView(words: frequentlyIncorrectedWords, navigationTitle: "최근 자주 틀린 단어")
                        }
                    }
                    .offset(x: 15)
                    .disabled(frequentlyIncorrectedWords.isEmpty)
                }
            }
            .headerProminence(.increased)
            
            // MARK: 자꾸 헷갈리는 단어
            Section {
                if !confusedWords.isEmpty {
                    ForEach(confusedWords.prefix(5)) { word in
                        WordMeaningAndRecentResultsCell(word: word)
                    }
                } else {
                    Text("단어 시험 결과가 5개 이상 있어야 제공됩니다.")
                        .foregroundColor(.gray)
                }
            } header: {
                HStack {
                    Text("자꾸 헷갈리는 단어")
                        .offset(x: -15)
                    Spacer()
                    NavigationLink("더보기") {
                        if UIDevice.current.model == "iPad" {
                            iPadWordsDetailDataView(words: confusedWords, navigationTitle: "자꾸 헷갈리는 단어")
                        } else {
                            iPhoneWordsDetailDataView(words: confusedWords, navigationTitle: "자꾸 헷갈리는 단어")
                        }
                    }
                    .offset(x: 15)
                    .disabled(confusedWords.isEmpty)
                }
            }
            .headerProminence(.increased)
            
            // MARK: 오답률 높은 단어
            Section {
                if !highIncorrectRateWords.isEmpty {
                    ForEach(highIncorrectRateWords.prefix(5)) { word in
                        WordMeaningAndIncorrectRateCell(word: word)
                    }
                } else {
                    Text("단어 시험 결과가 1개 이상 있어야 제공됩니다.")
                        .foregroundColor(.gray)
                }
            } header: {
                HStack {
                    Text("오답률 높은 단어")
                        .offset(x: -15)
                    Spacer()
                    NavigationLink("더보기") {
                        if UIDevice.current.model == "iPad" {
                            iPadWordsDetailDataView(words: highIncorrectRateWords, navigationTitle: "오답률 높은 단어")
                        } else {
                            iPhoneWordsDetailDataView(words: highIncorrectRateWords, navigationTitle: "오답률 높은 단어")
                        }
                    }
                    .offset(x: 15)
                    .disabled(highIncorrectRateWords.isEmpty)
                }
            }
            .headerProminence(.increased)
            
            // MARK: 완벽하게 외운 단어
            Section {
                if !perfectlyMemorizedWords.isEmpty {
                    ForEach(perfectlyMemorizedWords.prefix(5)) { word in
                        WordMeaningAndIncorrectRateCell(word: word)
                    }
                } else {
                    Text("단어 시험에서 5번 연속으로 정답 처리된 단어들이 포함됩니다.")
                        .foregroundColor(.gray)
                }
            } header: {
                HStack {
                    Text("완벽하게 외운 단어")
                        .offset(x: -15)
                    Spacer()
                    NavigationLink("더보기") {
                        if UIDevice.current.model == "iPad" {
                            iPadWordsDetailDataView(words: perfectlyMemorizedWords, navigationTitle: "완벽하게 외운 단어")
                        } else {
                            iPhoneWordsDetailDataView(words: perfectlyMemorizedWords, navigationTitle: "완벽하게 외운 단어")
                        }
                    }
                    .offset(x: 15)
                    .disabled(perfectlyMemorizedWords.isEmpty)
                }
            }
            .headerProminence(.increased)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("시험 결과 분석")
    }
}

// MARK: 단어:뜻 그리고 최근 시험결과를 보여주는 셀
struct WordMeaningAndRecentResultsCell: View {
    var word: Word
    
    var body: some View {
        HStack {
            Group {
                Text(word.word!)
                Text(":")
                Text(word.meaning!.joined(separator: ", "))
            }
            .eachDeviceFontSize()
            
            Spacer()
            
            // MARK: 최근 5번의 시험 결과
            HStack(spacing: 0) {
                ForEach(word.recentTestResults ?? [], id: \.self) { result in
                    switch result {
                    case "O":
                        Image(systemName: "circle")
                            .foregroundColor(.green)
                    case "X":
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    default:
                        Image(systemName: "minus")
                    }
                }
            }
        }
    }
}

// MARK: 단어:뜻 그리고 오답률을 보여주는 셀
struct WordMeaningAndIncorrectRateCell: View {
    var word: Word
    
    var incorrectAnswerRate: Double {
        Double(word.incorrectCount) / Double(word.correctCount + word.incorrectCount) * 100
    }
    
    var body: some View {
        HStack {
            Group {
                Text(word.word!)
                Text(":")
                Text(word.meaning!.joined(separator: ", "))
            }
            .eachDeviceFontSize()
            
            Spacer()
            
            // MARK: 최근 5번의 시험 결과
            HStack {
                Text("오답률 :").foregroundColor(.gray)
                Text("\(incorrectAnswerRate, specifier: "%.1f")%")
            }
        }
    }
}


struct MyNoteView_Previews: PreviewProvider {
    static var viewModel: KOWordListViewModel = KOWordListViewModel(service: WordListServiceImpl(coreDataRepo: CoreDataRepositoryImpl(context: PersistenceController.shared.container.viewContext), cloudDataRepo: CloudKitRepositoryImpl()))
    
    static var previews: some View {
        MyNoteView(words: viewModel.words)
    }
}
