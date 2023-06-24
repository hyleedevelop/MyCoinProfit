//
//  CalcViewController+Input.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/06/23.
//

import UIKit

//MARK: - 날짜 TextField 입력값 관련 에러 (에러메세지를 출력하는 함수의 파라미터로 전달, 계산 실행여부 결정)

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

//MARK: - CalcViewController에서 입력값 처리와 관련된 코드

extension CalcViewController {
    
    //MARK: - PickerView 설정
    
    internal func setupPickerView() {
        // UIPickerView 사용 시 delegate 패턴으로 구현 (UIDatePickerView는 필요없음)
        [calcView.coinTypePicker, calcView.frequencyPicker].forEach { $0.delegate = self }
    
        // TextField 편집 시작 시 실행할 메서드 설정
        [self.calcView.coinTypeTextField, self.calcView.buyStartDateTextField,
         self.calcView.buyEndDateTextField, self.calcView.sellDateTextField,
         self.calcView.frequencyTextField].forEach {
            $0.addTarget(self, action: #selector(self.textFieldAction(_:)), for: .editingDidBegin)
        }
        
        // Picker 값 변경 시 실행할 메서드 설정
        [self.calcView.buyStartDatePicker,
         self.calcView.buyEndDatePicker,
         self.calcView.sellDatePicker].forEach {
            $0.addTarget(self, action: #selector(self.datePickerAction(_:)), for: .valueChanged)
        }
        
        // Picker가 선택되어 있는 기본값
        self.calcView.frequencyPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    //MARK: - TextField 설정
    
    internal func setupTextField() {
        [calcView.coinTypeTextField, calcView.buyStartDateTextField, calcView.buyEndDateTextField,
         calcView.sellDateTextField, calcView.frequencyTextField, calcView.amountTextField]
            .forEach { $0.delegate = self }
    }
    
    //MARK: - 활성화 시점에 보여줄 기본값 설정
    
    // type 관련 TextField가 활성화되는 시점에서 TextField와 Picker의 기본값 설정
    @objc internal func textFieldAction(_ textField: UITextField) {
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = "MMM dd, yyyy"
        selectedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        selectedDateFormatter.locale = Constant.DateSetting.standardLocale

        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        convertedDateFormatter.locale = Constant.DateSetting.standardLocale
        
        if self.calcView.buyStartDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.buyStartMaximumDate
            if self.calcView.buyStartDateTextField.text == "" && self.buyStartDateDefaultSetting {
                self.calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                self.buyStartDateDefaultSetting.toggle()
            } else if self.calcView.buyStartDateTextField.text == "" && !self.buyStartDateDefaultSetting {
                self.calcView.buyStartDatePicker.date = maximumDate
                self.calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if self.calcView.buyEndDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.buyEndMaximumDate
            
            if self.calcView.buyEndDateTextField.text == "" && self.buyEndDateDefaultSetting {
                self.calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                self.buyEndDateDefaultSetting.toggle()
            } else if self.calcView.buyEndDateTextField.text == "" && !self.buyEndDateDefaultSetting {
                self.calcView.buyEndDatePicker.date = maximumDate
                self.calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if self.calcView.sellDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.sellMaximumDate
            
            if self.calcView.sellDateTextField.text == "" && self.sellDateDefaultSetting {
                self.calcView.sellDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.sellDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                self.sellDateDefaultSetting.toggle()
            } else if calcView.sellDateTextField.text == "" && !self.sellDateDefaultSetting {
                self.calcView.sellDatePicker.date = maximumDate
                self.calcView.sellDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.sellDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if self.calcView.frequencyTextField.isFirstResponder {
            let index = self.calcView.frequencyPicker.selectedRow(inComponent: 0)
            self.calcView.frequencyTextField.text = self.coinListData.frequencyArray[index]
        }
    }
    
    // Date 관련 PickerView에서 선택 값이 변경되었을 때 주어진 날짜 형식의 텍스트값 보이기
    @objc internal func datePickerAction(_ sender: UIDatePicker) {
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = "MMM dd, yyyy"
        selectedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        selectedDateFormatter.locale = Constant.DateSetting.standardLocale
        
        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        convertedDateFormatter.locale = Constant.DateSetting.standardLocale
        
        if sender == self.calcView.buyStartDatePicker {
            self.calcView.buyStartDateTextField.textColor = .label
            self.calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: sender.date)
            self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: sender.date)
        }
        else if sender == self.calcView.buyEndDatePicker {
            self.calcView.buyEndDateTextField.textColor = .label
            self.calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: sender.date)
            self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: sender.date)
        }
        else if sender == self.calcView.sellDatePicker {
            self.calcView.sellDateTextField.textColor = .label
            self.calcView.sellDateTextField.text = selectedDateFormatter.string(from: sender.date)
            self.sellDateStringToCalculate = convertedDateFormatter.string(from: sender.date)
        }
    }
    
    //MARK: - 입력값 유효성 검사
    
    internal func validateTextfieldInput(type: Int, button: UIButton) -> InputError {
        let coinType = calcView.coinTypeTextField.text ?? ""
        let buyStartDate = calcView.buyStartDateTextField.text ?? ""
        let buyEndDate = calcView.buyEndDateTextField.text ?? ""
        let sellDate = calcView.sellDateTextField.text ?? ""
        let frequency = calcView.frequencyTextField.text ?? ""
        let amount = calcView.amountTextField.text ?? ""
        
        // 코인 종류 선택값이 없는 경우
        if coinType.isEmpty {
            showPopUpMessage(
                with: button,
                title: Constant.MessageSetting.errorTitle,
                message: Constant.MessageSetting.coinTypeErrorMessage,
                responder: calcView.coinTypeTextField
            )
            return .coinTypeInputError
        }
        
        switch type {
            
            // 0: 일괄매수를 선택한 경우
        case 0:
            // 매수 날짜 입력값이 없는 경우
            if buyStartDate.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyStartDateErrorMessage1,
                    responder: calcView.buyStartDateTextField
                )
                return .buyStartDateInputError
            }
            // 매수 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
            else if !sellDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(
                with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyStartDateErrorMessage3,
                    responder: calcView.buyStartDateTextField
                )
                return .buyStartSellInputError
            }
            
            // 매도 날짜 입력값이 없는 경우
            if sellDate.isEmpty {
                showPopUpMessage(
                    with: button, title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.sellDateErrorMessage1,
                    responder: calcView.sellDateTextField
                )
                return .sellDateInputError
            }
            // 매도 날짜 입력값이 존재하지만, 매수 날짜보다 이전 시점인 경우
            else if !buyStartDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.sellDateErrorMessage2,
                    responder: calcView.sellDateTextField
                )
                return .buyStartSellInputError
            }
            
            // 매수 금액 입력값이 없는 경우
            if amount.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.amountErrorMessage1,
                    responder: calcView.amountTextField
                )
                return .amountInputError
            }
            // 매수 금액 입력값에 소수점이 2개 이상 포함된 경우
            else if amount.filter({ $0 == "." }).count > 1 {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.amountErrorMessage2,
                    responder: calcView.amountTextField
                )
                return .decimalInputError
            }
            
            // 1: 분할매수를 선택한 경우
        case 1:
            // 매수 시작 날짜 입력값이 없는 경우
            if buyStartDate.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyStartDateErrorMessage2,
                    responder: calcView.buyStartDateTextField
                )
                return .buyStartDateInputError
            }
            // 매수 시작 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이후 시점인 경우
            else if !buyStartDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(
                with: calcView.buyEndDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyStartDateErrorMessage4,
                    responder: calcView.buyStartDateTextField
                )
                return .buyStartbuyEndInputError
            }
            // 매수 시작 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
            else if !buyStartDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(
                with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyStartDateErrorMessage5,
                    responder: calcView.buyStartDateTextField
                )
                return .buyStartSellInputError
            }
            
            // 매수 종료 날짜 입력값이 없는 경우
            if buyEndDate.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyEndDateErrorMessage1,
                    responder: calcView.buyEndDateTextField
                )
                return .buyEndDateInputError
            }
            // 매수 종료 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
            else if !buyEndDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(
                with: calcView.buyEndDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyEndDateErrorMessage2,
                    responder: calcView.buyEndDateTextField
                )
                return .buyStartbuyEndInputError
            }
            // 매수 종료 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
            else if !buyEndDate.isEmpty && !calcView.buyEndDatePicker.date.isValidDateOrder(
                with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.buyEndDateErrorMessage3,
                    responder: calcView.buyEndDateTextField
                )
                return .buyEndSellInputError
            }
            
            // 매도 날짜 입력값이 없는 경우
            if sellDate.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.sellDateErrorMessage1,
                    responder: calcView.sellDateTextField
                )
                return .sellDateInputError
            }
            // 매도 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
            else if !buyStartDate.isEmpty && !calcView.buyStartDatePicker.date.isValidDateOrder(
                with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.sellDateErrorMessage3,
                    responder: calcView.sellDateTextField)
                return .buyStartSellInputError
            }
            // 매도 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이전 시점인 경우
            else if !buyStartDate.isEmpty && !calcView.buyEndDatePicker.date.isValidDateOrder(
                with: calcView.sellDatePicker.date) {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.sellDateErrorMessage3,
                    responder: calcView.sellDateTextField
                )
                return .buyEndSellInputError
            }
            
            // 매수 반복 주기 입력값이 없는 경우
            if frequency.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.frequencyErrorMessage,
                    responder: calcView.frequencyTextField
                )
                return .frequencyInputError
            }
            
            // 매번 매수 금액 입력값이 없는 경우
            if amount.isEmpty {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.amountErrorMessage3,
                    responder: calcView.amountTextField
                )
                return .amountInputError
            }
            // 매 회 매수 금액 입력값에 소수점이 2개 이상 포함된 경우
            else if amount.filter({ $0 == "." }).count > 1 {
                showPopUpMessage(
                    with: button,
                    title: Constant.MessageSetting.errorTitle,
                    message: Constant.MessageSetting.amountErrorMessage2,
                    responder: calcView.amountTextField
                )
                return .decimalInputError
            }
            
        default:
            break
        }
        
        return .noInputError
        
    }
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CalcViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == calcView.frequencyPicker ? coinListData.frequencyArray.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == calcView.frequencyPicker {
            calcView.frequencyTextField.text = coinListData.frequencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == calcView.frequencyPicker ? coinListData.frequencyArray[row] : nil
    }
    
}

//MARK: - UITextFieldDelegate
// ViewController에서 Delegate 프로토콜을 채택하는 경우 xxx.delegate = self를 꼭 써줘야 함
// View에서는 프로토콜 채택만 하면 됨

extension CalcViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // return 버튼을 눌렀을 때 실행할 내용
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // TextField 편집이 시작되었을 때 실행할 내용
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == calcView.coinTypeTextField {
            // 코인 리스트를 보여주는 VC의 인스턴스 생성
            let coinVC = CoinListViewController()
            let nav = UINavigationController(rootViewController: coinVC)
            
            // 화면 스타일 설정
            nav.modalPresentationStyle = .fullScreen
            nav.isModalInPresentation = true  // true이면 dismiss 할 수 없음
            
            // sheetPresentationController는 iOS 15 이상부터 사용 가능
            if let sheet = nav.sheetPresentationController {
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.detents = [.large()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.preferredCornerRadius = 25
                sheet.prefersGrabberVisible = false
            }
            //self.present(nav, animated: true, completion: nil)
            self.present(nav, animated: true, completion: nil)
        }

        if textField == calcView.amountTextField {
            calcView.amountTextField.text = calcView.amountTextField.text?.replacingOccurrences(of: ",", with: "")
        }
    }
    
    // TextField 편집이 종료되었을 때 실행할 내용
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    // 한 글자씩 입력이 끝날 때마다 입력된 내용을 허용할지 말지 결정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // amountTextField만 숫자와 온점(.) 입력을 허용하고 최대 9자리의 숫자로 제한
        if textField == calcView.amountTextField {
            if string.count > 0 {
                // TextField에 실수(숫자+소수점)만 입력할 수 있는 Set 설정
                var charSet = CharacterSet.decimalDigits
                charSet.insert(charactersIn: "0123456789.")
                
                // charSet에 속하지 않는 문자(charSet.inverted)가 없는 경우
                // 즉, charSet에 속하는 문자인 경우 guard문 통과
                guard string.rangeOfCharacter(from: charSet.inverted) == nil else { return false }
                
                // 최대 글자수 제한을 두고 글자수가 그보다 작은 경우 입력을 허용
                let maxLength = calcView.segmentedControl.selectedSegmentIndex == 0 ? 12 : 9
                guard range.location < maxLength else { return false }
            }
            
            // 위의 조건들을 모두 만족해서 여기까지 왔다면 입력 허용
            return true
        }
        
        // 나머지 TextField는 모두 글자 입력을 허용하지 않음
        return false
    }
    
}
