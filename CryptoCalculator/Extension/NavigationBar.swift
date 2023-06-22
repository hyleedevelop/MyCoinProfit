//
//  NavigationBar.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/22.
//

import UIKit

extension UINavigationController {
    
    // 기본 설정
    func applyDefaultSettings() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor(named: "BGColor")
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        
        self.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationBar.tintColor = .label
        self.navigationBar.prefersLargeTitles = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.isHidden = false
        self.setNeedsStatusBarAppearanceUpdate()

        self.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        self.navigationItem.compactAppearance = navigationBarAppearance
    }
    
}
