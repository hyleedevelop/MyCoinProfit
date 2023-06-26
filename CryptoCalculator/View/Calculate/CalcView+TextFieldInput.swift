//
//  CalcView+TextFieldInput.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/26.
//

import UIKit

// TextField 입력값 관련
extension CalcView {
    
    // segmented control의 현재 인덱스
    // 0: LSI, 1: DCA
    var segmentIndex: Int { return self.segmentedControl.selectedSegmentIndex }
    
    // 코인 종류
    var coinType: String { return self.coinTypeTextField.text ?? "" }
    
    // 매수 시작 날짜
    var buyStartDate: String { return self.buyStartDateTextField.text ?? "" }
    
    // 매수 종료 날짜
    var buyEndDate: String { return self.buyEndDateTextField.text ?? "" }
    
    // 매도 날짜
    var sellDate: String { return self.sellDateTextField.text ?? "" }
    
    // 매수 주기
    var frequency: String { self.frequencyTextField.text ?? "" }
    
    // 매수 금액
    var amount: String { self.amountTextField.text ?? "" }
    
    // 입력값 유효성 검사 (순서 유의)
    func validateTextfieldInput(button: UIButton) -> InputError {
        // 코인 종류 선택값이 없는 경우 에러 발생
        guard !self.coinType.isEmpty else { return .coinTypeInputError }
        
        // 매수 날짜 입력값이 없는 경우 에러 발생
        guard !self.buyStartDate.isEmpty else { return .buyStartDateInputError }
        
        // 매수 종료 날짜 입력값이 없는 경우 에러 발생 (DCA 한정)
        if self.segmentIndex == 1 {
            guard !self.buyEndDate.isEmpty else { return .buyEndDateInputError }
        }
        
        // 매도 날짜 입력값이 없는 경우 에러 발생
        guard !self.sellDate.isEmpty else { return .sellDateInputError }
        
        // 매수 반복 주기 입력값이 없는 경우 에러 발생 (DCA 한정)
        if self.segmentIndex == 1 {
            guard !self.frequency.isEmpty else { return .frequencyInputError }
        }

        // 매수 금액 입력값이 없는 경우 에러 발생
        guard !amount.isEmpty else { return .amountInputError }

        // 매수 시작 날짜와 매수 종료 날짜의 선행관계가 잘못된 경우 에러 발생 (DCA 한정)
        if self.segmentIndex == 1 {
            guard self.buyStartDatePicker.date.isValidDateOrder(with: self.buyEndDatePicker.date) else {
                return .buyStartbuyEndInputError
            }
        }

        // 매수 시작 날짜와 매도 날짜의 선행관계가 잘못된 경우 에러 발생
        guard self.buyStartDatePicker.date.isValidDateOrder(with: self.sellDatePicker.date) else {
            return .buyStartSellInputError
        }

        // 매수 종료 날짜와 매도 날짜의 선행관계가 잘못된 경우 에러 발생 (DCA 한정)
        if self.segmentIndex == 1 {
            guard self.buyEndDatePicker.date.isValidDateOrder(with: self.sellDatePicker.date) else {
                return .buyEndSellInputError
            }
        }

        // 매수 금액 입력값에 소수점이 2개 이상 포함된 경우 에러 발생
        guard self.amount.filter({ $0 == "." }).count < 2 else { return .decimalInputError }

        // 모든 검사를 통과했다면 에러 없음 반환
        return .noInputError
    }
    
    // first responder 지정
    func designateFirstResponder(error: InputError) {
        switch error {
        case .coinTypeInputError:
            self.coinTypeTextField.becomeFirstResponder()
        case .buyStartDateInputError, .buyStartbuyEndInputError, .buyStartSellInputError:
            self.buyStartDateTextField.becomeFirstResponder()
        case .buyEndDateInputError, .buyEndSellInputError:
            self.buyEndDateTextField.becomeFirstResponder()
        case .sellDateInputError:
            self.sellDateTextField.becomeFirstResponder()
        case .frequencyInputError:
            self.frequencyTextField.becomeFirstResponder()
        case .amountInputError, .decimalInputError:
            self.amountTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
}
