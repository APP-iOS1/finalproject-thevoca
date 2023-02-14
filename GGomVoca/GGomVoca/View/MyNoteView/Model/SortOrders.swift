//
//  SortOrders.swift
//  GGomVoca
//
//  Created by Roen White on 2023/02/15.
//

import SwiftUI

enum SortOrders: String, CaseIterable {
    case createdAt     = "등록순"
    case dictionary    = "사전순"
    case incorrectRate = "오답률 높은 순"
    case correctRate   = "정답률 높은 순"
    case isMemorized   = "암기 완료"
}
