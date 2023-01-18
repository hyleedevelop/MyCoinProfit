//
//  UILabel.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/16.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(_ value: Double = +0.03) {
        let kernValue = self.font.pointSize * CGFloat(value)
        guard let text = text, !text.isEmpty else { return }
        let string = NSMutableAttributedString(string: text)
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
    
//    func addCharacterSpacing(kernValue:Double = 0.5) {
//        guard let text = text, !text.isEmpty else { return }
//        let string = NSMutableAttributedString(string: text)
//        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
//        attributedText = string
//    }
}
