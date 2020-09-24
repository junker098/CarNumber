//
//  CarModel.swift
//  CarNumber
//
//  Created by Юрий Могорита on 11.09.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import Foundation

struct Car: Decodable {
    let digits: String
    let vendor: String
    let model: String
    let year: Int
    let photoUrl: String
    let stolen: Bool
    let operations: [Operations]
}

struct Operations: Decodable {
    let isLast: Bool
    let regAt: String
    let modelYear: Int
    let vendor: String
    let model: String
    let notes: String
    let operation: String
    let address: String
}
