//
//  SpeechSynthesizer.swift
//  GGomVoca
//
//  Created by 고도 on 2023/02/03.
//

import AVFoundation
import Foundation

enum SpeechType {
    case single
    case many
}

protocol TTSProtocol {
    /// 단어 하나를 읽어주는 메서드
    func speakWordAndMeaning(_ word: Word, to language: String, _ type: SpeechType)
    
    /// 여러개의 단어를 읽어주는 메서드
    func speakWordsAndMeanings(_ words: [Word], to language: String)
    
    /// 단어 읽기를 멈추는 메서드
    func stopSpeaking()
}

final class SpeechSynthesizer: NSObject, ObservableObject, TTSProtocol {
    // 싱글톤으로 정의
    private var instance: AVSpeechSynthesizer? = AVSpeechSynthesizer()
    
    // 단어와 의미 사이의 간격 (같은 단어 내에서)
    private let intervalOfWordAndMeaning = 0.3
    
    // 의미와 의미 사이의 간격 (같은 단어 내에서)
    private let intervalOfMeaningAndMeaning = 0.1
    
    // 단어와 단어 사이의 간격 (다른 단어끼리)
    private let intervalOfWordAndWord = 0.5
    
    // TODO: - 사용자가 설정한 언어에 따라 동적으로 뱌뀌는 코드 추가
    private let meaningUtteranceLanguage = "ko-KR"
    
    // 재생할 단어의 개수를 저장
    private var totalWordsCount: Int = 0
    private var spokenWordsCount: Int = 1
    
    // 단어 듣기의 재생 여부를 확인
    @Published var isPlaying = false
    
    override init() {
        super.init()
        instance?.delegate = self
    }
    
    /// 단어 하나를 읽어주는 메서드
    func speakWordAndMeaning(_ word: Word, to language: String, _ type: SpeechType) {
        if instance == nil {
            instance = AVSpeechSynthesizer()
            instance?.delegate = self
        }
        
        let wordUtterance = AVSpeechUtterance(string: word.word ?? "") // TTS로 들려줄 단어 설정
        wordUtterance.voice = AVSpeechSynthesisVoice(language: language) // 언어 설정
        wordUtterance.postUtteranceDelay = intervalOfWordAndMeaning // 다음 단어와의 시간 간격 설정
        instance?.speak(wordUtterance) // TTS 작동
        
        if type == SpeechType.single { return } // contextMenu로 접근한 경우
        
        // meaning 타입이 [String?]라서 순회하는 방식으로 구현
        word.meaning?.forEach { meaning in
            let meaningUtterance = AVSpeechUtterance(string: meaning)
            meaningUtterance.voice = AVSpeechSynthesisVoice(language: meaningUtteranceLanguage)
            meaningUtterance.postUtteranceDelay = intervalOfMeaningAndMeaning
            instance?.speak(meaningUtterance)
        }
    }
    
    /// 여러 개의 단어를 읽어주는 메서드
    /// 단어 하나를 읽어주는 메서드를 재사용하는 방식으로 구현
    func speakWordsAndMeanings(_ words: [Word], to language: String) {
        totalWordsCount = calculateWordsAndMeanings(words) // 단어 개수 카운트
        spokenWordsCount = 1
        
        isPlaying = true // 재생 상태로 변경
        
        words.forEach { word in
            self.speakWordAndMeaning(word, to: language, .many)
        }
    }
    
    /// 단어 읽기를 멈추는 메서드 (onDisapper)
    /// TTS가 작동 중인 상태였으면 (선택 듣기, 전체 듣기 도중 종료) AVSpeechSynthesizer를 초기화하여 오류를 방지
    func stopSpeaking() {
        instance?.stopSpeaking(at: .immediate)
        instance = nil // 인스턴스 초기화
        isPlaying = false // 정지 상태로 변경
    }
    
    /// 재생할 단어의 개수를 계산하는 메서드
    private func calculateWordsAndMeanings(_ words: [Word]) -> Int {
        var cnt = 0

        for word in words {
            cnt += 1

            for _ in word.meaning ?? [] {
                cnt += 1
            }
        }

        return cnt
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // 재생이 완료된 단어의 개수가 총 단어의 개수와 일치하면 정지
        if totalWordsCount == spokenWordsCount {
            isPlaying = false
        } else {
            spokenWordsCount += 1
        }
    }
}
