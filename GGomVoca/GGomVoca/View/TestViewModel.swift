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
    var meaning: [String]
    var answer: String?
    var isCorrect: Result = .Wrong
}

final class TestViewModel: ObservableObject {
    // MARK: CoreData ViewContext
    var viewContext = PersistenceController.shared.container.viewContext
    var coreDataRepository = CoredataRepository()
    
    // MARK: Vocabulary Properties
    var selectedVocabulary: Vocabulary = Vocabulary()
    @Published var words: [Word] = []
    
    @Published var testPaper: [Question] = []
    // 현재 풀고 있는 문제 번호
    var currentQuestionNum: Int = 0
    // 전체 문제 수
    var wholeQuestionNum: Int {
        testPaper.count
    }
    
    var timer: AnyCancellable?
    let timeLimit = 15
    @Published var timeRemaining : Int = 0
    var timeCountUp: Int = 0
    
    // MARK: saveContext
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - 일치하는 id의 단어장 불러오기
    func getVocabulary(vocabularyID: Vocabulary.ID) {
        selectedVocabulary = coreDataRepository.getVocabularyFromID(vocabularyID: vocabularyID ?? UUID())
        let allWords = selectedVocabulary.words?.allObjects as? [Word] ?? []
        words = allWords.filter { $0.deletedAt == "" || $0.deletedAt == nil }
    }
    
    // MARK: - 시험지 생성
    func createPaper(isWholeWord: Bool) {
        for word in words {
            if isWholeWord {
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
    func showQuestion(testType: String) -> String {
        switch testType {
        case "word":
          return testPaper[currentQuestionNum].meaning.joined(separator: ", ")
        case "meaning":
            return testPaper[currentQuestionNum].word
        default:
            return "Empty"
        }
    }
    
    // MARK: - 답변 저장
    func saveAnswer(answer: String) {
        testPaper[currentQuestionNum].answer = answer
    }
    
    // MARK: - 다음 문제 보여주기
    func showNextQuestion() {
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
    func gradeTestPaper(testType: String) {


      for idx in testPaper.indices {
            switch testType {
            case "word":
                if testPaper[idx].word == testPaper[idx].answer {
                  testPaper[idx].isCorrect = .Right
                } else {
                  testPaper[idx].isCorrect = .Wrong
                }
            case "meaning":
              // MARK: Tmp print
              print("meaning : \(testPaper[idx].meaning)")
              print("answer : \(testPaper[idx].answer?.components(separatedBy: ","))")
              // MARK: white space trim
              var trimmedAnswer = testPaper[idx].answer?.components(separatedBy: ",")
              for i in trimmedAnswer!.indices {
                trimmedAnswer![i] = trimmedAnswer![i].trimmingCharacters(in: .whitespaces)
              }
              print("trimmedAnswer : \(trimmedAnswer)")
              print("result : \(testPaper[idx].meaning.containsSameElements(as: trimmedAnswer!))")
              if testPaper[idx].meaning.containsSameElements(as: trimmedAnswer!) == .Right {
                testPaper[idx].isCorrect = .Right
                } else if testPaper[idx].meaning.containsSameElements(as: trimmedAnswer!) == .Wrong {
                  testPaper[idx].isCorrect = .Wrong
                } else {
                  testPaper[idx].isCorrect = .Half
                }
            default:
                print("default")
            }
        }
    }
    
    // MARK: - Core Data에 시험결과 저장
    func testResult() {
        for word in words {
            // 처음 시험을 보는 단어장의 경우 recentTestResults가 nil이므로 빈 배열 생성
            if word.recentTestResults == nil {
                word.recentTestResults = []
            } else {
                // nil이 아닐 때 element가 5개 이상이라면
                if word.recentTestResults!.count >= 5 {
                    word.recentTestResults!.removeFirst()
                }
            }
            // 시험 본 단어 update
            if let tempWord = testPaper.filter({ $0.word == word.word }).first {
                print("[test!] \(tempWord)")
                if tempWord.isCorrect == .Right {
                    word.recentTestResults?.append("O")
                    word.correctCount += 1
                } else {
                    word.recentTestResults?.append("X")
                    word.incorrectCount += 1
                }
            } else {
                // 시험 안 본 단어 update
                print("[isMemorized] \(word)")
                word.recentTestResults?.append("-")
            }
            // 최근 시험 결과가 전부 O이면 외운 단어라고 판단
            if (word.recentTestResults?.filter({ $0 == "O" }).count)! >= 5 {
                word.isMemorized = true
            }
        }
        saveContext()
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
                        self.cancelTimer()
                    } else {
                        self.saveAnswer(answer: "")
                        self.showNextQuestion()
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
        self.timeCountUp += (timeLimit - timeRemaining)
        timer?.cancel()
    }
    
    func convertSecondsToTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}


