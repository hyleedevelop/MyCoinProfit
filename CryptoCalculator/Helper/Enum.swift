//
//  Enum.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/22.
//

import Foundation

enum InvestmentStyle {
    case intensive
    case averaged
}

// 날짜 TextField 입력값 관련 에러 (에러메세지를 출력하는 함수의 파라미터로 전달, 계산 실행여부 결정)
enum InputError {
    case noInputError  // 에러 없음
    case coinTypeInputError  // 코인 타입 입력값 에러
    case buyStartDateInputError  // 매수 시작 날짜 입력값 에러
    case buyEndDateInputError  // 매수 종료 날짜 입력값 에러
    case sellDateInputError  // 매도 날짜 입력값 에러
    case frequencyInputError  // 매수 반복 주기 입력값 에러
    case amountInputError  // 매수 금액 입력값 에러
    case decimalInputError  // 소수점(.) 입력값 에러
    case buyStartbuyEndInputError  // 매수시작날짜 >= 매수종료날짜 에러
    case buyStartSellInputError  // 매수시작날짜 >= 매도날짜 에러
    case buyEndSellInputError  // 매수종료날짜 >= 매도날짜 에러
}


