//
//  WordTestResult.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct WordTestResult: View {
    @Binding var isTestMode: Bool
    
    @ObservedObject var vm: TestViewModel
    let testMode: String
    
    var correctCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
            if question.isCorrect == true { cnt += 1 }
        }
        return cnt
    }
    
    var incorrectCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
            if question.isCorrect == false { cnt += 1 }
        }
        return cnt
    }
    
    var body: some View {
        VStack {
//            HStack {
//                Button {
//                    isTestMode = false
//                } label: {
//                    HStack(spacing: 5) {
//                        Image(systemName: "chevron.backward")
//                            .font(.title2)
//                            .fontWeight(.medium)
//                        Text("단어장으로 돌아가기")
//                    }
//                    .horizontalAlignSetting(.leading)
//                    .padding(.leading, 8)
//                    .padding(.top, 5)
//                }
//
//            }
            
            HStack {
                VStack(spacing: 5) {
                    Text("걸린 시간")
                        .bold()
                    Text("\(vm.convertSecondsToTime(seconds: vm.timeCountUp))")
                        .foregroundColor(.gray)
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("맞은 개수")
                        .bold()
                    Text("\(correctCount)")
                        .foregroundColor(.gray)
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("틀린 개수")
                        .bold()
                    Text("\(incorrectCount)")
                        .foregroundColor(.gray)
                }
                .horizontalAlignSetting(.center)
            }
            .padding(.vertical, 15)
            
            List {
                Section {
                    ForEach(vm.testPaper) { paper in
                        HStack {
                            switch testMode {
                            case "word":
                                Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
//                                    .frame(width: 40)
                                    .foregroundColor(.red)
                                Text(paper.answer ?? "")
                                    .horizontalAlignSetting(.center)
                                Text(paper.meaning)
                                    .horizontalAlignSetting(.center)
                            case "meaning":
                                Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
//                                    .frame(width: 40)
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
//                        Text("\(correctCount) / \(paperViewModel.wholeQuestionNum)")
//                            .frame(width: 40)
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
        .navigationTitle("시험 결과")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isTestMode = false
                } label: {
                    Text("확인")
                }

            }
        }
    }
}

//struct WordTestResult_Previews: PreviewProvider {
//    static var previews: some View {
//        WordTestResult()
//    }
//}
