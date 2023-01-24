//
//  SettingSectionModel.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/22.
//

import UIKit

enum SettingData {
    case feedback([FeedbackModel])
    case aboutTheApp([AboutTheAppModel])
}

struct FeedbackModel {
    let icon: UIImage?
    let title: String?
    let value: String?
}

struct AboutTheAppModel {
    let icon: UIImage?
    let title: String?
    let value: String?
}
