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
    @Environment(\.colorScheme) private var colorScheme
    
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
        
    var body: some View {
        VStack {
            Text("\(Image(systemName: "clock")) \(timer)")
                .horizontalAlignSetting(.center)
                .foregroundColor(vm.timeRemaining < 4 ? .red : colorScheme == .light ? .black : .white)
            
            Spacer()
            
            if !vm.testPaper.isEmpty {
                Text(vm.showQuestion(testType: testType))
                    .font(.largeTitle)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            if vm.isLastQuestion {
                Text("\(Image(systemName: "exclamationmark.circle")) 마지막 문제입니다.\n완료 버튼을 누르면 시험지가 자동 제출됩니다.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
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
                        vm.nextActions(answer: answer)
                        answer.removeAll()
                        focusedField = .answer
                    } else {
                        focusedField = .answer
                    }
                }
                .disabled(timeOver||isExistLastAnswer)
        }
        .onAppear {
            vm.testType = testType
            vm.getVocabulary(vocabularyID: vocabularyID)
            vm.createPaper(isWholeWord: isWholeWord)
            vm.startTimer()
            focusedField = .answer
        }
        .navigationTitle("\(vm.currentQuestionNum + 1) / \(vm.testPaper.count)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $vm.isFinished) {
            WordTestResult(isTestMode: $isTestMode, vm: vm, testType: testType)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.nextActions(answer: "")
                    answer.removeAll()
                    focusedField = .answer
                } label: {
                    Text("pass")
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
