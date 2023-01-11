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
        static let labelFontSize: CGFloat = 17
        static let textfieldFontSize: CGFloat = labelFontSize - 2
        static let calcResultFontSize: CGFloat = 16
        static let labelFontWeight: UIFont.Weight = .semibold
        static let textfieldFontWeight: UIFont.Weight = .regular
        static let bottomLineHeightAnchorConstant: CGFloat = 1.0
        static let bottomLineWidthAnchorConstant: CGFloat = -80
        static let calcButtonWidthAnchorConstant: CGFloat = -20
    }
    
    //                                     <Timeline>
    //
    //     O-----------------O-----------------O-----------------O-----------------O
    // 2013-04-28       buyStartDate       buyEndDate         sellDate            Now
    struct DateSetting {
        // 각 날짜의 최대값: buyStartDate < buyEndDate < sellDate < currentDate
        static let sellMaximumDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        static let buyEndMaximumDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: sellMaximumDate)!
        static let buyStartMaximumDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: buyEndMaximumDate)!
        
        // 각 날짜의 최소값: 1367107200(UnixTimestamp) = buyStartDate < buyEndDate < sellDate
        static let buyStartMinimumDate: Date = Date(timeIntervalSince1970: 1367107200)  // 2013-04-28 00:00:00
        static let buyEndMinimumDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: buyStartMinimumDate)!
        static let sellMinimumDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: buyEndMinimumDate)!
    }
    
    struct UnitSetting {
        static let oneDayInSeconds: Double = 86400.0
    }
    
    struct TitleSetting {
        static let coinTypeLabelName: String = "어떤 코인을 매수할까요?"
        static let buyStartDateLabelName1: String = "코인을 언제 매수할까요?"
        static let buyStartDateLabelName2: String = "코인 매수를 언제 시작할까요?"
        static let buyEndDateLabelName: String = "코인 매수를 언제 종료할까요?"
        static let sellDateLabelName: String = "코인을 언제 매도할까요?"
        static let frequencyLabelName: String = "코인을 얼마만에 한번씩 매수할까요?"
        static let amountLabelName1: String = "코인을 매수하는데 얼마를 사용할까요?"
        static let amountLabelName2: String = "코인을 한번씩 매수할때마다 얼마를 사용할까요?"
        
        static let coinTypeTextFieldPlaceHolder: String = "코인 종류 선택"
        static let buyStartDateTextFieldPlaceHolder: String = "날짜 선택"
        static let buyEndDateTextFieldPlaceHolder: String = "날짜 선택"
        static let sellDateTextFieldPlaceHolder: String = "날짜 선택"
        static let frequencyTextFieldPlaceHolder: String = "반복 주기 선택"
        static let amountLabelTextFieldPlaceHolder: String = "달러($) 금액 입력"
        
        static let menuName1: String = "코인시세"
        static let menuName2: String = "수익계산"
        static let menuName3: String = "설정"
        
        static let calcStartButtonName: String = "계산하기"
        static let calcResetButtonName: String = "지우기"
        static let calcSaveButtonName: String = "결과 저장하기"
    }
        
    struct ImageSetting {
        static let checkMarkYes: UIImage = UIImage(systemName: "checkmark.circle.fill")!
        static let checkMarkNo: UIImage = UIImage(systemName: "xmark.circle.fill")!
    }
    
    struct AnimationSetting {
        static let transitionDuration: Double = 0.25
    }
}
