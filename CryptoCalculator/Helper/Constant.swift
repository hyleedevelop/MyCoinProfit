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
        
        static let themeColor: UIColor = .systemPurple
        // 보라색
        static let themeGradientColor1: UIColor = UIColor(red: 148/255, green: 41/255, blue: 255/255, alpha: 1.0)
        // 청록색
        static let themeGradientColor2: UIColor = UIColor(red: 13/255, green: 167/255, blue: 207/255, alpha: 1.0)
        // 보라색 -> 청록색 3단계
        static let themeGradientThreeColorSet: [UIColor] = [UIColor(rgb: 0x0DA7CF),
                                                            UIColor(rgb: 0x5168E7),
                                                            UIColor(rgb: 0x9429ff)]
        // 보라색 -> 청록색 7단계
        static let themeGradientSevenColorSet: [UIColor] = [UIColor(rgb: 0x0DA7CF),
                                                            UIColor(rgb: 0x2492D7),
                                                            UIColor(rgb: 0x3A7DDF),
                                                            UIColor(rgb: 0x5168E7),
                                                            UIColor(rgb: 0x6753EF),
                                                            UIColor(rgb: 0x7E3EF7),
                                                            UIColor(rgb: 0x9429ff)]
        // 보라색 -> 청록색 10단계  #0DA7CF
        static let themeGradientTenColorSet: [UIColor] = [UIColor(rgb: 0x0DA7CF),
                                                          UIColor(rgb: 0x1C99D4),
                                                          UIColor(rgb: 0x2B8BDA),
                                                          UIColor(rgb: 0x3A7DDF),
                                                          UIColor(rgb: 0x496FE4),
                                                          UIColor(rgb: 0x5861EA),
                                                          UIColor(rgb: 0x6753EF),
                                                          UIColor(rgb: 0x7645F4),
                                                          UIColor(rgb: 0x8537FA),
                                                          UIColor(rgb: 0x9429ff)]
    }
    
    struct CGColorSetting {
        static let deepPurple: CGColor = Constant.UIColorSetting.deepPurple.cgColor
        static let black: CGColor = UIColor.black.cgColor
        
        static let themeColor: CGColor = Constant.UIColorSetting.themeColor.cgColor
    }
    
    struct ShapeSetting {
        static let segmentFontSize: CGFloat = 20
        static let segmentFontWeight: UIFont.Weight = .medium
        
        static let containerCornerRadius: CGFloat = 4
        
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = buttonHeight / 2.0
        
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
        static let buyStartDateLabelName1: String = "Purchase Date"
        static let buyStartDateLabelName2: String = "First Purchase Date"
        static let buyEndDateLabelName: String = "Last Purchase Date"
        static let sellDateLabelName: String = "Sell Date"
        static let frequencyLabelName: String = "Repeat Purchase"
        static let amountLabelName1: String = "Purchase Amount Total"
        static let amountLabelName2: String = "Amount of Each Purchase"
        
        static let coinTypeTextFieldPlaceHolder: String = "Select coin"
        static let buyStartDateTextFieldPlaceHolder1: String = "Select purchase date"
        static let buyStartDateTextFieldPlaceHolder2: String = "Select first purchase date"
        static let buyEndDateTextFieldPlaceHolder: String = "Select last purchase date"
        static let sellDateTextFieldPlaceHolder: String = "Select sell date"
        static let frequencyTextFieldPlaceHolder: String = "Select frequency"
        static let amountLabelTextFieldPlaceHolder1: String = "Enter amount in dollars"
        static let amountLabelTextFieldPlaceHolder2: String = "Enter amount of each purchase in dollars"
        
        static let tabName1: String = "Home"
        static let tabName2: String = "Home"
        static let tabName3: String = "Settings"
        
        static let settingSectionName1: String = "Display"
        static let settingSectionName2: String = "Feedback"
        static let settingSectionName3: String = "About The App"
        
        static let calcStartButtonName: String = "Submit"
        static let calcResetButtonName: String = "Reset"
        static let calcSaveButtonName: String = "Save"
        static let calcShareButtonName: String = "Share"
        static let showChartButtonName: String = "See Timeseries"
    }
    
    struct MessageSetting {
        static let errorTitle = "Error"
        static let resetTitle = "Reset"
        static let closeTitle = "OK"
        static let cancelTitle = "Cancel"
        static let sorryTitle = "Sorry"
        
        static let buyStartDateNoDataErrorMessage1 = "There is no data for the selected purchase date. Please select another one."
        static let buyStartDateNoDataErrorMessage2 = "There is no data for the selected first purchase date. Please select another one."
        static let buyEndDateNoDataErrorMessage = "There is no data for the selected last purchase date. Please select another one."
        static let sellDateNoDataErrorMessage = "There is no data for the selected sell date. Please select another one."
        
        static let coinTypeErrorMessage = "You must select one from the coin list."
        static let buyStartDateErrorMessage1 = "You must select a purchase date."
        static let buyStartDateErrorMessage2 = "You must select the first purchase date."
        static let buyStartDateErrorMessage3 = "The purchase date must be earlier than the sell date."
        static let buyStartDateErrorMessage4 = "The first purchase date must be earlier than the last purchase date."
        static let buyStartDateErrorMessage5 = "The first purchase date must be earlier than the sell date."
        static let buyEndDateErrorMessage1 = "You must select the last purchase date."
        static let buyEndDateErrorMessage2 = "The last purchase date must be later than the first purchase date."
        static let buyEndDateErrorMessage3 = "The last purchase date must be earlier than the sell date."
        static let frequencyErrorMessage = "You must select the repeat purchase frequency."
        static let amountErrorMessage1 = "You must enter purchase amount in dollars."
        static let amountErrorMessage2 = "Only one decimal point is allowed."
        static let amountErrorMessage3 = "You must enter amount of each purchase in dollars."
        static let sellDateErrorMessage1 = "You must select the sell date."
        static let sellDateErrorMessage2 = "The sell date must be later than the purchase date."
        static let sellDateErrorMessage3 = "The sell date must be later than the first purchase date."
        static let sellDateErrorMessage4 = "The sell date must be later than the last purchase date."
        
        static let resetMessage = "Are you sure you want to reset all input?"
        static let exportAsImageMessage = "Do you want to export the result as an image?"
        static let sendEmailErrorMessage = "Check your e-mail settings."
        static let notifyLaterUpdate = "This will be updated later."
    }
     
    struct URLSetting {
        static let termsAndConditionsURL =
        "https://hyleenote.notion.site/hyleenote/Crypto-Calculator-5f6ae38726dd400c8b3a91a24da06795"
    }
    
    struct ImageSetting {
        static let checkMarkYes: UIImage = UIImage(systemName: "checkmark.circle.fill")!
        static let checkMarkNo: UIImage = UIImage(systemName: "xmark.circle.fill")!
    }
    
    struct AnimationSetting {
        static let transitionDuration: Double = 0.25
    }
}
