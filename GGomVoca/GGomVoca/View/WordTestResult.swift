//
//  WordTestResult.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct WordTestResult: View {
    @Binding var isTestMode: Bool
    
    @ObservedObject var paperViewModel: TestViewModel
    let testMode: String
    
    var correctCount: Int {
        var cnt: Int = 0
        for question in paperViewModel.testPaper {
            if question.isCorrect == true { cnt += 1 }
        }
        return cnt
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isTestMode = false
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.medium)
                        Text("단어장으로 돌아가기")
                    }
                    .padding(.leading, 8)
                    .padding(.vertical, 5)
                }
                Spacer()
                Text("\(correctCount) / \(paperViewModel.wholeQuestionNum)")
                    .padding(.trailing, 8)
            }
            
            List {
                Section {
                    ForEach(paperViewModel.testPaper) { paper in
                        HStack {
                            switch testMode {
                            case "word":
                                Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
                                    .foregroundColor(.red)
                                Text(paper.answer ?? "")
                                    .horizontalAlignSetting(.center)
                                Text(paper.meaning)
                                    .horizontalAlignSetting(.center)
                            case "meaning":
                                Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
                                    .foregroundColor(.red)
                                Text(paper.word)
                                    .horizontalAlignSetting(.center)
                                Text(paper.answer ?? "")
                                    .horizontalAlignSetting(.center)
                            default:
                                Text("Empty")
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text(Image(systemName: "circle"))
                            .foregroundColor(.clear)
                        Text("단어")
                            .horizontalAlignSetting(.center)
                        Text("뜻")
                            .horizontalAlignSetting(.center)
                    }
                }

                
            }
            .listStyle(.plain)
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

//struct WordTestResult_Previews: PreviewProvider {
//    static var previews: some View {
//        WordTestResult()
//    }
//}
