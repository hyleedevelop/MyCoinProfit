//
//  SettingSectionModel.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/22.
//

import UIKit

enum SettingSection {
    case appSettings([AppSettingsModel])
    case aboutThisApp([AboutThisAppModel])
}

struct AppSettingsModel {
    let title: String?
    let iconImage: UIImage?
}

struct AboutThisAppModel {
    let title: String?
    let iconImage: UIImage?
}
