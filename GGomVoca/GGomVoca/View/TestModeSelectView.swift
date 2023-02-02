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
            }
            .horizontalAlignSetting(.trailing)
            .padding()
            
            Spacer()
            
            Group {
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
                }
            }
            
            Spacer()

        }
    }
}

//struct TestModeSelectView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestModeSelectView(vocabularyID: UUID(uuidString: "64883267-186C-4053-A38E-940E6F6E7B41"), viewModel: JPWordListViewModel())
//    }
//}
