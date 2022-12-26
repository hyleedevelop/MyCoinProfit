//
//  Constant.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

struct Constant {
    struct ColorSetting {
        static let themeColor: UIColor = UIColor.orange
        static let color1: UIColor = UIColor(red: 254/255, green: 190/255, blue: 140/255, alpha: 1)
        static let color2: UIColor = UIColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1)
        static let positiveColor: UIColor = UIColor(red: 82/255, green: 164/255, blue: 154/255, alpha: 1)
        static let negativeColor: UIColor = UIColor(red: 222/255, green: 94/255, blue: 87/255, alpha: 1)
    }
    
    struct NetworkSetting {
        
    }
    
    struct MenuSetting {
        static let menuName1: String = "코인시세"
        static let menuName2: String = "투자계획"
        static let menuName3: String = "설정"
    }
        
    struct Animation {
        static let transitionDuration: Double = 0.25
    }
}
