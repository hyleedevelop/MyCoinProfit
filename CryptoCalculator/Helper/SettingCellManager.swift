//
//  SettingDataManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/24.
//

import UIKit

final class SettingCellManager {
    
    static let shared = SettingCellManager()
    private init() {}
    
    //MARK: - data 정의
    
    private var appSettingsModel = [
        AppSettingsModel(icon: UIImage(systemName: "paintbrush"), title: "Theme Color", value: nil),
    ]

    private var feedbackModel = [
        FeedbackModel(icon: UIImage(systemName: "star"), title: "Rate The App", value: nil),
        FeedbackModel(icon: UIImage(systemName: "envelope"), title: "Contact", value: nil),
    ]
    
    private var aboutTheAppModel = [
        AboutTheAppModel(icon: UIImage(systemName: "questionmark.circle"), title: "Help", value: nil),
        AboutTheAppModel(icon: UIImage(systemName: "doc.text"), title: "Privacy Policy", value: nil),
        AboutTheAppModel(icon: UIImage(systemName: "doc.text"), title: "Terms & Conditions", value: nil),
        AboutTheAppModel(icon: UIImage(systemName: "c.circle"), title: "Copyright", value: "HOYEON LEE"),
        AboutTheAppModel(icon: UIImage(systemName: "number.circle"), title: "App Version", value: nil),
    ]
    
    //MARK: - 셀 데이터 조회 및 업데이트 관련 메서드
    
    var appSettingData: SettingCellData {
        return SettingCellData.appSettings(appSettingsModel)
    }
    
    var feedbackData: SettingCellData {
        return SettingCellData.feedback(feedbackModel)
    }
    
    var aboutTheAppData: SettingCellData {
        return SettingCellData.aboutTheApp(aboutTheAppModel)
    }
    
    func updateAboutTheAppData(index: Int, newValue: String?) {
        guard let newValue = newValue else { return }
        self.aboutTheAppModel[index].value = newValue
    }
    
}
