//
//  SegmentView.swift
//  GGomVoca
//
//  Created by tae on 2022/12/19.
//


import SwiftUI

enum ProfileSection : String, CaseIterable {
    case normal = "전체 보기"
    case wordTest = "단어 가리기"
    case meaningTest = "뜻 가리기"
}

struct SegmentView: View {
    @Binding var selectedSegment : ProfileSection
    @Binding var unmaskedWords: [Word.ID]
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedSegment) {
                ForEach(ProfileSection.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .onChange(of: selectedSegment, perform: { newValue in
                unmaskedWords = []
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            Text(selectedSegment == .normal ? " " : selectedSegment == .wordTest ? "\(Image(systemName: "exclamationmark.circle")) 탭 하면 가려진 단어가 나타납니다." : "\(Image(systemName: "exclamationmark.circle")) 탭 하면 가려진 뜻이 나타납니다.")
                .font(.subheadline)
                .opacity(0.5)
        }
    }
}


//struct SegmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentView()
//    }
//}
