//
//  Constant.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

struct Constant {
    struct UIColorSetting {
        static let lightModeBackground: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        static let darkModeBackground: UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        static let lightModeInbox: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let darkModeInbox: UIColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        
        static let lightPurple: UIColor = UIColor(red: 208/255, green: 156/255, blue: 250/255, alpha: 1)
        static let deepPurple: UIColor = UIColor(red: 165/255, green: 85/255, blue: 236/255, alpha: 1)
        
        static let lightGreen: UIColor = UIColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1)
        
        static let positiveColor: UIColor = UIColor(red: 58/255, green: 133/255, blue: 68/255, alpha: 1)
        static let negativeColor: UIColor = UIColor(red: 216/255, green: 50/255, blue: 50/255, alpha: 1)
        
        static let themeColor: UIColor = deepPurple
        
        static let themeGradientColor1: UIColor = UIColor(red: 148/255, green: 41/255, blue: 255/255, alpha: 1)  // 보라색
        static let themeGradientColor2: UIColor = UIColor(red: 13/255, green: 167/255, blue: 207/255, alpha: 1)  // 청녹색
    }
    
    struct CGColorSetting {
        static let deepPurple: CGColor = CGColor(red: 165/255, green: 85/255, blue: 236/255, alpha: 1)
        static let black: CGColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        static let themeColor: CGColor = deepPurple
    }
    
    struct SizeSetting {
        static let segmentFontSize: CGFloat = 15
        
        static let labelFontSize: CGFloat = 17
        static let labelFontWeight: UIFont.Weight = .semibold
        
        static let textfieldFontSize: CGFloat = labelFontSize - 2
        static let textfieldFontWeight: UIFont.Weight = .regular
        
        static let calcResultFontSize: CGFloat = 16
        
        static let summaryLabelBigFontSize: CGFloat = 20
        static let summaryLabelBigFontWeight: UIFont.Weight = .bold
        
        static let summaryLabelSmallFontSize: CGFloat = summaryLabelBigFontSize - 6
        static let summaryLabelSmallFontWeight: UIFont.Weight = .regular
        
        static let graphLabelBigFontSize: CGFloat = 15
        static let graphLabelBigFontWeight: UIFont.Weight = .bold
        
        static let graphLabelSmallFontSize: CGFloat = graphLabelBigFontSize - 2
        static let graphLabelSmallFontWeight: UIFont.Weight = .medium
        
        static let bottomLineHeightAnchorConstant: CGFloat = 0.8
        static let bottomLineWidthAnchorConstant: CGFloat = -80
        static let calcButtonWidthAnchorConstant: CGFloat = -20
        static let graphLineWidthAnchorConstant: CGFloat = 0.5
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
        static let segmentItemName1: String = "Lump-Sum Investing"
        static let segmentItemName2: String = "Dollar-Cost Averaging"
        
        static let coinTypeLabelName: String = "Coin"
        static let buyStartDateLabelName1: String = "Date of Buy"
        static let buyStartDateLabelName2: String = "First Date of Buy"
        static let buyEndDateLabelName: String = "Last Date of Buy"
        static let sellDateLabelName: String = "Date of Sell"
        static let frequencyLabelName: String = "Repeat Buy"
        static let amountLabelName1: String = "Amount"
        static let amountLabelName2: String = "Amount per Once"
        
        static let coinTypeTextFieldPlaceHolder: String = "Choose coin"
        static let buyStartDateTextFieldPlaceHolder: String = "Choose date"
        static let buyEndDateTextFieldPlaceHolder: String = "Choose date"
        static let sellDateTextFieldPlaceHolder: String = "Choose date"
        static let frequencyTextFieldPlaceHolder: String = "Choose frequency"
        static let amountLabelTextFieldPlaceHolder: String = "Enter amount($)"
        
        static let menuName1: String = "Home"
        static let menuName2: String = "Home"
        static let menuName3: String = "Setting"
        
        static let calcStartButtonName: String = "Submit"
        static let calcResetButtonName: String = "Reset"
        static let calcSaveButtonName: String = "Save"
        static let calcShareButtonName: String = "Share"
        static let showChartButtonName: String = "See Timeseries"
    }
        
    struct ImageSetting {
        static let checkMarkYes: UIImage = UIImage(systemName: "checkmark.circle.fill")!
        static let checkMarkNo: UIImage = UIImage(systemName: "xmark.circle.fill")!
    }
    
    struct AnimationSetting {
        static let transitionDuration: Double = 0.25
    }
}
