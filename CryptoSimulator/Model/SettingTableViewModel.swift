//
//  SettingSectionModel.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/22.
//

import UIKit

enum SettingTableViewModel {
    case appSettings([AppSettingsModel])
    case aboutTheApp([AboutTheAppModel])
}

struct AppSettingsModel {
    let icon: UIImage?
    let title: String?
}

struct AboutTheAppModel {
    let icon: UIImage?
    let title: String?
    let value: String?
}
