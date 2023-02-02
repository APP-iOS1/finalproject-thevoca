//
//  iPhoneWordTestView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

enum Field: Hashable {
    case answer
}

struct iPhoneWordTestView: View {
    // 시험지 fullscreen 닫기 위한 Property
    @Binding var isTestMode: Bool
    
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    @ObservedObject var viewModel: JPWordListViewModel
    @StateObject var paperViewModel: TestViewModel = TestViewModel()
    
    // MARK: Test Mode에 관한 Properties
    let testMode: String
    let isMemorized: Bool
    
    // MARK: TextField에 관한 Properties
    @FocusState private var focusedField: Field?
    @State var answer: String = ""
    // testMode에 따른 placeholder
    var textFieldPlaceHolder: String {
        switch testMode {
        case "word":
            return "단어를 입력해주세요"
        case "meaning":
            return "뜻을 입력해주세요"
        default:
            return ""
        }
    }
    
    var timer: String {
        paperViewModel.timeRemaining == -1 ? "⏰ Time Over" : paperViewModel.convertSecondsToTime()
    }
    var timeOver: Bool {
        paperViewModel.timeRemaining == -1 ? true : false
    }
    
    var isExsisLastAnswer: Bool {
        paperViewModel.testPaper.last?.answer != nil ? true : false
    }
    
    // 시험 종료 후 결과지로 이동하기 위한 Property
    @State var isFinished: Bool = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if !paperViewModel.testPaper.isEmpty {
                Text(paperViewModel.showQuestion(testMode: testMode))
                    .font(.largeTitle)
            }
            
            Spacer()
            
            TextField("\(textFieldPlaceHolder)", text: $answer)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .answer)
                .onSubmit {
                    paperViewModel.saveAnswer(answer: answer)
                    answer.removeAll()
                    if !paperViewModel.showSubmitButton() {
                        paperViewModel.restartTimer()
                    }
                    paperViewModel.showNextQuestion()
                    focusedField = .answer
                }
                .disabled(timeOver||isExsisLastAnswer)
        }
        .onAppear {
            paperViewModel.createPaper(words: viewModel.words, isMemorized: isMemorized)
            paperViewModel.startTimer()
            focusedField = .answer
        }
        .navigationTitle("\(timer)")
        .toolbar {
            // 마지막 문제일 때는 제출 버튼
            if paperViewModel.showSubmitButton() {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if paperViewModel.testPaper.last?.answer == nil {
                            paperViewModel.saveAnswer(answer: answer)
                        }
                        // 타이머 종료
                        paperViewModel.cancelTimer()
                        // 문제지 채점
                        paperViewModel.gradeTestPaper(testMode: testMode)
                        isFinished = true
                    } label: {
                        Text("제출")
                    }
                    .navigationDestination(isPresented: $isFinished) {
                        WordTestResult(isTestMode: $isTestMode, paperViewModel: paperViewModel, testMode: testMode)
                    }
                }
                // 마지막 문제가 아닐 때는 PASS 버튼
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        paperViewModel.saveAnswer(answer: "")
                        paperViewModel.showNextQuestion()
                        answer.removeAll()
                        paperViewModel.restartTimer()
                        focusedField = .answer
                    } label: {
                        Text("PASS")
                    }
                    
                }
            }
        }
    }
}

//struct iPhoneWordTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        iPhoneWordTestView(vocabularyID: UUID(uuidString: "64883267-186C-4053-A38E-940E6F6E7B41"), viewModel: JPWordListViewModel(), testMode: "meaning", isMemorized: true)
//    }
//}
