//
//  ShakeEffect.swift
//  GGomVoca
//
//  Created by tae on 2023/02/02.
//

import SwiftUI

// MARK: - Shake Effect
struct ShakeEffect: ViewModifier {
  var trigger: Bool
  @State private var isShaking = false

  func body(content: Content) -> some View { // Content는  수정자가 적용되는 곳 '위'까지의 View
    content
      .offset(x: isShaking ? -6 : .zero)
      .animation(.default.repeatCount(3).speed(6), value: isShaking)
      .onChange(of: trigger) { newValue in
        // isOverCount -> false로 갈 때도 발생하니까
        guard newValue else { return } // newValue가 true인 애들만 내려온다.
        isShaking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          // closure 안에 오는 코드를 몇 초 뒤에 실행한다.
          isShaking = false
        }
      }
  }
}

extension View {
  func shakeEffect(trigger: Bool) -> some View {
    modifier(ShakeEffect(trigger: trigger))
  }
}
