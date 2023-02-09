//
//  FieldView.swift
//  GGomVoca
//
//  Created by tae on 2023/02/03.
//

import SwiftUI

struct FieldView: View {
  @Binding var value: String
  let onDelete: () -> Void

  var body: some View {
    HStack {
      TextField("뜻을 입력하세요.", text: $value)
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
      Button(action: {
        print("clicked?")
        onDelete()
      }, label: {
        Image(systemName: "multiply")
          .foregroundColor(.red)
      })
    }
  }
}
