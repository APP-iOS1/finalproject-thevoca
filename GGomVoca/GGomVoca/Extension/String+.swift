//
//  String+.swift
//  GGomVoca
//
//  Created by tae on 2023/01/30.
//

import Foundation

extension String {
    // MARK: 여러 개의 뜻을 가졌는지 확인
    var multiCheck: Bool {
        self.contains(",") ? true : false
    }

    // MARK: CSV에서 여러 개의 뜻을 하나로 인식하도록 재구성
    var reformForCSV: String {
        "\"\(self)\""
    }

    // MARK: UIKit 부분 localization
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
     }
}
