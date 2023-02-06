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

final class SpeechSynthesizer: TTSProtocol {
    // 싱글톤으로 정의
    static let shared: SpeechSynthesizer = SpeechSynthesizer()
    
    private let instance: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    // 단어와 의미 사이의 간격 (같은 단어 내에서)
    private let intervalOfWordAndMeaning = 0.3
    
    // 의미와 의미 사이의 간격 (같은 단어 내에서)
    private let intervalOfMeaningAndMeaning = 0.1
    
    // 단어와 단어 사이의 간격 (다른 단어끼리)
    private let intervalOfWordAndWord = 0.5
    
    // TODO: - 사용자가 설정한 언어에 따라 동적으로 뱌뀌는 코드 추가
    private let meaningUtteranceLanguage = "ko-KR"
    
    private init() {}
    
    /// 단어 하나를 읽어주는 메서드
    func speakWordAndMeaning(_ word: Word, to language: String, _ type: SpeechType) {
        let wordUtterance = AVSpeechUtterance(string: word.word ?? "") // TTS로 들려줄 단어 설정
        wordUtterance.voice = AVSpeechSynthesisVoice(language: language) // 언어 설정
        wordUtterance.postUtteranceDelay = intervalOfWordAndMeaning // 다음 단어와의 시간 간격 설정
        self.instance.speak(wordUtterance) // TTS 작동
        
        if type == SpeechType.single { return } // contextMenu로 접근한 경우
        
        // meaning 타입이 [String?]라서 순회하는 방식으로 구현
        word.meaning?.forEach { meaning in
            let meaningUtterance = AVSpeechUtterance(string: meaning)
            meaningUtterance.voice = AVSpeechSynthesisVoice(language: meaningUtteranceLanguage)
            meaningUtterance.postUtteranceDelay = intervalOfMeaningAndMeaning
            self.instance.speak(meaningUtterance)
        }
    }
    
    /// 여러 개의 단어를 읽어주는 메서드
    /// 단어 하나를 읽어주는 메서드를 재사용하는 방식으로 구현
    func speakWordsAndMeanings(_ words: [Word], to language: String) {
        words.forEach { word in
            self.speakWordAndMeaning(word, to: language, .many)
        }
    }
    
    /// 단어 읽기를 멈추는 메서드 (onDisapper)
    func stopSpeaking() {
        self.instance.stopSpeaking(at: .immediate)
    }
}
