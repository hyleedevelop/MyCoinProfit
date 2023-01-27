//
//  SettingSectionModel.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/22.
//

import UIKit

enum SettingCellData {
    case appSettings([AppSettingsModel])
    case feedback([FeedbackModel])
    case aboutTheApp([AboutTheAppModel])
}

struct AppSettingsModel {
    let icon: UIImage?
    let title: String?
    let value: String?
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
