//
//  EmptyWordListView.swift
//  GGomVoca
//
//  Created by tae on 2023/01/30.
//

import SwiftUI

struct EmptyWordListView: View {

  var lang: String
  var langNationality: Nationality {
    switch lang {
    case "KO":
      return .KO
    case "EN":
      return .EN
    case "FR":
      return .FR
    case "JA":
      return .JA
    default:
      return .KO
    }
  }
  var emptyByLang: String {
    switch lang {
    case "KO":
      return "비어 있는"
    case "EN":
      return "EMPTY"
    case "FR":
      return "VIDE"
    case "JA":
      return "空っぽの"
    default:
      return ""
    }
  }

    var body: some View {
      VStack(spacing: 20) {
        Text("\(emptyByLang)")
          .bold()
          .font(.system(size: 60))
        Image(systemName: "tray")
          .font(.largeTitle)
        Text("\(langNationality.rawValue)로 '비어 있는'이라는 뜻입니다.")
      }
      .foregroundColor(.secondary)
    }
}

struct BlankView: View {
  var text: String = ""
  var body: some View {
    Path { path in
                path.move(to: CGPoint(x: 200, y: 0))
                path.addLine(to: CGPoint(x: 200, y: 200))

            }
            .stroke(.blue, lineWidth: 10)
  }
}

struct EmptyWordListView_Previews: PreviewProvider {
    static var previews: some View {
      EmptyWordListView(lang: "FR")
    }
}
