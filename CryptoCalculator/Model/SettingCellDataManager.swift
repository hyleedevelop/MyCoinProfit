//
//  SettingDataManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/24.
//

import UIKit

final class SettingCellDataManager {
    
    // 싱글톤으로 만들기
    static let shared = SettingCellDataManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
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
        AboutTheAppModel(icon: UIImage(systemName: "wand.and.stars.inverse"), title: "Third-Party Libraries", value: nil),
        AboutTheAppModel(icon: UIImage(systemName: "doc.text"), title: "Terms & Conditions", value: nil),
        AboutTheAppModel(icon: UIImage(systemName: "c.circle"), title: "Copyright", value: "Hoyeon LEE"),
        AboutTheAppModel(icon: UIImage(systemName: "number.circle"), title: "App Version", value: "1.0.0 (1)"),
    ]
    
    //MARK: - 메서드 정의
    
    func appSettingData() -> SettingCellData {
        return SettingCellData.appSettings(appSettingsModel)
    }
    
    func feedbackData() -> SettingCellData {
        return SettingCellData.feedback(feedbackModel)
    }
    
    func aboutTheAppData() -> SettingCellData {
        return SettingCellData.aboutTheApp(aboutTheAppModel)
    }
    
    func updateAboutTheAppData(index: Int, newValue: String?) {
        guard let newValue = newValue else { return }
        aboutTheAppModel[index].value = newValue
    }
    
}