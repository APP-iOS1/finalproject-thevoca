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
    
    func localizedString() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct SegmentView: View {
    @Binding var selectedSegment : ProfileSection
    @Binding var selectedWord: [UUID]
    
    @State var wordTest: LocalizedStringKey = "탭 하면 가려진 단어가 나타납니다."
    @State var meaningTest: LocalizedStringKey = "탭 하면 가려진 뜻이 나타납니다."
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedSegment) {
                ForEach(ProfileSection.allCases, id: \.self) { option in
                    Text(option.localizedString())
                }
            }
            .onChange(of: selectedSegment, perform: { newValue in
                selectedWord = []
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            Text(selectedSegment == .normal ? " " : selectedSegment == .wordTest ? wordTest : meaningTest)
                .font(.subheadline)
                .opacity(0.5)
                .padding(.bottom, -20)
        }
    }
}


//struct SegmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        SegmentView()
//    }
//}
