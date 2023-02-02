//
//  TestViewModel.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/02.
//

import Foundation
import Combine

struct Question: Identifiable {
    var id: UUID
    var word: String
    var meaning: String
    var answer: String?
    var isCorrect: Bool = false
}

class TestViewModel: ObservableObject {
    @Published var testPaper: [Question] = []
    // 현재 풀고 있는 문제 번호
    var currentQuestionNum: Int = 0
    // 전체 문제 수
    var wholeQuestionNum: Int {
        testPaper.count
    }
    
    var timer: AnyCancellable?
    let timeLimit = 3
    @Published var timeRemaining : Int = 0
    
    
    // MARK: - 시험지 생성
    func createPaper(words: [Word], isMemorized: Bool) {
        for word in words {
            if isMemorized {
                // 모든 단어 시험지에 추가
                testPaper.append(Question(id: word.id!, word: word.word!, meaning: word.meaning!))
            } else {
                // isMemorized가 false인 단어만 시험지에 추가
                if !word.isMemorized {
                    testPaper.append(Question(id: word.id!, word: word.word!, meaning: word.meaning!))
                }
            }
        }
    }
    
    // MARK: - 문제 출제
    func showQuestion(testMode: String) -> String {
        switch testMode {
        case "word":
            return testPaper[currentQuestionNum].meaning
        case "meaning":
            return testPaper[currentQuestionNum].word
        default:
            return "Empty"
        }
    }
    
    // MARK: - 답변 저장
    func saveAnswer(answer: String) {
        testPaper[currentQuestionNum].answer = answer
        // 문제가 남았다면 다음 문제로
        if currentQuestionNum + 1 < wholeQuestionNum {
            currentQuestionNum += 1
        }
    }
    
    // MARK: - 제출 버튼 여부
    func showSubmitButton() -> Bool {
        currentQuestionNum + 1 == testPaper.count
    }
    
    // MARK: - 시험지 채점
    func gradeTestPaper(testMode: String) {
        for idx in 0..<testPaper.count {
            switch testMode {
            case "word":
                if testPaper[idx].word == testPaper[idx].answer {
                    testPaper[idx].isCorrect = true
                } else {
                    testPaper[idx].isCorrect = false
                }
            case "meaning":
                if testPaper[idx].meaning == testPaper[idx].answer {
                    testPaper[idx].isCorrect = true
                } else {
                    testPaper[idx].isCorrect = false
                }
            default:
                print("default")
            }
        }
    }
    
    // MARK: - Timer 관련 메서드
    func startTimer() {
        timeRemaining = timeLimit
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.timeRemaining -= 1
                if self.timeRemaining < 0 {
                    if self.currentQuestionNum >= self.wholeQuestionNum - 1 {
                        self.saveAnswer(answer: "")
                        self.cancelTimer()
                    } else {
                        self.saveAnswer(answer: "")
                        self.restartTimer()
                    }
                }
            }
    }
    
    func restartTimer() {
        cancelTimer()
        startTimer()
    }
    
    func cancelTimer() {
        timer?.cancel()
    }
    
    func convertSecondsToTime() -> String {
        let minutes = self.timeRemaining / 60
        let seconds = self.timeRemaining % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
