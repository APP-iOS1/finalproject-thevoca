//
//  CustomMenu.swift
//  GGomVoca
//
//  Created by tae on 2023/02/10.
//

import SwiftUI
import UIKit
// SwiftUI (CustomMenu(@Binding)) -> UIViewRepresentable(@Binding) -> UIKit(@Binding)

struct CustomMenu: UIViewRepresentable {
    @Binding var currentMode: ProfileSection
    @Binding var orderMode: String
    @Binding var speakOn: Bool
    @Binding var testOn: Bool
    @Binding var editOn: Bool
    @Binding var isImportVoca: Bool
    @Binding var isExportVoca: Bool
    @Binding var isCheckResult: Bool

    @Binding var isVocaEmpty: Bool

    func makeUIView(context: Context) -> MenuButton {
        return MenuButton(frame: .zero, currentMode: $currentMode, orderMode: $orderMode, speakOn: $speakOn, testOn: $testOn, editOn: $editOn, isImportVoca: $isImportVoca, isExportVoca: $isExportVoca, isCheckResult: $isCheckResult, isVocaEmpty: isVocaEmpty)
    }

    func updateUIView(_ uiView: MenuButton, context: Context) {
        uiView.updateVocaEmpty(isVocaEmpty)
    }
}

class MenuButton: UIButton {
    @Binding var currentMode: ProfileSection
    @Binding var orderMode: String
    @Binding var speakOn: Bool
    @Binding var testOn: Bool
    @Binding var editOn: Bool
    @Binding var isImportVoca: Bool
    @Binding var isExportVoca: Bool
    @Binding var isCheckResult: Bool

    var isVocaEmpty: Bool


    init(frame: CGRect, currentMode: Binding<ProfileSection>, orderMode: Binding<String>, speakOn: Binding<Bool>, testOn: Binding<Bool>, editOn: Binding<Bool>, isImportVoca: Binding<Bool>, isExportVoca: Binding<Bool>, isCheckResult: Binding<Bool>, isVocaEmpty: Bool) {
          self._currentMode = currentMode
          self._orderMode = orderMode
          self._speakOn = speakOn
          self._testOn = testOn
          self._editOn = editOn
          self._isImportVoca = isImportVoca
          self._isExportVoca = isExportVoca
          self._isCheckResult = isCheckResult
          self.isVocaEmpty = isVocaEmpty
          super.init(frame: frame)

          renderingMenu()

      }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateMode(mode: ProfileSection) {
        self.currentMode = mode
        renderingMenu()
    }

    func updateOrder(order: String) {
        self.orderMode = order
        renderingMenu()
    }

    func updateVocaEmpty(_ current: Bool) {
        print("SwiftUI isVocaEmpty state: \(current), UIKit isVocaEmpty state: \(isVocaEmpty)")
        if current != isVocaEmpty {
          self.isVocaEmpty.toggle()
        }
        print("SwiftUI isVocaEmpty state: \(current), UIKit isVocaEmpty state: \(self.isVocaEmpty)")
        renderingMenu()
    }

    func testMenu() -> UIMenu {

        let seeAll = UIAction(title: "모두 보기".localized,
                              state: currentMode == .normal ? .on : .off) { action in
          self.updateMode(mode: .normal)
        }
        let seeWord = UIAction(title: "단어만 보기".localized,
                               state: currentMode == .meaningTest ? .on : .off) { action in
          self.updateMode(mode: .meaningTest)
        }
        let seeMeaning = UIAction(title: "뜻만 보기".localized,
                                  state: currentMode == .wordTest ? .on : .off) { action in
          self.updateMode(mode: .wordTest)
        }

        // MARK: Conditionally disabled
        if isVocaEmpty {
          return UIMenu(title: "보기 모드".localized, subtitle: "\(currentMode.rawValue.localized)", image: UIImage(systemName: "eye.fill"), children: [])
        }

        return UIMenu(title: "보기 모드".localized, subtitle: "\(currentMode.rawValue.localized)", image: UIImage(systemName: "eye.fill"), children: [seeAll, seeWord, seeMeaning])
    }

    func orderMenu() -> UIMenu {
        let orderByRandom = self.orderByRandom()
        let orderByDict = self.orderByDict()
        let orderByDate = self.orderByDate()

        // MARK: Conditionally disabled
        if isVocaEmpty {
            return UIMenu(title: "정렬".localized, subtitle: "\(orderMode.localized)", image: UIImage(systemName: "arrow.up.arrow.down"), children: [])
        }
        return UIMenu(title: "정렬".localized, subtitle: "\(orderMode.localized)", image: UIImage(systemName: "arrow.up.arrow.down"), children: [orderByRandom, orderByDict, orderByDate])
    }

    func orderByRandom() -> UIAction {
        UIAction(title: "랜덤 정렬".localized) { action in
          self.updateOrder(order: "랜덤 정렬")
        }
    }

    func orderByDict() -> UIAction {
        UIAction(title: "사전순 정렬".localized) { action in
          self.updateOrder(order: "사전순 정렬")
        }
    }

    func orderByDate() -> UIAction {
        UIAction(title: "등록순 정렬".localized) { action in
          self.updateOrder(order: "등록순 정렬")
        }
    }

    func takeTest() -> UIAction {
        UIAction(title: "시험 보기".localized,
                 image: UIImage(systemName: "square.and.pencil")) { action in
          self.testOn.toggle()
        }
    }

    func listenAll() -> UIAction {
        UIAction(title: "전체 단어 듣기".localized,
                 image: UIImage(systemName: "speaker.wave.3")) { action in
          self.speakOn.toggle()
        }
    }

    func editVoca() -> UIAction {
        UIAction(title: "단어 선택하기".localized,
                 image: UIImage(systemName: "checkmark.circle")) { action in
          self.editOn.toggle()
        }
    }

    func importVoca() -> UIAction {
        UIAction(title: "단어장 가져오기".localized,
                 image: UIImage(systemName: "square.and.arrow.down")) { action in
          self.isImportVoca.toggle()
        }
    }

    func exportVoca() -> UIAction {
        UIAction(title: "단어장 내보내기".localized,
                 image: UIImage(systemName: "square.and.arrow.up")) { action in
          self.isExportVoca.toggle()
        }
    }

    func checkResult() -> UIAction {
        UIAction(title: "시험 결과 보기".localized,
                 image: UIImage(systemName: "chart.line.uptrend.xyaxis")) { action in
          self.isCheckResult.toggle()
        }
    }

    func renderingMenu() {
        print("rendering Menu function started -----------------------")
        print("UIKit isVocaEmpty: \(isVocaEmpty)")
        let testMenu = self.testMenu()
        // 시험 보기
        let takeTest = self.takeTest()
        // 전체 발음 듣기
        let listenAll = self.listenAll()
        // 정렬
        let orderMenu = self.orderMenu()
        // 단어장 편집
        let editVoca = self.editVoca()
        // 단어장 가져오기
        let importVoca = self.importVoca()
        // 단어장 내보내기
        let exportVoca = self.exportVoca()
        // 시험 결과 보기
        let checkResult = self.checkResult()

        let modeTestMenu = UIMenu(title: "", options: .displayInline, children: [testMenu, takeTest, checkResult])
        let orderVocaMenu = UIMenu(title: "", options: .displayInline, children: [orderMenu, editVoca, importVoca, exportVoca])

        // MARK: Conditionally disabled
        if isVocaEmpty {
            takeTest.attributes = .disabled
            listenAll.attributes = .disabled
            editVoca.attributes = .disabled
            exportVoca.attributes = .disabled
            checkResult.attributes = .disabled
        }

        setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
        menu = UIMenu(title: "", children: [modeTestMenu, orderVocaMenu, listenAll])
        showsMenuAsPrimaryAction = true
    }




}

