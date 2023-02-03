//
//  Array.swift
//  GGomVoca
//
//  Created by tae on 2023/02/03.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Result {
      // MARK: 개수가 똑같으면, 완전히 같은 값들만 가져야 한다.
      if self.count == other.count && self.sorted() == other.sorted() {
        return .Right
      } else {
        // MARK: 개수가 다르다면, 입력된 값들이 정답에 전부 포함되어야 한다.
        for i in other.indices {
          if self.contains(other[i]) {
            // MARK: 하나라도 정답이 있을 경우, 정답 처리가 된다.
            return .Half
          }
        }
        return .Wrong
      }
    }
}
