//
//  Double.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/25.
//

import Foundation

extension Double {
    
    // 가격 >= $10 인 경우, 소수점 아래 1~2자리까지 표시
    private var formatterOfUSDGreatherThanTen: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // $1 <= 가격 < 10$인 경우, 소수점 3~4자리까지 표시
    private var formatterOfUSDFromOneToTen: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 3
        formatter.maximumFractionDigits = 4
        return formatter
    }
    
    // $0.01 <= 가격 < $1인 경우, 소수점 아래 5~6자리까지 표시
    private var formatterOfUSDLessThanOne: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 5
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    // 가격 < $0.01인 경우, 소수점 아래 7~8자리까지 표시
    private var formatterOfUSDLessThanOneOverHundread: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 7
        formatter.maximumFractionDigits = 8
        return formatter
    }
    
    // 소수점 아래 자리 없이 표시하는 원화 가격을 나타내는 NumberFormatter 정의
    private var currencyFormatterKRW: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₩"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    // 퍼센트 값을 소수점 아래 2자리까지 표시
    private var formatterOfPercentage: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .percent
        formatter.percentSymbol = "%"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    // 가격 숫자의 절대값 크기에 따라 소수점 아래 자리수를 다르게 설정
    // 값이 양수인 경우 부호 X, 값이 음수인 경우 부호 O
    func toUSD() -> String {
        if (10...).contains(abs(self)) {
            return formatterOfUSDGreatherThanTen.string(for: self) ?? "$-.--"
        } else if (1.01..<10).contains(abs(self)) {
            return formatterOfUSDFromOneToTen.string(for: self) ?? "$-.----"
        } else if (0.01..<1.01).contains(abs(self)) {
            return formatterOfUSDLessThanOne.string(for: self) ?? "$-.------"
        } else {
            return formatterOfUSDLessThanOneOverHundread.string(for: self) ?? "$-.--------"
        }
    }
    
    // 가격 숫자의 절대값 크기에 따라 소수점 아래 자리수를 다르게 설정
    // 값이 양수인 경우 부호 O, 값이 음수인 경우 부호 O
    func toUSDPlusSigned() -> String {
        if (10...).contains(abs(self)) {
            return self > 0 ? "+\(formatterOfUSDGreatherThanTen.string(for: self) ?? "$-.--")"
                            : "\(formatterOfUSDGreatherThanTen.string(for: self) ?? "$-.--")"
        } else if (1.01..<10).contains(abs(self)) {
            return self > 0 ? "+\(formatterOfUSDFromOneToTen.string(for: self) ?? "$-.----")"
                            : "\(formatterOfUSDFromOneToTen.string(for: self) ?? "$-.----")"
        } else if (0.01..<1.01).contains(abs(self)) {
            return self > 0 ? "+\(formatterOfUSDLessThanOne.string(for: self) ?? "$-.------")"
                            : "\(formatterOfUSDLessThanOne.string(for: self) ?? "$-.------")"
        } else {
            return self > 0 ? "+\(formatterOfUSDLessThanOneOverHundread.string(for: self) ?? "$-.--------")"
                            : "\(formatterOfUSDLessThanOneOverHundread.string(for: self) ?? "$-.--------")"
        }
    }
    
    func toKRW() -> String {
        return currencyFormatterKRW.string(for: self) ?? "₩-"
    }
    
    func toPercentage() -> String {
        return self > 0 ? "+\(formatterOfPercentage.string(for: self) ?? "-.--%")"
                        : "\(formatterOfPercentage.string(for: self) ?? "-.--%")"
    }
    
}
