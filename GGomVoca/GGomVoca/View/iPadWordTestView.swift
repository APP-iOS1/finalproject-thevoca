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

struct TestWord: Identifiable {
    let id = UUID()
    var word: String
    var meaning: String
}

private var testWords: [TestWord] = [
    TestWord(word: "昇進", meaning: "승진"),
    TestWord(word: "嫌がる", meaning: "싫어하다"),
    TestWord(word: "宣伝", meaning: "선전"),
    TestWord(word: "こっそり", meaning: "몰래, 살짝, 가만히"),
    TestWord(word: "積む", meaning: "쌓다"),
    TestWord(word: "素敵", meaning: "멋있다, 훌륭하다"),
    TestWord(word: "昇進", meaning: "승진"),
    TestWord(word: "嫌がる", meaning: "싫어하다"),
    TestWord(word: "宣伝", meaning: "선전"),
    TestWord(word: "こっそり", meaning: "몰래, 살짝, 가만히"),
    TestWord(word: "積む", meaning: "쌓다"),
    TestWord(word: "素敵", meaning: "멋있다, 훌륭하다")
]

struct iPadWordTestView: View {
    // MARK: SuperView Properties
    var testType: String = "meaning"
    //    var isMemorized: Bool
    @State private var answers: [String] = Array(repeating: "", count: testWords.count)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                    Section {
                        ForEach(testWords.indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                HStack(alignment: .center) {
                                    Text(testWords[index].word)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 200, height: 80)
                                    Divider()
                                    TextField("", text: $answers[index], axis: .vertical)
                                        .padding(.vertical)
                                }
                                Divider()
                            }
                        }
                    } header: {
                        VStack(spacing:0) {
                            Divider()
                            Text("펜슬로 빈 칸에 답을 적어주세요.").padding(10)
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
        }
        .background { Color("offwhite") }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("제출") {
                    print("제출")
                }
            }
        }
    }
}

struct iPadWordTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            iPadWordTestView()
        }
    }
}
