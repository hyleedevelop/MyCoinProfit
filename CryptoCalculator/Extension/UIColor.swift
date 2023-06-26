//
//  UIColor.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/27.
//

import UIKit

extension UIColor {
    
    // RGB 값을 n/255가 아닌 n으로 입력해도 UIColor를 지정할 수 있도록 지원하는 편의생성자
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 0xFF) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
    
    // RGB 값을 16진법으로 입력해도 UIColor를 지정할 수 있도록 지원하는 편의생성자
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}
