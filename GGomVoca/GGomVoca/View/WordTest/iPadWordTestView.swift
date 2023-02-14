//
//  iPadWordTestView.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/01.
//

import SwiftUI

// TODO: 아이패드 단어시험
// [] "word", "meaning"에 따라 switch로 분기
// [] isMemorized가 false면 못외운 단어만 시험 보기

struct iPadWordTestView: View {
    // 시험지 fullscreen 닫기 위한 Property
    @Binding var isTestMode: Bool
    
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    @StateObject var vm: WordTestViewModel = WordTestViewModel()
    
    // MARK: SuperView Properties
    let testType: String
    let isWholeWord: Bool
    
    // MARK: View Properties
    @State private var answers: [String] = []
    
    var timer: String {
        vm.timeRemaining == -1 ? "⏰ 시험 종료" : vm.convertSecondsToTime(seconds: vm.timeRemaining)
    }
    
    
    // 시험 종료 후 결과지로 이동하기 위한 Property
    @State var isFinished: Bool = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(vm.testPaper.indices, id: \.self) { index in
                        VStack(spacing: 0) {
                            HStack(alignment: .center) {
                                Text(testType == "meaning" ? vm.testPaper[index].word : vm.testPaper[index].meaning.joined(separator: ", "))
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 200, height: 80)
                                Divider()
                                TextField("", text: $answers[index], axis: .vertical)
                                    .font(.title3)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding(.vertical)
                            }
                            
                            Divider()
                        }
                    }
                } header: {
                    VStack(spacing:10) {
                        Divider()
                        
                        HStack {
                            if testType == "word" {
                                Text("입력 언어를 해당 하는 언어로 변경하고,")
                            }
                            
                            Text("펜슬로 빈 칸에 답을 적어주세요.")
                            
                        }
                        
                        if testType == "meaning" {
                            Text("뜻이 여러 개인 경우 ,(쉼표)로 구분해 주세요.")
                        }
                        
                        Divider()
                    }
                    .background { Color("offwhite") }
                } footer: {
                    VStack(spacing:0) {
                        Divider()
                        Text("우상단의 제출버튼을 눌러주세요.").padding(10)
                        Divider()
                    }
                }
            }
        }
        .background { Color("offwhite") }
        .navigationTitle("\(timer)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            vm.getVocabulary(vocabularyID: vocabularyID)
            vm.createPaper(isWholeWord: isWholeWord)
            answers = Array(repeating: "", count: vm.testPaper.count)
            vm.startiPadTimer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("제출") {
                    for idx in answers.indices {
                        if answers[idx].isEmpty {
                            vm.saveAnswer(answer: "")
                        } else {
                            vm.saveAnswer(answer: answers[idx])
                        }
                        vm.showNextQuestion()
                    }
                    // 타이머 종료
                    vm.cancelTimer()
                    // 문제지 채점
                    vm.gradeTestPaper(testType: testType)
                    vm.testResult()
                    isFinished = true
                }
                .navigationDestination(isPresented: $isFinished) {
                    WordTestResultView(isTestMode: $isTestMode, vm: vm, testType: testType)
                }
            }
        }
    }
}

//struct iPadWordTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            iPadWordTestView()
//        }
//    }
//}
