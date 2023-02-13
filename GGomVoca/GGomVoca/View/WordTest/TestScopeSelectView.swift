//
//  TestScopeSelectView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct TestScopeSelectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isTestMode: Bool
    @ObservedObject var viewModel = TestScopeSelectViewModel()
    
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    
    var body: some View {
        NavigationStack {
            List {
                if UIDevice.current.model == "iPhone" {
                    Section {
                        NavigationLink {
                            iPhoneWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "word",
                                isWholeWord: true
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("단어 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.fullScopeQuestionCount)문제,")
                                    Text(viewModel.fullScopeTestTimeStringToiPhone)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink {
                            iPhoneWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "meaning",
                                isWholeWord: true)
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("뜻 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.fullScopeQuestionCount)문제,")
                                    Text(viewModel.fullScopeTestTimeStringToiPhone)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    } header: {
                        Text("전체 범위")
                            .offset(x: -15)
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        NavigationLink {
                            iPhoneWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "word",
                                isWholeWord: false
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("단어 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.notMemorizedQuestionCount)문제,")
                                    Text(viewModel.notMemorizedTestTimeStringToiPhone)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink {
                            iPhoneWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "meaning",
                                isWholeWord: false
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("뜻 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.notMemorizedQuestionCount)문제,")
                                    Text(viewModel.notMemorizedTestTimeStringToiPhone)
                                }
                                .foregroundColor(.gray)
                            }
                        }

                    } header: {
                        Text("아직 못 외운 것만")
                            .offset(x: -15)
                    } footer: {
                        Text("\(Image(systemName: "exclamationmark.circle")) 시험에서 5번 연속 정답 처리된 단어는 제외됩니다.")
                            .offset(x: -15)
                    }
                    .headerProminence(.increased)
                } else {
                    Section {
                        NavigationLink {
                            iPadWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "word",
                                isWholeWord: true
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("단어 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.fullScopeQuestionCount)문제,")
                                    Text(viewModel.fullScopeTestTimeStringToiPad)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink {
                            iPadWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "meaning",
                                isWholeWord: true
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("뜻 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.fullScopeQuestionCount)문제,")
                                    Text(viewModel.fullScopeTestTimeStringToiPad)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    } header: {
                        Text("전체 범위")
                            .offset(x: -11)
                    }
                    .headerProminence(.increased)
                    
                    Section {
                        NavigationLink {
                            iPadWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "word",
                                isWholeWord: false
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("단어 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.notMemorizedQuestionCount)문제,")
                                    Text(viewModel.notMemorizedTestTimeStringToiPad)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        
                        NavigationLink {
                            iPadWordTestView(
                                isTestMode: $isTestMode,
                                vocabularyID: vocabularyID,
                                testType: "meaning",
                                isWholeWord: false
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("뜻 시험 보기")
                                HStack {
                                    Text("총 \(viewModel.notMemorizedQuestionCount)문제,")
                                    Text(viewModel.notMemorizedTestTimeStringToiPad)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                    } header: {
                        Text("아직 못 외운 것만")
                            .offset(x: -11)
                    } footer: {
                        Text("\(Image(systemName: "exclamationmark.circle")) 시험에서 5번 연속 정답 처리된 단어는 제외됩니다.")
                            .offset(x: -11)
                    }
                    .headerProminence(.increased)
                }
            }
            .navigationTitle("시험 범위 선택")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기", role: .cancel) { dismiss() }
                }
            }
        }
        .onAppear {
            viewModel.getWords(for: vocabularyID)
        }
    }
}

//struct TestModeSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestScopeSelectView(isTestMode: .constant(true), vocabularyID: UUID(uuidString: "64883267-186C-4053-A38E-940E6F6E7B41"))
//    }
//}
