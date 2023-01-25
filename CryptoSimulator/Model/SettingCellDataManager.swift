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
    
    func feedbackData() -> SettingCellData {
        let feedbackModel = [
            FeedbackModel(icon: UIImage(systemName: "giftcard"), title: "Tips for App Developer", value: nil),
            FeedbackModel(icon: UIImage(systemName: "star"), title: "Rate The App", value: nil),
            FeedbackModel(icon: UIImage(systemName: "envelope"), title: "Contact", value: nil)
        ]
        return SettingCellData.feedback(feedbackModel)
    }
    
    func aboutTheAppData() -> SettingCellData {
        let aboutTheAppModel = [
            AboutTheAppModel(icon: UIImage(systemName: "wand.and.stars.inverse"), title: "Third-Party Libraries", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "doc.text"), title: "Privacy & Terms", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "number.circle"), title: "App Version", value: "1.0.0")
        ]
        return SettingCellData.aboutTheApp(aboutTheAppModel)
    }
    
}
