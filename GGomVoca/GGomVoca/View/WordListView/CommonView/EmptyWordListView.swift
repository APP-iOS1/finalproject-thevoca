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
            Image(systemName: "tray")
                .font(.system(size: 70))
                .fontWeight(.light)
                .padding(.bottom, 10)
            Text("\(emptyByLang)")
                .font(.system(size: 40))
            Text("텅 빈, 비어있는")
                .font(.system(size: 40))
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
