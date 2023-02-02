//
//  WordTestResult.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/02/01.
//

import SwiftUI

struct WordTestResult: View {
    @Binding var isTestMode: Bool
    
    @ObservedObject var paperViewModel: TestViewModel
    let testMode: String
    
    var body: some View {
        VStack {
            Button {
                isTestMode = false
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("단어장으로 돌아가기")
                }
                .padding(.leading, 8)
                .padding(.vertical, 5)
            }
            .horizontalAlignSetting(.leading)
            
            Spacer()
            
            List(paperViewModel.testPaper) { paper in
                HStack {
                    switch testMode {
                    case "word":
                        Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
                            .foregroundColor(.red)
                        Text(paper.answer ?? "")
                            .horizontalAlignSetting(.center)
                        Text(paper.meaning)
                            .horizontalAlignSetting(.center)
                    case "meaning":
                        Text(paper.isCorrect ? Image(systemName: "circle") : Image(systemName: "xmark"))
                            .foregroundColor(.red)
                        Text(paper.word)
                            .horizontalAlignSetting(.center)
                        Text(paper.answer ?? "")
                            .horizontalAlignSetting(.center)
                    default:
                        Text("Empty")
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

//struct WordTestResult_Previews: PreviewProvider {
//    static var previews: some View {
//        WordTestResult()
//    }
//}
