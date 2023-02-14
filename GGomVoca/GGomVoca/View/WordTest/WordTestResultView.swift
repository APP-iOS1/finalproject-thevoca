//
//  WordTestResultView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct WordTestResultView: View {
    // 시험지 fullscreen 닫기 위한 Property
    @Binding var isTestMode: Bool
    
    // MARK: Data Properties
    @ObservedObject var vm: WordTestViewModel
    let testType: String
    
    // isMemorized 변경되는 단어 체크 표시 유무
    @State var checkLabel: Bool  = false
    
    var body: some View {
        VStack {
            ResultSummary(vm: vm)
                .padding(.vertical, 15)
            
            VStack(spacing: 0) {
                ListHeader(checkLabel: $checkLabel)
                ListContent(testPaper: vm.testPaper, testType: testType, checkLabel: $checkLabel)
            }
            
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
            ToolbarItem(placement: .bottomBar) {
                Text("\(Image(systemName: "checkmark.circle.fill"))는 5번 연속 정답 처리된 단어입니다.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .multilineTextAlignment(.center)
            }
        }
        
    }
}

struct ResultSummary: View {
    @ObservedObject var vm: WordTestViewModel
    
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
    
    var body: some View {
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
    }
}

struct ListHeader: View {
    @Binding var checkLabel: Bool
    
    var body: some View {
        HStack {
            Text(Image(systemName: "circle"))
                .foregroundColor(.clear)

            Text("문제")
                .headerText()
            Text("답")
                .headerText()

            if checkLabel {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.clear)
                    .font(.body)
            }
        }
        .padding(.horizontal, 20)
        .background {
            Rectangle()
            .fill(Color("toolbarbackground"))
            .frame(height: 30)
        }
    }
}

struct ListContent: View {
    let testPaper: [Question]
    let testType: String
    @Binding var checkLabel: Bool
    
    var body: some View {
        List {
            Section {
                ForEach(testPaper) { paper in
                    ListCell(paper: paper, testType: testType, checkLabel: $checkLabel)
                        .alignmentGuide(.listRowSeparatorLeading) { d in
                                d[.leading]
                            }
                        .frame(minHeight: 40)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct ListCell: View {
    let paper: Question
    let testType: String
    
    @Binding var checkLabel: Bool
    
    var body: some View {
        HStack {
            Image(systemName: paper.isCorrect == .Right ? "circle" : paper.isCorrect == .Half ? "triangle" : "xmark")
                .foregroundColor(paper.isCorrect == .Right ? .green : paper.isCorrect == .Half ? .yellow : .red)
                .eachDeviceFontSize()
            
            switch testType {
            case "word":
                Text(paper.meaning.joined(separator: ", "))
                    .horizontalAlignSetting(.center)

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
            case "meaning":
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
            default:
                EmptyView()
            }
            
            if checkLabel {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(paper.isToggleMemorize ? .green : .clear)
                    .eachDeviceFontSize()
            }
        }
        .eachDeviceFontSize()
    }
}
