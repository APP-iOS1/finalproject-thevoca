//
//  TestModeSelectView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct TestModeSelectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isTestMode: Bool
    
    // MARK: Data Properties
    var vocabularyID: Vocabulary.ID
    @ObservedObject var viewModel: JPWordListViewModel
    
    var body: some View {
        NavigationStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.gray)
            }
            .horizontalAlignSetting(.trailing)
            .padding()
            
            Spacer()
            
            VStack(spacing: 15) {
                NavigationLink {
                    iPhoneWordTestView(
                        isTestMode: $isTestMode,
                        vocabularyID: vocabularyID,
                        viewModel: viewModel,
                        testMode: "word",
                        isMemorized: true
                    )
                } label: {
                    Text("전체 단어 시험")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.secondary, lineWidth: 1)
                                .foregroundColor(.gray)
                        }
                }

                
                NavigationLink {
                    iPhoneWordTestView(
                        isTestMode: $isTestMode,
                        vocabularyID: vocabularyID,
                        viewModel: viewModel,
                        testMode: "meaning",
                        isMemorized: true
                    )
                } label: {
                    Text("전체 뜻 시험")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.secondary, lineWidth: 1)
                                .foregroundColor(.gray)
                        }
                }
                
                NavigationLink {
                    iPhoneWordTestView(
                        isTestMode: $isTestMode,
                        vocabularyID: vocabularyID,
                        viewModel: viewModel,
                        testMode: "word",
                        isMemorized: false
                    )
                } label: {
                    Text("못외운 단어 시험")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.secondary, lineWidth: 1)
                                .foregroundColor(.gray)
                        }
                }
                
                NavigationLink {
                    iPhoneWordTestView(
                        isTestMode: $isTestMode,
                        vocabularyID: vocabularyID,
                        viewModel: viewModel,
                        testMode: "meaning",
                        isMemorized: false
                    )
                } label: {
                    Text("못외운 뜻 시험")
                        .foregroundColor(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.secondary, lineWidth: 1)
                                .foregroundColor(.gray)
                        }
                }
            }
            
            Spacer()

        }
    }
}

struct TestModeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        TestModeSelectView(isTestMode: .constant(true), vocabularyID: UUID(uuidString: "64883267-186C-4053-A38E-940E6F6E7B41"), viewModel: JPWordListViewModel())
    }
}
