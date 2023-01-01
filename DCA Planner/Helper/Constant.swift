//
//  Constant.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

struct Constant {
    struct UIColorSetting {
        static let lightGray: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        
        static let lightPurple: UIColor = UIColor(red: 208/255, green: 156/255, blue: 250/255, alpha: 1)
        static let deepPurple: UIColor = UIColor(red: 165/255, green: 85/255, blue: 236/255, alpha: 1)
        
        static let lightGreen: UIColor = UIColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1)
        
        static let positiveColor: UIColor = UIColor(red: 82/255, green: 164/255, blue: 154/255, alpha: 1)
        static let negativeColor: UIColor = UIColor(red: 222/255, green: 94/255, blue: 87/255, alpha: 1)
        
        static let themeColor: UIColor = deepPurple
    }
    
    struct CGColorSetting {
        
    }
    
    struct SizeSetting {
        static let bottomLineWidth: CGFloat = 1.0
    }
    
    struct NetworkSetting {
        
    }
    
    struct MenuSetting {
        static let menuName1: String = "코인시세"
        static let menuName2: String = "수익계산"
        static let menuName3: String = "설정"
    }
        
    struct AnimationSetting {
        static let transitionDuration: Double = 0.25
    }
}
