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
    @StateObject var vm: TestViewModel = TestViewModel()
    
    // MARK: Test Mode에 관한 Properties
    let testType: String
    let isWholeWord: Bool
    
    // MARK: TextField에 관한 Properties
    @FocusState private var focusedField: Field?
    @State var answer: String = ""
    
    // testType에 따른 textField placeholder
    var textFieldPlaceHolder: String {
        switch testType {
        case "word":
            return "단어를 입력해주세요"
        case "meaning":
            return "뜻을 입력해주세요"
        default:
            return ""
        }
    }
    // TextField disable에 관한 Properties
    var timeOver: Bool {
        vm.timeRemaining == -1 ? true : false
    }
    
    var isExistLastAnswer: Bool {
        vm.testPaper.last?.answer != nil ? true : false
    }
    
    // MARK: Timer에 관한 Property
    var timer: String {
        vm.timeRemaining == -1 ? "⏰ 시험 종료" : vm.convertSecondsToTime(seconds: vm.timeRemaining)
    }
    
    // 시험 종료 후 결과지로 이동하기 위한 Property
    @State var isFinished: Bool = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if !vm.testPaper.isEmpty {
                Text(vm.showQuestion(testType: testType))
                    .font(.largeTitle)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            
            Spacer()
            
            if timeOver||isExistLastAnswer {
                Text("\(Image(systemName: "exclamationmark.circle")) 우상단의 제출 버튼을 눌러주세요")
            }
            TextField("\(textFieldPlaceHolder)", text: $answer)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .focused($focusedField, equals: .answer)
                .submitLabel(.done)
                .onSubmit {
                    if !answer.isEmpty {
                        // 마지막 문제일 경우 답변 저장만 함
                        vm.saveAnswer(answer: answer)
                        // 마지막 문제가 아닌 경우
                        if !isExistLastAnswer {
                            vm.showNextQuestion()
                            answer.removeAll()
                            vm.restartTimer()
                            focusedField = .answer
                        }
                    } else {
                        focusedField = .answer
                    }
                }
                .disabled(timeOver||isExistLastAnswer)
        }
        .onAppear {
            vm.getVocabulary(vocabularyID: vocabularyID)
            vm.createPaper(isWholeWord: isWholeWord)
            vm.startTimer()
            focusedField = .answer
        }
        .navigationTitle("\(timer)")
        .toolbar {
            // 마지막 문제까지 제출하거나 제한 시간이 끝난 경우 제출 버튼 나옴
            if isExistLastAnswer || vm.timeRemaining == -1 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 마지막 submit 안하고 timeover된 경우
                        if vm.testPaper.last?.answer == nil {
                            vm.saveAnswer(answer: "")
                        }
                        // 타이머 종료
                        vm.cancelTimer()
                        // 문제지 채점
                        vm.gradeTestPaper(testType: testType)
                        vm.testResult()
                        isFinished = true
                    } label: {
                        Text("제출")
                    }
                    .navigationDestination(isPresented: $isFinished) {
                        WordTestResult(isTestMode: $isTestMode, vm: vm, testType: testType)
                    }
                }
                // 마지막 문제가 아닐 때는 PASS 버튼
            } else {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.saveAnswer(answer: "")
                        vm.showNextQuestion()
                        answer.removeAll()
                        if !isExistLastAnswer {
                            vm.restartTimer()
                        }
                        focusedField = .answer
                    } label: {
                        Text("pass")
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
