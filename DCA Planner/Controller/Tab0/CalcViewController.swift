//
//  CalcTypeViewController.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcViewController: UIViewController {

    private let calcView = CalcView()  // UIView
    private let coinListData = PickerData()  // structure
    
    var historyDict = [String: [[Double?]]]()  // JSON parsing이 끝난 뒤 히스토리 데이터를 담을 딕셔너리
    
    var coinTypeString: String = ""
    var startDateString: String = ""
    var endDateString: String = ""
    
    // 날짜 TextField 입력값 관련 에러 (에러메세지를 출력하는 함수의 파라미터로 전달, 계산 실행여부 결정)
    enum InputError: Int {
        case noInputError = 0  // 에러 없음
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
        /*
         ✅ 날짜간의의 선행/후행 관계에 따른 에러 발생 시 처리하는 코드 짜기
         */
    }
    
    var inputError: InputError = .noInputError
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        //setupToolBar()
        setupPickerView()
        setupButton()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.title = Constant.TitleSetting.menuName2
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
  
    override func loadView() {
        view = calcView
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // ToolBar 설정
    private func setupToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        let toolBarFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarDoneButton = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: #selector(doneButtonTapped(_:)))
        toolBar.sizeToFit()
        toolBar.setItems([toolBarFlexibleSpace, toolBarDoneButton], animated: true)
        
        _ = [calcView.coinTypeTextField, calcView.buyStartDateTextField, calcView.buyEndDateTextField, calcView.sellDateTextField, calcView.amountTextField, calcView.frequencyTextField].map { $0.inputAccessoryView = toolBar }
    }
    
    // PickerView 설정
    private func setupPickerView() {
        // UIPickerView 사용 시 delegate 패턴으로 구현 (UIDatePickerView는 필요없음)
        _ = [calcView.coinTypePicker, calcView.frequencyPicker].map { $0.delegate = self }
    
        calcView.coinTypeTextField.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.buyStartDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.buyEndDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.sellDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.frequencyTextField.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
    }
    
    // Button 설정
    private func setupButton() {
        calcView.calcStartButton.addTarget(self, action: #selector(calcStartButtonTapped(_:)), for: .touchUpInside)
        calcView.calcResetButton.addTarget(self, action: #selector(calcResetButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupTextField() {
        calcView.coinTypeTextField.delegate = self
        calcView.buyStartDateTextField.delegate = self
        calcView.buyEndDateTextField.delegate = self
        calcView.sellDateTextField.delegate = self
        calcView.frequencyTextField.delegate = self
        calcView.amountTextField.delegate = self
    }
    
    private func presentPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?, error errorType: InputError) {
        if button == calcView.calcStartButton {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
            
            // 특정 TextField의 내용이 제대로 입력되지 않은 경우, 확인 버튼을 누르면 해당 TextField가 활성화되도록 설정
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                guard let tf = textField else { return }
                tf.becomeFirstResponder()
            }
                        
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }

        if button == calcView.calcResetButton {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
                // 입력된 내용 모두 지우기
                _ = [self.calcView.coinTypeTextField, self.calcView.buyStartDateTextField, self.calcView.buyEndDateTextField, self.calcView.sellDateTextField, self.calcView.frequencyTextField, self.calcView.amountTextField].map { $0.text = "" }
                
                // 체크마크 숨기기
                _ = [self.calcView.coinTypeCheckMark, self.calcView.buyStartDateCheckMark, self.calcView.buyEndDateCheckMark, self.calcView.sellDateCheckMark, self.calcView.frequencyCheckMark, self.calcView.amountCheckMark].map { $0.image = Constant.ImageSetting.checkMarkNo }
                _ = [self.calcView.coinTypeCheckMark, self.calcView.buyStartDateCheckMark, self.calcView.buyEndDateCheckMark, self.calcView.sellDateCheckMark, self.calcView.frequencyCheckMark, self.calcView.amountCheckMark].map { $0.tintColor = .clear }
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // withTimeInterval(초)만큼 팝업메세지 유지 후 사라지도록 설정
        //Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false,
        //                     block: { _ in alert.dismiss(animated: true, completion: nil)})
    }
    
    // 수익계산 결과를 메세지로 출력
    private func presentResult(segment segmentIndex: Int, with result: Any) {
        var messageString: String = ""
        
        let downcastingResult = result as! (Double, Double, Double, Double)
        messageString = "원금: \(downcastingResult.0.toUSD())" + "\n" +
                        "수익률: \(downcastingResult.1.toPercentage())" + "\n" +
                        "수익금: \(downcastingResult.2.toUSD())" + "\n" +
                        "평가금: \(downcastingResult.3.toUSD())"
        
        let alert = UIAlertController(title: "계산 결과", message: messageString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // 키보드 또는 피커뷰 위 Toolbar의 닫기 버튼을 눌렀을 때
    @objc private func doneButtonTapped(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    // PickerView에서 항목을 선택했을 때
    @objc private func pickerSelected(_ sender: UIDatePicker) {
        let pickedDate = sender.date
        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy-MM-dd"
        pickedDateFormatter1.timeZone = TimeZone(abbreviation: "KST")
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        
        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        
        if sender == calcView.coinTypePicker {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateTextField.text = self.coinTypeString
        }
        
        if sender == calcView.buyStartDatePicker {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        }
        
        if sender == calcView.buyEndDatePicker {
            calcView.buyEndDateTextField.textColor = .label
            calcView.buyEndDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        }
        
        if sender == calcView.sellDatePicker {
            calcView.sellDateTextField.textColor = .label
            calcView.sellDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        }
                    
        //self.endDateString = pickedDateFormatter2.string(from: pickedDate)
        //print("endDateString: \(endDateString)")
    }
    
    // 버튼을 눌렀을 때
    @objc private func calcStartButtonTapped(_ button: UIButton) {
        // (a) 일괄매수를 선택한 경우
        if calcView.segmentedControl.selectedSegmentIndex == 0 {
            
            // 입력값 검사
            if calcView.coinTypeTextField.text == "" {
                inputError = .coinTypeInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.coinTypeLabel.text!)를 선택하세요",
                                    responder: calcView.coinTypeTextField, error: .buyEndDateInputError)
            }
            
            if calcView.buyStartDateTextField.text == "" {
                inputError = .buyStartDateInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyStartDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyStartDateTextField, error: .buyStartDateInputError)
            }
            
            if calcView.sellDateTextField.text == "" {
                inputError = .sellDateInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.sellDateLabel.text!)를 선택하세요",
                                    responder: calcView.sellDateTextField, error: .sellDateInputError)
            }
            
            if calcView.amountTextField.text == "" {
                inputError = .amountInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.amountLabel.text!)를 입력하세요",
                                    responder: calcView.amountTextField, error: .amountInputError)
            } else {
                if inputError == .decimalInputError {
                    presentPopUpMessage(with: button, title: "오류", message: "소수점을 올바르게 입력해 주세요", responder: calcView.amountTextField, error: .decimalInputError)
                }
            }
            
            if inputError == .noInputError {
                // 계산 작업 시작 -> activityIndicator 표시하기
                DispatchQueue.main.async {
                    self.calcView.activityIndicator.startAnimating()
                }
                
                // API로 데이터 가져오기 및 수익계산에 필요한 저장속성
                let coinTypeString: String = calcView.coinTypeTextField.text!.lowercased()
                let buyStartDateString: String = calcView.buyStartDateTextField.text!
                let sellDateString: String = calcView.sellDateTextField.text!
                let amountString: String = calcView.amountTextField.text!
                let buyToNowLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartToNow, start: buyStartDateString, end: nil)
                
                // 위의 if문을 통해 모든 입력 값의 검사를 통과했다면 API로 가격 히스토리 데이터 가져오기
                NetworkManager.shared.fetchPriceHistory(with: coinTypeString, duration: buyToNowLength) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let historyInfo):
                        self.historyDict = historyInfo
                        
                        CalcManager.shared.calculateROIIntensive(with: self.historyDict, amount: Double(amountString)!, buy: buyStartDateString, sell: sellDateString) { (amount, roi, profit, balance, errorCode) in
                            switch errorCode {
                            case .noDateError:
                                print("<일괄매수 수익 계산 결과>")
                                print("원금: \(amount.toUSD())")
                                print("수익률: \(roi.toPercentage())")
                                print("수익금: \(profit.toUSD())")
                                print("평가금: \(balance.toUSD())")
                                
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    // 계산 작업 종료 -> activityIndicator 숨기기
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.presentResult(segment: 0, with: (amount, roi, profit, balance))
                                }
                            case .buyStartDateError:
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 날짜의 코인 데이터가 없습니다.\n매수 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .buyEndDateError:
                                fallthrough
                            case .sellDateError:
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매도 날짜의 코인 데이터가 없습니다.\n매도 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    case .failure(.networkingError):
                        print("ERROR: networking")
                        
                    case .failure(.dataError):
                        print("ERROR: data")
                        
                    case .failure(.parseError):
                        print("ERROR: parse")
                        
                    }
                }
            }
            
        }
        
        // (b) 분할매수를 선택한 경우
        if calcView.segmentedControl.selectedSegmentIndex == 1 {
            
            // 입력값 검사
            if calcView.coinTypeTextField.text == "" {
                inputError = .coinTypeInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.coinTypeLabel.text!)를 선택하세요",
                                    responder: calcView.coinTypeTextField, error: .coinTypeInputError)
            }
            
            if calcView.buyStartDateTextField.text == "" {
                inputError = .buyStartDateInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyStartDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyStartDateTextField, error: .buyStartDateInputError)
            }
            
            if calcView.buyEndDateTextField.text == "" {
                inputError = .buyEndDateInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyEndDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyEndDateTextField, error: .buyEndDateInputError)
            }
            
            if calcView.sellDateTextField.text == "" {
                inputError = .sellDateInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.sellDateLabel.text!)를 선택하세요",
                                    responder: calcView.sellDateTextField, error: .sellDateInputError)
            }
            
            if calcView.frequencyTextField.text == "" {
                inputError = .frequencyInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.frequencyLabel.text!)를 선택하세요",
                                    responder: calcView.frequencyTextField, error: .frequencyInputError)
            }
            
            if calcView.amountTextField.text == "" {
                inputError = .amountInputError
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.amountLabel.text!)를 입력하세요",
                                    responder: calcView.amountTextField, error: .amountInputError)
            } else {
                if inputError == .decimalInputError {
                    presentPopUpMessage(with: button, title: "오류", message: "소수점을 바르게 입력해 주세요", responder: calcView.amountTextField, error: .decimalInputError)
                }
            }
            
            if inputError == .noInputError {
                // 계산 작업 시작 -> activityIndicator 표시하기
                DispatchQueue.main.async {
                    self.calcView.activityIndicator.startAnimating()
                }
                
                // API로 데이터 가져오기 및 수익계산에 필요한 저장속성
                let coinTypeString: String = calcView.coinTypeTextField.text!.lowercased()
                let buyStartDateString: String = calcView.buyStartDateTextField.text!
                let buyEndDateString: String = calcView.buyEndDateTextField.text!
                let sellDateString: String = calcView.sellDateTextField.text!
                let frequencyString: String = calcView.frequencyTextField.text!
                let amountString: String = calcView.amountTextField.text!
                let buyStartTobuyEndLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartTobuyEnd, start: buyStartDateString, end: buyEndDateString)
                let buyStartToSellLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartToSell, start: buyStartDateString, end: sellDateString)
                let buyToNowLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartToNow, start: buyStartDateString, end: nil)
                
                print(coinTypeString)
                print(buyStartDateString)
                print(buyEndDateString)
                print(sellDateString)
                print(frequencyString)
                print(amountString)
                print(buyStartTobuyEndLength)
                print(buyStartToSellLength)
                print(buyToNowLength)
                
                // 위의 if문을 통해 모든 입력 값의 검사를 통과했다면 API로 가격 히스토리 데이터 가져오기
                NetworkManager.shared.fetchPriceHistory(with: coinTypeString, duration: buyToNowLength) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let historyInfo):
                        self.historyDict = historyInfo
                        
                        CalcManager.shared.calculateROIAveraged(with: self.historyDict, amount: Double(amountString)!, buyStart: buyStartDateString, buyEnd: buyEndDateString, sell: sellDateString) { (amount, roi, profit, balance, errorCode) in
                            switch errorCode {
                            case .noDateError:
                                print("<분할매수 수익 계산 결과>")
                                print("원금: \(amount.toUSD())")
                                print("수익률: \(roi.toPercentage())")
                                print("수익금: \(profit.toUSD())")
                                print("평가금: \(balance.toUSD())")
                                
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    // 계산 작업 종료 -> activityIndicator 숨기기
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.presentResult(segment: self.calcView.segmentedControl.selectedSegmentIndex, with: (amount, roi, profit, balance))
                                }
                            case .buyStartDateError:
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 시작 날짜의 코인 데이터가 없습니다.\n매수 시작 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .buyEndDateError:
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 종료 날짜의 코인 데이터가 없습니다.\n매수 종료 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .sellDateError:
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매도 날짜의 코인 데이터가 없습니다.\n매도 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    case .failure(.networkingError):
                        print("ERROR: networking")
                        
                    case .failure(.dataError):
                        print("ERROR: data")
                        
                    case .failure(.parseError):
                        print("ERROR: parse")
                        
                    }
                }
            }
            
        }
        
    }
    
    @objc private func calcResetButtonTapped(_ button: UIButton) {
        // Alert 메세지 표시
        presentPopUpMessage(with: button, title: calcView.calcResetButton.currentTitle!,
                            message: "입력된 내용을 모두 지우시겠습니까?", responder: nil, error: .noInputError)
    }
    
    @objc private func addButtonTapped() {
        let bookmarkVC = BookmarkViewController()
        navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    @objc private func helpButtonTapped() {
        // 도움말 VC 인스턴스 생성
        let coinHelpModalVC = CoinHelpModalViewController()
        // 도움말 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: coinHelpModalVC)
        
        // Bottom Sheet 관련 설정
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = false  // true이면 dismiss 할 수 없음
        
        // sheetPresentationController는 iOS 15 이상부터 사용 가능
        if let sheet = nav.sheetPresentationController {
            // Bottom Sheet를 확장/축소 했을 때 화면 꼭대기가 걸리는 높이 지정
            //sheet.largestUndimmedDetentIdentifier = .medium
            //sheet.detents = [.medium(), .large()]
            if #available(iOS 16.0, *) {
                // iOS 16 이상부터 커스텀으로 높이를 결정할 수 있음
                // iOS 15는 .medium()과 .large() 둘 중 하나만 가능
                sheet.detents = [.custom(resolver: { context in
                    return context.maximumDetentValue * 0.7
                })]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = true
        }
        self.present(nav, animated: true, completion: nil)
    }
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CalcViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == calcView.coinTypePicker {
            return coinListData.coinNameArray.count
        }

        if pickerView == calcView.frequencyPicker {
            return coinListData.frequencyArray.count
        }

        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == calcView.coinTypePicker {
            calcView.coinTypeTextField.text = coinListData.coinNameArray[row]
        }
        
        if pickerView == calcView.frequencyPicker {
            calcView.frequencyTextField.text = coinListData.frequencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == calcView.coinTypePicker {
            return coinListData.coinNameArray[row]
        }

        if pickerView == calcView.frequencyPicker {
            return coinListData.frequencyArray[row]
        }
        
        return nil
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
            calcView.coinTypeLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.coinTypeTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.coinTypeBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }

        if textField == calcView.buyStartDateTextField {
            calcView.buyStartDateLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.buyStartDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.buyStartDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }

        if textField == calcView.buyEndDateTextField {
            calcView.buyEndDateLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.buyEndDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.buyEndDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }

        if textField == calcView.sellDateTextField {
            calcView.sellDateLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.sellDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.sellDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }

        if textField == calcView.frequencyTextField {
            calcView.frequencyLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.frequencyTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.frequencyBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }

        if textField == calcView.amountTextField {
            calcView.amountLabel.textColor = Constant.UIColorSetting.themeColor
            calcView.amountTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.amountBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
            calcView.amountTextField.text = calcView.amountTextField.text?.replacingOccurrences(of: ",", with: "")
        }
    }
    
    // TextField 편집이 종료되었을 때 실행할 내용
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == calcView.coinTypeTextField {
            calcView.coinTypeTextField.textColor = .label
            calcView.coinTypeLabel.textColor = .label
            calcView.coinTypeBottomLine.backgroundColor = .label
            
            if calcView.coinTypeTextField.text != "" {
                calcView.coinTypeCheckMark.image = Constant.ImageSetting.checkMarkYes
                calcView.coinTypeCheckMark.tintColor = .systemGreen
            } else if calcView.coinTypeTextField.text == "" {
                calcView.coinTypeCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.coinTypeCheckMark.tintColor = .clear
            } else {
                calcView.coinTypeCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.coinTypeCheckMark.tintColor = .systemRed
            }
        }
        
        if textField == calcView.buyStartDateTextField {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateLabel.textColor = .label
            calcView.buyStartDateBottomLine.backgroundColor = .label
            
            if calcView.buyStartDateTextField.text != "" {
                calcView.buyStartDateCheckMark.image = Constant.ImageSetting.checkMarkYes
                calcView.buyStartDateCheckMark.tintColor = .systemGreen
            } else if calcView.buyStartDateTextField.text == "" {
                calcView.buyStartDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.buyStartDateCheckMark.tintColor = .clear
            } else {
                calcView.buyStartDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.buyStartDateCheckMark.tintColor = .systemRed
            }
        }
        
        if textField == calcView.buyEndDateTextField {
            calcView.buyEndDateTextField.textColor = .label
            calcView.buyEndDateLabel.textColor = .label
            calcView.buyEndDateBottomLine.backgroundColor = .label
            
            if calcView.buyEndDateTextField.text != "" {
                calcView.buyEndDateCheckMark.image = Constant.ImageSetting.checkMarkYes
                calcView.buyEndDateCheckMark.tintColor = .systemGreen
            } else if calcView.buyEndDateTextField.text == "" {
                calcView.buyEndDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.buyEndDateCheckMark.tintColor = .clear
            } else {
                calcView.buyEndDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.buyEndDateCheckMark.tintColor = .systemRed
            }
        }
        
        if textField == calcView.sellDateTextField {
            calcView.sellDateTextField.textColor = .label
            calcView.sellDateLabel.textColor = .label
            calcView.sellDateBottomLine.backgroundColor = .label
            
            if calcView.sellDateTextField.text != "" {
                calcView.sellDateCheckMark.image = Constant.ImageSetting.checkMarkYes
                calcView.sellDateCheckMark.tintColor = .systemGreen
            } else if calcView.sellDateTextField.text == "" {
                calcView.sellDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.sellDateCheckMark.tintColor = .clear
            } else {
                calcView.sellDateCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.sellDateCheckMark.tintColor = .systemRed
            }
        }
        
        if textField == calcView.frequencyTextField {
            calcView.frequencyTextField.textColor = .label
            calcView.frequencyLabel.textColor = .label
            calcView.frequencyBottomLine.backgroundColor = .label
            
            if calcView.frequencyTextField.text != "" {
                calcView.frequencyCheckMark.image = Constant.ImageSetting.checkMarkYes
                calcView.frequencyCheckMark.tintColor = .systemGreen
            } else if calcView.frequencyTextField.text == "" {
                calcView.frequencyCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.frequencyCheckMark.tintColor = .clear
            } else {
                calcView.frequencyCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.frequencyCheckMark.tintColor = .systemRed
            }
        }
        
        if textField == calcView.amountTextField {
            calcView.amountTextField.textColor = .label
            calcView.amountLabel.textColor = .label
            calcView.amountBottomLine.backgroundColor = .label
            
            // 텍스트가 비어있지 않고 소수점(.)이 0~1개인 경우 check sign 표시하기
            if calcView.amountTextField.text != "" {
                if 0...1 ~= calcView.amountTextField.text!.filter({ $0 == "." }).count {
                    calcView.amountCheckMark.image = Constant.ImageSetting.checkMarkYes
                    calcView.amountCheckMark.tintColor = .systemGreen
                } else {
                    inputError = .decimalInputError
                    calcView.amountCheckMark.image = Constant.ImageSetting.checkMarkNo
                    calcView.amountCheckMark.tintColor = .systemRed
            }
            // 텍스트가 비어있는 경우 sign 숨기기
            } else if calcView.amountTextField.text == "" {
                calcView.amountCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.amountCheckMark.tintColor = .clear
            // 그 외의 경우는 모두 X sign 표시하기
            } else {
                calcView.amountCheckMark.image = Constant.ImageSetting.checkMarkNo
                calcView.amountCheckMark.tintColor = .systemRed
            }
            
        }
        
    }
    
    // 한 글자씩 입력이 끝날 때마다 입력된 내용을 허용할지 말지 결정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 금액을 입력하는 TextField만 숫자와 온점(.) 입력을 허용하고 최대 9자리의 숫자로 제한
        if textField == calcView.amountTextField {
            if string.count > 0 {
                // TextField에 실수(숫자+소수점)만 입력할 수 있는 Set 설정
                var charSet = CharacterSet.lowercaseLetters
                charSet.insert(charactersIn: "0123456789.")
                
                // charSet에 속하지 않는 문자(charSet.inverted)가 없는 경우
                // 즉, charSet에 속하는 문자인 경우 guard문 통과
                guard string.rangeOfCharacter(from: charSet.inverted) == nil else { return false }
                
                // 최대 글자수 제한을 두고 글자수가 그보다 작은 경우 guard문 통과
                let maxLength = 9
                guard range.location < maxLength else { return false }
            }
            // 위의 조건들을 모두 만족해서 여기까지 왔다면 입력 허용
            return true
        }
        
        // 나머지 TextField는 모두 글자 입력을 허용하지 않음
        return false
    }
    
}
