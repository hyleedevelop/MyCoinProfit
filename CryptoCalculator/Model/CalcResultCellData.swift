//
//  StatsData.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit

enum CalcResultCellData {
    case stats([StatsModel])
    case graph([GraphModel])
}

struct StatsModel {
    let icon: UIImage?
    let title: String?
    var value: String?
}

struct GraphModel {
    let title: String?
}
