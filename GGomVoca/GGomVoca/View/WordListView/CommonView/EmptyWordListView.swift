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
            return "empty"
        case "FR":
            return "vide"
        case "JA":
            return "空っぽの"
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            if UIDevice.current.model == "iPhone" {
                Image(systemName: "tray")
                    .font(.system(size: 65))
                    .fontWeight(.light)
                    .padding(.bottom, 10)
                Text("\(emptyByLang)")
                    .font(.system(size: 35))
                Text("텅 빈, 비어있는")
                    .font(.system(size: 35))
            } else {
                Image(systemName: "tray")
                    .font(.system(size: 70))
                    .fontWeight(.light)
                    .padding(.bottom, 10)
                Text("\(emptyByLang)")
                    .font(.system(size: 40))
                Text("텅 빈, 비어있는")
                    .font(.system(size: 40))
            }
        }
        .foregroundColor(.secondary)
    }
}

struct EmptyWordListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyWordListView(lang: "FR")
    }
}
