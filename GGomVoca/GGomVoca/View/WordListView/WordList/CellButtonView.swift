//
//  CellButtonView.swift
//  GGomVoca
//
//  Created by do hee kim on 2023/01/18.
//

import SwiftUI

enum CellButtons: Identifiable {
    case edit
    case delete
    case save
    case info
    
    var id: String {
        return "\(self)"
    }
}

struct CellButtonView: View {
    let data: CellButtons
    let cellHeight: CGFloat
    let buttonWidth: CGFloat = 60
    
    func getView(for image: String) -> some View {
        VStack {
            Image(systemName: image)
                .foregroundColor(.white)
        }.padding(5)
            .foregroundColor(.primary)
            .font(.subheadline)
            .frame(width: buttonWidth, height: cellHeight)
    }
    
    var body: some View {
        switch data {
        case .edit:
            getView(for: "pencil.circle")
                .background(Color.pink)
        case .delete:
            getView(for: "trash")
                .background(Color.red)
        case .save:
            getView(for: "square.and.arrow.down")
                .background(Color.blue)
        case .info:
            getView(for: "info.circle")
                .background(Color.green)
        }
    }
}

//struct CellButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        CellButtonView()
//    }
//}
