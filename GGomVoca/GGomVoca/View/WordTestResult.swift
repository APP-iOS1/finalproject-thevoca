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
    let testType: String
    
    // 맞은 개수
    var correctCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
          if question.isCorrect == .Right { cnt += 1 }
        }
        return cnt
    }
    
    // 틀린 개수
    var incorrectCount: Int {
        var cnt: Int = 0
        for question in vm.testPaper {
          if question.isCorrect != .Right { cnt += 1 }
        }
        return cnt
    }
    
    // isMemorized 변경되는 단어 체크 표시 유무
    @State var checkLabel: Bool  = false
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 5) {
                    Text("걸린 시간")
                        .foregroundColor(.gray)
                    Text("\(vm.convertSecondsToTime(seconds: vm.timeCountUp))")
                        .font(.title2)
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("맞은 개수")
                        .foregroundColor(.gray)
                    Text("\(correctCount)")
                        .font(.title2)
                }
                .horizontalAlignSetting(.center)
                VStack(spacing: 5) {
                    Text("틀린 개수")
                        .foregroundColor(.gray)
                    Text("\(incorrectCount)")
                        .font(.title2)
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
                if checkLabel {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.clear)
                        .font(.body)
                }
            }
            .padding(.horizontal, 20)
            .background {
                Rectangle()
                    .fill(Color("fourseason"))
                    .frame(height: 30)
            }
            
            List(vm.testPaper) { paper in
                HStack {
                    switch testType {
                    case "word":
                      Image(systemName: paper.isCorrect == .Right ? "circle" : paper.isCorrect == .Half ? "triangle" : "xmark")
                        .foregroundColor(paper.isCorrect == .Right ? .green : paper.isCorrect == .Half ? .yellow : .red)
                            .font(.body)
                        VStack {
                            if !paper.answer!.isEmpty {
                                Text(paper.answer!)
                                    .strikethrough(paper.isCorrect == .Right ? false : true)
                            }
                            if paper.isCorrect != .Right {
                                Text(paper.word)
                                    .foregroundColor(.red)
                            }
                        }
                        .horizontalAlignSetting(.center)
                        Text(paper.meaning.joined(separator: ", "))
                            .horizontalAlignSetting(.center)
                        
                        if checkLabel {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(paper.isToggleMemorize ? .green : .clear)
                                .font(.body)
                        }
                        
                    case "meaning":
                      Image(systemName: paper.isCorrect == .Right ? "circle" : paper.isCorrect == .Half ? "triangle" : "xmark")
                        .foregroundColor(paper.isCorrect == .Right ? .green : paper.isCorrect == .Half ? .yellow : .red)
                            .font(.body)
                        Text(paper.word)
                            .horizontalAlignSetting(.center)
                        VStack {
                            if !paper.answer!.isEmpty {
                                Text(paper.answer!)
                                    .strikethrough(paper.isCorrect == .Right ? false : true)
                            }
                            if paper.isCorrect != .Right {
                                Text(paper.meaning.joined(separator: ", "))
                                    .foregroundColor(.red)
                            }
                        }
                        .horizontalAlignSetting(.center)
                        
                        if checkLabel {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(paper.isToggleMemorize ? .green : .clear)
                                .font(.body)
                        }
                        
                    default:
                        Text("Empty")
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { d in
                    d[.leading]
                }
                
            }
            .listStyle(.plain)
            .padding(.top, -10)
            
            Text("\(Image(systemName: "checkmark.circle.fill"))는 5번 연속 정답 처리된 단어입니다.")
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            if vm.testPaper.filter({ $0.isToggleMemorize == true }).count > 0 {
                checkLabel = true
            }
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
