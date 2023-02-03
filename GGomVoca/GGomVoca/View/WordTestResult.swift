//
//  WordTestResult.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct WordTestResult: View {
    // 시험지 fullscreen 닫기 위한 Property
    @Binding var isTestMode: Bool
    
    // MARK: Data Properties
    @ObservedObject var vm: TestViewModel
    let testMode: String
    
    // 맞은 개수
    var correctCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
          if question.isCorrect == .Right { cnt += 1 }
        }
        return cnt
    }
    
    //틀린 개수
    var incorrectCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
          if question.isCorrect != .Right { cnt += 1 }
        }
        return cnt
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 5) {
                    Text("걸린 시간")
                        .foregroundColor(.gray)
                    Text("\(vm.convertSecondsToTime(seconds: vm.timeCountUp))")
                        .bold()
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("맞은 개수")
                        .foregroundColor(.gray)
                    Text("\(correctCount)")
                        .bold()
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("틀린 개수")
                        .foregroundColor(.gray)
                    Text("\(incorrectCount)")
                        .bold()
                }
                .horizontalAlignSetting(.center)
            }
            .padding(.vertical, 15)
            
            HStack {
                Text(Image(systemName: "circle"))
                    .foregroundColor(.clear)
                Text("단어")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.secondary)
                    .horizontalAlignSetting(.center)
                Text("뜻")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.secondary)
                    .horizontalAlignSetting(.center)
            }
            .padding(.horizontal, 20)
            .background {
                Rectangle()
                    .fill(Color("fourseason"))
                    .frame(height: 30)
            }
            
            List(vm.testPaper) { paper in
                HStack {
                    switch testMode {
                    case "word":
                      Image(systemName: paper.isCorrect == .Right ? "circle" : paper.isCorrect == .Half ? "triangle" : "xmark")
                        .foregroundColor(paper.isCorrect == .Right ? .green : paper.isCorrect == .Half ? .yellow : .red)
                            .font(.body)
                        Text(paper.answer ?? "")
                            .horizontalAlignSetting(.center)
                        Text(paper.meaning.joined(separator: ", "))
                            .horizontalAlignSetting(.center)
                    case "meaning":
                      Image(systemName: paper.isCorrect == .Right ? "circle" : paper.isCorrect == .Half ? "triangle" : "xmark")
                        .foregroundColor(paper.isCorrect == .Right ? .green : paper.isCorrect == .Half ? .yellow : .red)
                            .font(.body)
                        Text(paper.word)
                            .horizontalAlignSetting(.center)
                        Text(paper.answer ?? "")
                            .horizontalAlignSetting(.center)
                    default:
                        Text("Empty")
                    }
                }
                
            }
            .listStyle(.plain)
            .padding(.top, -10)
            
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
