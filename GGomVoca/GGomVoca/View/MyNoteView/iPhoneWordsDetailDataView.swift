//
//  iPhoneAllWordsDataView.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/15.
//

import SwiftUI

struct iPhoneWordsDetailDataView: View {
    // MARK: SuperView Property
    var words: [Word]
    var navigationTitle: String
    
    // MARK: View Properties
    @State private var sorting: SortOrders = .createdAt
    
    var sortedWord: [Word] {
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
    
    var body: some View {
        List(sortedWord) { word in
            iPhoneDataCell(word: word)
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

fileprivate struct iPhoneDataCell: View {
    var word: Word
    
    private var incorrectAnswerRate: Double {
        Double(word.incorrectCount) / Double(word.correctCount + word.incorrectCount) * 100
    }
    
    private var correctAnswerRate: Double {
        Double(word.correctCount) / Double(word.correctCount + word.incorrectCount) * 100
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 7) {
                // MARK: 단어와 뜻
                HStack {
                    Text(word.word ?? "")
                    Text(":")
                    Text(word.meaning?.joined(separator: ", ") ?? "")
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                
                // MARK: 최근 본 시험 결과
                HStack {
                    Text("최근 본 시험 결과 :")
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                
                // MARK: 오답률, 정답률
                HStack {
                    Text("오답률 :")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(incorrectAnswerRate, specifier: "%.1f")%,")
                    Text("정답률 :")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(correctAnswerRate, specifier: "%.1f")%")
                }
            }
            
            Spacer()
            
            // MARK: 암기여부
            if word.isMemorized {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title)
            } else {
                Image(systemName: "circle.dashed")
                    .foregroundColor(.gray)
                    .font(.title)
            }
        }
    }
}

struct iPhoneAllWordsDataView_Previews: PreviewProvider {
    static var previews: some View {
        iPhoneWordsDetailDataView(words: [], navigationTitle: "")
    }
}
