//
//  iPadAllWordsDataView.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/14.
//

import SwiftUI

struct iPadWordsDetailDataView: View {
    // MARK: SuperView Property
    var words: [Word]
    var navigationTitle: String
    
    // MARK: View Properties
    @State private var sorting: SortOrders = .createdAt
    
    var sortedWord: [Word] {
        get {
            switch sorting {
            case .createdAt:
                return words.sorted { $0.createdAt ?? "" < $1.createdAt ?? "" }
            case .dictionary:
                return words.sorted { $0.word ?? "" < $1.word ?? "" }
            case .incorrectRate:
                return words.sorted {
                    let first: Double = Double($0.incorrectCount) / Double($0.correctCount + $0.incorrectCount) * 100
                    let second: Double = Double($1.incorrectCount) / Double($1.correctCount + $1.incorrectCount) * 100
                    
                    return first > second
                }
            case .correctRate:
                return words.sorted {
                    let first: Double = Double($0.correctCount) / Double($0.correctCount + $0.incorrectCount) * 100
                    let second: Double = Double($1.correctCount) / Double($1.correctCount + $1.incorrectCount) * 100
                    
                    return first > second
                }
            case .isMemorized:
                return words.sorted {  $0.isMemorized.hashValue > $1.isMemorized.hashValue }
            }
        }
    }
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HeaderCell(geo: geo)

                List(sortedWord) { word in
                    iPadDataCell(word: word, geo: geo)
                }
                .listStyle(.plain)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("정렬", selection: $sorting) {
                        ForEach(SortOrders.allCases, id: \.rawValue) { order in
                            Text(order.rawValue).tag(order)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }
}

struct HeaderCell: View {
    var geo: GeometryProxy
    
    var body: some View {
        HStack(spacing: 8) {
            Group {
                Text("")
                Text("단어")
                    .frame(width: geo.size.width / 5, alignment: .center)
                
                Rectangle().frame(width: 1).foregroundColor(Color("fourseason"))
                
                Text("뜻")
                    .frame(width: geo.size.width / 5, alignment: .center)
                Rectangle().frame(width: 1).foregroundColor(Color("fourseason"))
            }
            Text("최근 본 시험 결과")
                .frame(width: geo.size.width / 5, alignment: .center)
            
            Rectangle().frame(width: 1).foregroundColor(Color("fourseason"))
            Group {
                Text("오답률")
                    .frame(width: geo.size.width / 10, alignment: .center)
                Rectangle().frame(width: 1).foregroundColor(Color("fourseason"))
                Text("정답률")
                    .frame(width: geo.size.width / 10, alignment: .center)
            }
            Rectangle().frame(width: 1).foregroundColor(Color("fourseason"))
            Text("암기 상태")
                .frame(width: geo.size.width / 10, alignment: .center)
        }
        .font(.headline)
        .foregroundColor(.gray)
        .frame(width: geo.size.width, height: 30)
        .padding(.vertical, 10)
        .background { Color("fourseason") }
    }
}

fileprivate struct iPadDataCell: View {
    var word: Word
    var geo: GeometryProxy
    
    var incorrectAnswerRate: Double {
        Double(word.incorrectCount) / Double(word.correctCount + word.incorrectCount) * 100
    }
    var correctAnswerRate: Double {
        Double(word.correctCount) / Double(word.correctCount + word.incorrectCount) * 100
    }
    
    var body: some View {
        HStack {
            // MARK: 단어와 뜻
            Group {
                Text("")
                Text(word.word ?? "")
                    .frame(width: geo.size.width / 5, alignment: .center)
                    .multilineTextAlignment(.center)
                
                VLine()
                
                Text(word.meaning?.joined(separator: ", ") ?? "")
                    .frame(width: geo.size.width / 5, alignment: .center)
                    .multilineTextAlignment(.center)
                
                VLine()
            }
            
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
            .frame(width: geo.size.width / 5, alignment: .center)
            
            VLine()
            
            // MARK: 오답률과 정답률
            Group {
                Text("\(incorrectAnswerRate, specifier: "%.1f")%")
                    .frame(width: geo.size.width / 10, alignment: .center)
                VLine()
                Text("\(correctAnswerRate, specifier: "%.1f")%")
                    .frame(width: geo.size.width / 10, alignment: .center)
            }
            
            VLine()
            
            // MARK: 암기여부
            if word.isMemorized {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: geo.size.width / 10, alignment: .center)
            } else {
                Image(systemName: "circle.dashed")
                    .foregroundColor(.gray)
                    .frame(width: geo.size.width / 10, alignment: .center)
            }
        }
        .font(.title3)
    }
}

struct AllWordsDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            iPadWordsDetailDataView(words: [], navigationTitle: "")
        }
    }
}
