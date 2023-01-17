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
    
    var buyStartDateStringToCalculate: String = ""
    var buyEndDateStringToCalculate: String = ""
    var sellDateStringToCalculate: String = ""
    
    var buyStartDateDefaultSetting: Bool = true
    var buyEndDateDefaultSetting: Bool = true
    var sellDateDefaultSetting: Bool = true
    
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
    var dataDelegate: CalcResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        //setupToolBar()
        setupPickerView()
        setupButton()
        setupTextField()
        
        playAnimation()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func loadView() {
        view = calcView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = Constant.UIColorSetting.lightModeBackground
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        // scrollEdge: 스크롤 하기 전의 NavigationBar
        // standard: 스크롤을 하고 있을 때의 NavigationBar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.title = Constant.TitleSetting.menuName2
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
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
    
        calcView.coinTypeTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        calcView.buyStartDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        calcView.buyEndDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        calcView.sellDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        calcView.frequencyTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        
        calcView.buyStartDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        calcView.buyEndDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        calcView.sellDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        
        // Picker가 선택되어 있는 기본값
        calcView.coinTypePicker.selectRow(0, inComponent: 0, animated: true)
        calcView.frequencyPicker.selectRow(0, inComponent: 0, animated: true)
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
    
    // 수익계산 화면을 처음 표시할 때 ContainerView를 하나씩 보여주는 애니메이션 효과 적용
    private func playAnimation() {
        DispatchQueue.main.async {
            self.calcView.segmentedControl.selectedSegmentIndex = 0
            let targetArray = [self.calcView.coinTypeContainerView,
                               self.calcView.buyStartDateContainerView,
                               self.calcView.amountContainerView,
                               self.calcView.sellDateContainerView,
                               self.calcView.buttonStackView]
            _ = targetArray.map{ $0.alpha = 0 }
            
            for i in 0..<targetArray.count {
                UIView.animate(withDuration: 1.0, delay: Double(i)*0.4) {
                    targetArray[i].alpha = 1
                }
            }
        }
    }
    
    private func showPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?, error errorType: InputError) {
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
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentCalcResult(with calcResult: Any) {
        // 도움말 VC 인스턴스 생성
        let calcResultModalVC = CalcResultViewController()
        // 도움말 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: calcResultModalVC)

        // Bottom Sheet 관련 설정
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = true  // true이면 dismiss 할 수 없음
        
        // sheetPresentationController는 iOS 15 이상부터 사용 가능
        if let sheet = nav.sheetPresentationController {
            // Bottom Sheet를 확장/축소 했을 때 화면 꼭대기가 걸리는 높이 지정
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.detents = [.large()]
            if #available(iOS 16.0, *) {
                // iOS 16 이상부터 커스텀으로 높이를 결정할 수 있음
                // iOS 15는 .medium()과 .large() 둘 중 하나만 가능
                sheet.detents = [.custom(resolver: { context in
                    return context.maximumDetentValue * 0.9
                })]
            } else {
                sheet.detents = [.large()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = false
        }
        
        // CalcResultVC의 대리자가 데이터를 전달받도록 설정
        calcResultModalVC.receiveData(segmentIndex: calcView.segmentedControl.selectedSegmentIndex,
                                      with: calcResult)
        self.present(nav, animated: true, completion: nil)
    }
    
    // 수익계산 결과를 메세지로 출력
    private func presentResult(segment segmentIndex: Int, with result: Any) {
        var messageString: String = ""
        
        let downcastingResult = result as! CalcResultType1
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
    
    // Date 관련 PickerView에서 선택 값이 변경되었을 때 주어진 날짜 형식의 텍스트값 보이기
    @objc private func datePickerAction(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        selectedDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        selectedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        convertedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        if sender == calcView.buyStartDatePicker {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: selectedDate)
            self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: selectedDate)
        }
        
        if sender == calcView.buyEndDatePicker {
            calcView.buyEndDateTextField.textColor = .label
            calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: selectedDate)
            self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: selectedDate)
        }
        
        if sender == calcView.sellDatePicker {
            calcView.sellDateTextField.textColor = .label
            calcView.sellDateTextField.text = selectedDateFormatter.string(from: selectedDate)
            self.sellDateStringToCalculate = convertedDateFormatter.string(from: selectedDate)
        }
    }
    
    // type 관련 TextField가 활성화되는 시점에서 TextField와 Picker의 기본값 설정
    @objc private func textFieldAction(_ textField: UITextField) {
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        selectedDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        selectedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = TimeZone(abbreviation: "KST")
        convertedDateFormatter.locale = Locale(identifier: "ko_KR")
        
        if calcView.coinTypeTextField.isFirstResponder {
            calcView.coinTypeTextField.textColor = .label
            calcView.coinTypeTextField.text = coinListData.coinNameArray[calcView.coinTypePicker.selectedRow(inComponent: 0)]
        }
        
        if calcView.buyStartDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.buyStartMaximumDate
            calcView.buyStartDateTextField.textColor = .label
            
            if calcView.buyStartDateTextField.text == "" && buyStartDateDefaultSetting {
                calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                buyStartDateDefaultSetting.toggle()
            } else if calcView.buyStartDateTextField.text == "" && !buyStartDateDefaultSetting {
                calcView.buyStartDatePicker.date = maximumDate
                calcView.buyStartDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyStartDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if calcView.buyEndDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.buyEndMaximumDate
            calcView.buyEndDateTextField.textColor = .label
            
            if calcView.buyEndDateTextField.text == "" && buyEndDateDefaultSetting {
                calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                buyEndDateDefaultSetting.toggle()
            } else if calcView.buyEndDateTextField.text == "" && !buyEndDateDefaultSetting {
                calcView.buyEndDatePicker.date = maximumDate
                calcView.buyEndDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.buyEndDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if calcView.sellDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.sellMaximumDate
            calcView.sellDateTextField.textColor = .label
            
            if calcView.sellDateTextField.text == "" && sellDateDefaultSetting {
                calcView.sellDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.sellDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
                sellDateDefaultSetting.toggle()
            } else if calcView.sellDateTextField.text == "" && !sellDateDefaultSetting {
                calcView.sellDatePicker.date = maximumDate
                calcView.sellDateTextField.text = selectedDateFormatter.string(from: maximumDate)
                self.sellDateStringToCalculate = convertedDateFormatter.string(from: maximumDate)
            }
        }
        
        if calcView.frequencyTextField.isFirstResponder {
            calcView.frequencyTextField.textColor = .label
            calcView.frequencyTextField.text = coinListData.frequencyArray[calcView.frequencyPicker.selectedRow(inComponent: 0)]
        }
    }
    
    // 버튼을 눌렀을 때
    @objc private func calcStartButtonTapped(_ button: UIButton) {
        // (a) 일괄매수를 선택한 경우
        if calcView.segmentedControl.selectedSegmentIndex == 0 {
            
            // 코인 종류 입력값이 없는 경우
            if calcView.coinTypeTextField.text == "" {
                inputError = .coinTypeInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "코인 종류를 반드시 선택해야 합니다.",
                                    responder: calcView.coinTypeTextField, error: .buyEndDateInputError)
                return
            }
            
            // 매수 시작 날짜 입력값이 없는 경우
            if calcView.buyStartDateTextField.text == "" {
                inputError = .buyStartDateInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매수 날짜를 반드시 선택해야 합니다.",
                                    responder: calcView.buyStartDateTextField, error: .buyStartDateInputError)
                return
            } else {
                let isValidDate: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                // 매수 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate {
                    showPopUpMessage(with: button, title: "에러", message: "매수 날짜가 매도 날짜보다 빨라야 합니다.", responder: calcView.buyStartDateTextField, error: .buyStartSellInputError)
                    return
                }
            }
            
            // 매수 금액 입력값이 없는 경우
            if calcView.amountTextField.text == "" {
                inputError = .amountInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매수 금액를 반드시 입력해야 합니다.",
                                    responder: calcView.amountTextField, error: .amountInputError)
                return
            } else {
                // 매수 금액 입력값이 존재하지만, 소수점이 2개 이상 입력된 경우
                if inputError == .decimalInputError {
                    showPopUpMessage(with: button, title: "에러", message: "소수점은 한번만 사용해야 합니다.", responder: calcView.amountTextField, error: .decimalInputError)
                    return
                }
            }
            
            // 매도 날짜 입력값이 없는 경우
            if calcView.sellDateTextField.text == "" {
                inputError = .sellDateInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매도 날짜를 반드시 선택해야 합니다.",
                                    responder: calcView.sellDateTextField, error: .sellDateInputError)
                return
            } else {
                let isValidDate: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                // 매도 날짜 입력값이 존재하지만, 매수 날짜보다 이전 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate {
                    showPopUpMessage(with: button, title: "에러", message: "매도 날짜가 매수 날짜보다 늦어야 합니다.", responder: calcView.sellDateTextField, error: .buyStartSellInputError)
                    return
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
                    type: .buyStartToNow, start: self.buyStartDateStringToCalculate, end: nil)
                
                print(coinTypeString)
                print(buyStartDateString)
                print(sellDateString)
                print(amountString)
                print(buyToNowLength)
                
                // 위의 if문을 통해 모든 입력 값의 검사를 통과했다면 API로 가격 히스토리 데이터 가져오기
                NetworkManager.shared.fetchPriceHistory(with: coinTypeString, duration: buyToNowLength) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let historyInfo):
                        self.historyDict = historyInfo
                        
                        CalcManager.shared.calculateROIIntensive(with: self.historyDict, amount: Double(amountString)!, buy: self.buyStartDateStringToCalculate, sell: self.sellDateStringToCalculate) { (amount, roi, profit, balance, errorCode) in
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
                                    // HalfModalView로 결과 메세지 보여주기
                                    self.presentCalcResult(with: (amount, roi, profit, balance, coinTypeString, buyStartDateString, sellDateString))
                                }
                            case .buyStartDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 날짜의 코인 데이터를\n서버에서 가져올 수 없습니다.\n매수 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .buyEndDateError:
                                fallthrough
                            case .sellDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매도 날짜의 코인 데이터를\n서버에서 가져올 수 없습니다.\n매도 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
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
            
            // 코인 종류 선택값이 없는 경우
            if calcView.coinTypeTextField.text == "" {
                inputError = .coinTypeInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "코인 종류를 반드시 선택해야 합니다.",
                                    responder: calcView.coinTypeTextField, error: .buyEndDateInputError)
                return
            }
            
            // 매수 시작 날짜 입력값이 없는 경우
            if calcView.buyStartDateTextField.text == "" {
                inputError = .buyStartDateInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매수 시작 날짜를 반드시 선택해야 합니다.",
                                    responder: calcView.buyStartDateTextField, error: .buyStartDateInputError)
                return
            } else {
                let isValidDate1: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.buyEndDatePicker.date)
                let isValidDate2: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                // 매수 시작 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이후 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate1 {
                    showPopUpMessage(with: button, title: "에러", message: "매수 시작 날짜가 매수 종료 날짜보다 빨라야 합니다.", responder: calcView.buyStartDateTextField, error: .buyStartbuyEndInputError)
                    return
                }
                // 매수 시작 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate2 {
                    showPopUpMessage(with: button, title: "에러", message: "매수 시작 날짜가 매도 날짜보다 빨라야 합니다.", responder: calcView.buyStartDateTextField, error: .buyStartSellInputError)
                    return
                }
            }
            
            // 매수 종료 날짜 입력값이 없는 경우
            if calcView.buyEndDateTextField.text == "" {
                inputError = .buyEndDateInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매수 종료 날짜를 선택하세요",
                                    responder: calcView.buyEndDateTextField, error: .buyEndDateInputError)
                return
            } else {
                let isValidDate1: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.buyEndDatePicker.date)
                let isValidDate2: Bool = calcView.buyEndDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                // 매수 종료 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate1 {
                    showPopUpMessage(with: button, title: "에러", message: "매수 종료 날짜가 매수 시작 날짜보다 늦어야 합니다.", responder: calcView.buyEndDateTextField, error: .buyStartbuyEndInputError)
                    return
                }
                // 매수 종료 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate2 {
                    showPopUpMessage(with: button, title: "에러", message: "매수 종료 날짜가 매도 날짜보다 빨라야 합니다.", responder: calcView.buyEndDateTextField, error: .buyEndSellInputError)
                    return
                }
            }
            
            // 매수 반복 주기 입력값이 없는 경우
            if calcView.frequencyTextField.text == "" {
                inputError = .frequencyInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매수 반복 주기를 선택하세요",
                                    responder: calcView.frequencyTextField, error: .frequencyInputError)
                return
            }
            
            // 매번 매수 금액 입력값이 없는 경우
            if calcView.amountTextField.text == "" {
                inputError = .amountInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매번 매수할 금액를 반드시 입력해야 합니다.",
                                    responder: calcView.amountTextField, error: .amountInputError)
                return
            } else {
                // 매 회 매수 금액 입력값이 존재하지만, 소수점이 2개 이상 입력된 경우
                if inputError == .decimalInputError {
                    showPopUpMessage(with: button, title: "에러", message: "소수점은 한번만 사용해야 합니다.", responder: calcView.amountTextField, error: .decimalInputError)
                    return
                }
            }
            
            // 매도 날짜 입력값이 없는 경우
            if calcView.sellDateTextField.text == "" {
                inputError = .sellDateInputError
                showPopUpMessage(with: button, title: "에러",
                                    message: "매도 날짜를 반드시 선택해야 합니다.",
                                    responder: calcView.sellDateTextField, error: .sellDateInputError)
                return
            } else {
                let isValidDate1: Bool = calcView.buyStartDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                let isValidDate2: Bool = calcView.buyEndDatePicker.date.isValidDateOrder(with: calcView.sellDatePicker.date)
                // 매도 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate1 {
                    showPopUpMessage(with: button, title: "에러", message: "매도 날짜가 매수 시작 날짜보다 늦어야 합니다.", responder: calcView.sellDateTextField, error: .buyStartSellInputError)
                    return
                }
                // 매도 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이전 시점인 경우
                if calcView.buyStartDateTextField.text != "" && !isValidDate2 {
                    showPopUpMessage(with: button, title: "에러", message: "매도 날짜가 매수 종료 날짜보다 늦어야 합니다.", responder: calcView.sellDateTextField, error: .buyEndSellInputError)
                    return
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
                
                let buyStartTobuyEndLength: Int = CalcManager.shared.calculateDateInterval(type: .buyStartTobuyEnd, start: self.buyStartDateStringToCalculate, end: self.buyEndDateStringToCalculate)
                let buyStartToSellLength: Int = CalcManager.shared.calculateDateInterval(type: .buyStartToSell, start: self.buyStartDateStringToCalculate, end: self.sellDateStringToCalculate)
                let buyToNowLength: Int = CalcManager.shared.calculateDateInterval(type: .buyStartToNow, start: self.buyStartDateStringToCalculate, end: nil)
                
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
                        
                        CalcManager.shared.calculateROIAveraged(with: self.historyDict, amount: Double(amountString)!, buyStart: self.buyStartDateStringToCalculate, buyEnd: self.buyEndDateStringToCalculate, sell: self.sellDateStringToCalculate) { (amount, roi, profit, balance, errorCode) in
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
                                    self.presentCalcResult(with: (amount, roi, profit, balance, coinTypeString, buyStartDateString, buyEndDateString, sellDateString, frequencyString, amountString))
                                }
                            case .buyStartDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 시작 날짜의 코인 데이터를\n서버에서 가져올 수 없습니다.\n매수 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .buyEndDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매수 종료 날짜의 코인 데이터를\n서버에서 가져올 수 없습니다.\n매수 종료 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .sellDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "오류", message: "매도 날짜의 코인 데이터를\n서버에서 가져올 수 없습니다.\n매도 날짜를 다시 선택하시기 바랍니다.", preferredStyle: .alert)
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
        showPopUpMessage(with: button, title: calcView.calcResetButton.currentTitle!,
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
                sheet.detents = [.large()]
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
            calcView.coinTypeContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.coinTypeContainerView.layer.borderWidth = 1.5
        }

        if textField == calcView.buyStartDateTextField {
            calcView.buyStartDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.buyStartDateContainerView.layer.borderWidth = 1.5
        }

        if textField == calcView.buyEndDateTextField {
            calcView.buyEndDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.buyEndDateContainerView.layer.borderWidth = 1.5
        }

        if textField == calcView.sellDateTextField {
            calcView.sellDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.sellDateContainerView.layer.borderWidth = 1.5
        }

        if textField == calcView.frequencyTextField {
            calcView.frequencyContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.frequencyContainerView.layer.borderWidth = 1.5
        }

        if textField == calcView.amountTextField {
            calcView.amountContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.amountContainerView.layer.borderWidth = 1.5
            calcView.amountTextField.text = calcView.amountTextField.text?.replacingOccurrences(of: ",", with: "")
        }
    }
    
    // TextField 편집이 종료되었을 때 실행할 내용
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == calcView.coinTypeTextField {
            calcView.coinTypeTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.coinTypeContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.coinTypeContainerView.layer.borderWidth = 0.0
        }
        
        if textField == calcView.buyStartDateTextField {
            calcView.buyStartDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.buyStartDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.buyStartDateContainerView.layer.borderWidth = 0.0
        }
        
        if textField == calcView.buyEndDateTextField {
            calcView.buyEndDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.buyEndDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.buyEndDateContainerView.layer.borderWidth = 0.0
        }
        
        if textField == calcView.sellDateTextField {
            calcView.sellDateTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.sellDateContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.sellDateContainerView.layer.borderWidth = 0.0
        }
        
        if textField == calcView.frequencyTextField {
            calcView.frequencyTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.frequencyContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.frequencyContainerView.layer.borderWidth = 0.0
        }
        
        if textField == calcView.amountTextField {
            inputError = .noInputError
            calcView.amountTextField.textColor = Constant.UIColorSetting.themeColor
            calcView.amountContainerView.layer.borderColor = Constant.CGColorSetting.themeColor
            calcView.amountContainerView.layer.borderWidth = 0.0
            
            // 텍스트가 비어있지 않고 소수점(.)이 0~1개인 경우 check sign 표시하기
            if calcView.amountTextField.text != "" {
                if 0...1 ~= calcView.amountTextField.text!.filter({ $0 == "." }).count {

                } else {
                    inputError = .decimalInputError
                }
            // 텍스트가 비어있는 경우
            } else if calcView.amountTextField.text == "" {

            // 그 외의 경우
            } else {

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
