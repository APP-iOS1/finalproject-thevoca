//
//  Text+.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/09.
//

import SwiftUI

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string) /// create an `AttributedString`
        configure(&attributedString) /// configure using the closure
        self.init(attributedString) /// initialize a `Text`
    }
}
