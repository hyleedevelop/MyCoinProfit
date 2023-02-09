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
        
        static let themeColorNumberKey: String = "themeColorNumber"
        static let themeColorStateKey: String = "themeColorChanged"
        static let themeGradientStartColors: [UIColor]  = [#colorLiteral(red: 0, green: 0.7118151784, blue: 0.8480765224, alpha: 1), #colorLiteral(red: 0.860608995, green: 0.5137880445, blue: 0.7060825229, alpha: 1), #colorLiteral(red: 1, green: 0.5827487245, blue: 0.2789381378, alpha: 1), #colorLiteral(red: 1, green: 0.8980392157, blue: 0.9254901961, alpha: 1), #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.4117647059, alpha: 1), #colorLiteral(red: 0.7921568627, green: 0.9411764706, blue: 0.9725490196, alpha: 1), #colorLiteral(red: 0.8705882353, green: 0.7882352941, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.9294117647, green: 0.8784313725, blue: 0.831372549, alpha: 1)]
        static let themeGradientMiddleColors: [UIColor] = [#colorLiteral(red: 0.4268131554, green: 0.5237367749, blue: 0.8903746009, alpha: 1), #colorLiteral(red: 0.593103528, green: 0.7224785686, blue: 0.9253215194, alpha: 1), #colorLiteral(red: 0.8889493298, green: 0.2, blue: 0.7725490196, alpha: 1), #colorLiteral(red: 1, green: 0.7019607843, blue: 0.7764705882, alpha: 1), #colorLiteral(red: 0.6588235294, green: 0.8235294118, blue: 0.4274509804, alpha: 1), #colorLiteral(red: 0, green: 0.7058823529, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0.6274509804, green: 0.4235294118, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.8666666667, green: 0.7215686275, blue: 0.5725490196, alpha: 1)]
        static let themeGradientEndColors: [UIColor]    = [#colorLiteral(red: 0.6540915966, green: 0.3039287329, blue: 1, alpha: 1), #colorLiteral(red: 0.4219039679, green: 0.9795603156, blue: 0.9568110108, alpha: 1), #colorLiteral(red: 0.5294117647, green: 0.6039215686, blue: 0.9490196078, alpha: 1), #colorLiteral(red: 0.9843137255, green: 0.4352941176, blue: 0.5725490196, alpha: 1), #colorLiteral(red: 0.3607843137, green: 0.6980392157, blue: 0.4392156863, alpha: 1), #colorLiteral(red: 0.01176470588, green: 0.01568627451, blue: 0.368627451, alpha: 1), #colorLiteral(red: 0.3843137255, green: 0.2784313725, blue: 0.6666666667, alpha: 1), #colorLiteral(red: 0.4980392157, green: 0.3333333333, blue: 0.2235294118, alpha: 1)]
        
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
        // 보라색 -> 청록색 10단계
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
        
        static let containerCornerRadius: CGFloat = 8
        
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
        
        static let standardTimeZone: TimeZone = TimeZone(identifier: TimeZone.current.identifier)!
        static let standardLocale: Locale = Locale(identifier: "en_US")
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
        
        static let tabName1: String = "Calculate"
        static let tabName2: String = "Home"
        static let tabName3: String = "More"
        
        static let settingSectionName1: String = "Display"
        static let settingSectionName2: String = "Feedback"
        static let settingSectionName3: String = "About The App"
        
        static let calcStartButtonName: String = "Submit"
        static let calcResetButtonName: String = "Reset"
        static let calcSaveButtonName: String = "Save"
        static let calcShareButtonName: String = "Share"
        static let showChartButtonName: String = "See Timeseries"
        static let themeColorSettingButtonName: String = "Apply"
    }
    
    struct MessageSetting {
        static let confirmTitle = "Confirm"
        static let errorTitle = "Error"
        static let resetTitle = "Reset"
        static let closeTitle = "OK"
        static let cancelTitle = "Cancel"
        static let sorryTitle = "Sorry"
        
        static let buyStartDateNoDataErrorMessage1 = "There is no data for the selected purchase date. Please select another one."
        static let buyStartDateNoDataErrorMessage2 = "There is no data for the selected first purchase date. Please select another one."
        static let buyEndDateNoDataErrorMessage = "There is no data for the selected last purchase date. Please select another one."
        static let sellDateNoDataErrorMessage = "There is no data for the selected sell date. Please select another one."
        
        static let coinTypeErrorMessage = "You must select the coin."
        static let buyStartDateErrorMessage1 = "You must select the purchase date."
        static let buyStartDateErrorMessage2 = "You must select the first purchase date."
        static let buyStartDateErrorMessage3 = "The purchase date must be earlier than the sell date."
        static let buyStartDateErrorMessage4 = "The first purchase date must be earlier than the last purchase date."
        static let buyStartDateErrorMessage5 = "The first purchase date must be earlier than the sell date."
        static let buyEndDateErrorMessage1 = "You must select the last purchase date."
        static let buyEndDateErrorMessage2 = "The last purchase date must be later than the first purchase date."
        static let buyEndDateErrorMessage3 = "The last purchase date must be earlier than the sell date."
        static let frequencyErrorMessage = "You must select the repeat purchase frequency."
        static let amountErrorMessage1 = "You must enter the purchase amount in dollars."
        static let amountErrorMessage2 = "Only one decimal point is allowed."
        static let amountErrorMessage3 = "You must enter the amount of each purchase in dollars."
        static let sellDateErrorMessage1 = "You must select the sell date."
        static let sellDateErrorMessage2 = "The sell date must be later than the purchase date."
        static let sellDateErrorMessage3 = "The sell date must be later than the first purchase date."
        static let sellDateErrorMessage4 = "The sell date must be later than the last purchase date."
        
        static let coinSelectMessage = "Do you want to select"
        static let resetMessage = "Are you sure you want to reset all input?"
        static let exportAsImageMessage = "Do you want to export the result as an image?"
        static let sendEmailErrorMessage = "Check your e-mail settings."
        static let notifyLaterUpdate = "This will be updated soon."
        static let themeColorMessage = "The new theme color has been applied."
    }
     
    struct URLSetting {
        static let helpURL =
        "https://hyleenote.notion.site/Crypto-Calculator-5f6ae38726dd400c8b3a91a24da06795"
        static let privacyPolicyURL =
        "https://hyleenote.notion.site/Privacy-Policy-98bd35e6626c4accbd609616553b071e"
        static let termsAndConditionsURL =
        "https://hyleenote.notion.site/Terms-Conditions-037cf1cf478f4925bdc69f5404091242"
        static let writeReviewURL =
        "https://apps.apple.com/app/id1668703292?action=write-review"
        
        static let admobBottomBannerMyID = "ca-app-pub-5804054899003424/3613736945"
        static let admobBottomBannerTestID = "ca-app-pub-3940256099942544/2934735716"
        static let admobAppOpenMyID = "ca-app-pub-5804054899003424/7922125962"
        static let admobAppOpenTestID = "ca-app-pub-3940256099942544/5662855259"
    }
    
}
