//
//  CalcTypeViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/29.
//

import UIKit
import GoogleMobileAds

final class CalcViewController: UIViewController {

    private let calcView = CalcView()  // UIView
    private let coinVC = CoinListViewController()  // UIViewController
    private let coinListData = PickerData()  // structure
    
    // 구글 애드몹
    lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return banner
    }()
    
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
    var inputError: InputError?
    
    weak var calcResultDataDelegate: CalcResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupView()
        self.setupPickerView()
        self.setupButton()
        self.setupTextField()
        self.setupBannerViewToBottom()
        
        self.playAnimation()
        
        self.addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        guard let coinName = DataPassManager.shared.selectedCoinName else { return }
        self.calcView.coinTypeTextField.text = coinName
    }
        
    override func loadView() {
        self.view = self.calcView
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor(named: "BGColor")
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        // scrollEdge: 스크롤 하기 전의 NavigationBar
        // standard: 스크롤을 하고 있을 때의 NavigationBar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(calcResetButtonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .label
                
        navigationItem.title = Constant.TitleSetting.tabName1
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BGColor")
    }
    
#warning("View로 옮기기")
    // PickerView 설정
    private func setupPickerView() {
        // UIPickerView 사용 시 delegate 패턴으로 구현 (UIDatePickerView는 필요없음)
        _ = [calcView.coinTypePicker, calcView.frequencyPicker].map { $0.delegate = self }
    
        self.calcView.coinTypeTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        self.calcView.buyStartDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        self.calcView.buyEndDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        self.calcView.sellDateTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        self.calcView.frequencyTextField.addTarget(self, action: #selector(textFieldAction(_:)), for: .editingDidBegin)
        
        self.calcView.buyStartDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        self.calcView.buyEndDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        self.calcView.sellDatePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        
        // Picker가 선택되어 있는 기본값
        //calcView.coinTypePicker.selectRow(0, inComponent: 0, animated: true)
        calcView.frequencyPicker.selectRow(0, inComponent: 0, animated: true)
    }
    
    // Button 설정
    private func setupButton() {
        self.calcView.calcStartButton.addTarget(self, action: #selector(calcStartButtonTapped(_:)), for: .touchUpInside)
        
        // 앱의 테마 컬러 설정 가져오기
        let themeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaults.themeColorNumber)
        
        DispatchQueue.main.async {
            self.calcView.calcStartButton.setButtonBackgroundGradient(
                color1: Constant.UIColorSetting.themeGradientStartColors[themeIndex],
                color2: Constant.UIColorSetting.themeGradientMiddleColors[themeIndex],
                color3: Constant.UIColorSetting.themeGradientEndColors[themeIndex])
        }
    }
    
    // NotificationCenter Observer 만들기
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(notificationReceived(_:)),
            name: Notification.Name("colorChanged"), object: nil)
    }
    
    // 버튼 속성 업데이트
    @objc private func notificationReceived(_ notification: NSNotification) {
        // 앱의 테마 컬러 설정 가져오기
        let themeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaults.themeColorNumber)
        
        // 버튼에 들어있던 기존의 sublayer를 제거
        if let firstIndex = calcView.calcStartButton.layer.sublayers?.firstIndex(
            where: { $0.name == "gradient" }) {
            calcView.calcStartButton.layer.sublayers?.remove(at: firstIndex)
        }
        
        // 버튼에 새로운 sublayer를 추가
        DispatchQueue.main.async {
            self.calcView.calcStartButton.setButtonBackgroundGradient(
                color1: Constant.UIColorSetting.themeGradientStartColors[themeIndex],
                color2: Constant.UIColorSetting.themeGradientMiddleColors[themeIndex],
                color3: Constant.UIColorSetting.themeGradientEndColors[themeIndex])
        }
    }
    
    private func setupTextField() {
        [calcView.coinTypeTextField, calcView.buyStartDateTextField, calcView.buyEndDateTextField,
         calcView.sellDateTextField, calcView.frequencyTextField, calcView.amountTextField]
            .forEach({ $0.delegate = self })
    }
    
    // 수익계산 화면을 처음 표시할 때 ContainerView를 하나씩 보여주는 애니메이션 효과 적용
    private func playAnimation() {
        let durationTime = 1.0
        DispatchQueue.main.async {
            let targetArray1 = [self.calcView.coinTypeLabel,
                                self.calcView.buyStartDateLabel,
                                self.calcView.sellDateLabel,
                                self.calcView.amountLabel]
            let targetArray2 = [self.calcView.coinTypeContainerView,
                                self.calcView.buyStartDateContainerView,
                                self.calcView.sellDateContainerView,
                                self.calcView.amountContainerView]
            
            targetArray1.forEach({ $0.alpha = 0 })
            targetArray2.forEach({ $0.alpha = 0 })
            self.calcView.calcStartButton.alpha = 0
            
            for i in 0..<targetArray1.count+1 {
                UIView.animate(withDuration: durationTime, delay: Double(i)*0.3) {
                    if i < targetArray1.count {
                        targetArray1[i].alpha = 1
                        targetArray2[i].alpha = 1
                    } else {
                        self.calcView.calcStartButton.alpha = 1
                    }
                }
            }
            
        }
    }
    
    private func showPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?) {
        if button == calcView.calcStartButton {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
            
            // 특정 TextField의 내용이 제대로 입력되지 않은 경우, 확인 버튼을 누르면 해당 TextField가 활성화되도록 설정
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                guard let tf = textField else { return }
                tf.becomeFirstResponder()
            }
                        
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }

        if button == navigationItem.rightBarButtonItem {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: Constant.MessageSetting.cancelTitle,
                                             style: .default, handler: nil)
            let okAction = UIAlertAction(title: Constant.MessageSetting.resetTitle,
                                         style: .destructive) { _ in
                // 입력된 내용 모두 지우기
                _ = [self.calcView.coinTypeTextField, self.calcView.buyStartDateTextField,
                     self.calcView.buyEndDateTextField, self.calcView.sellDateTextField,
                     self.calcView.frequencyTextField, self.calcView.amountTextField].map { $0.text = "" }
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func presentCalcResult(with calcResult: Any, segmentIndex index: Int) {
        // 계산결과 VC 인스턴스 생성
        let calcResultVC = CalcResultViewController()
        // 계산결과 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: calcResultVC)

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
                    return (index == 0) ? 430 : 500
                })]
            } else {
                sheet.detents = [.large()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = false
        }
        
        // CalcResultVC의 대리자에게 데이터 전달
        //coinVC.coinTypeDataDelegate = self
        calcResultVC.receiveCalcResultData(
            segmentIndex: calcView.segmentedControl.selectedSegmentIndex,
            with: calcResult)
        
        // 화면 전환
        //self.present(nav, animated: true, completion: nil)
        navigationController?.pushViewController(calcResultVC, animated: true)
    }
    
    // Date 관련 PickerView에서 선택 값이 변경되었을 때 주어진 날짜 형식의 텍스트값 보이기
    @objc private func datePickerAction(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = "MMM dd, yyyy"
        selectedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        selectedDateFormatter.locale = Constant.DateSetting.standardLocale
        
        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        convertedDateFormatter.locale = Constant.DateSetting.standardLocale
        
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
        selectedDateFormatter.dateFormat = "MMM dd, yyyy"
        selectedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        selectedDateFormatter.locale = Constant.DateSetting.standardLocale

        let convertedDateFormatter = DateFormatter()
        convertedDateFormatter.dateFormat = "yyyy-MM-dd"
        convertedDateFormatter.timeZone = Constant.DateSetting.standardTimeZone
        convertedDateFormatter.locale = Constant.DateSetting.standardLocale
        
        if calcView.buyStartDateTextField.isFirstResponder {
            let maximumDate = Constant.DateSetting.buyStartMaximumDate
            
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
            calcView.frequencyTextField.text = coinListData.frequencyArray[
                calcView.frequencyPicker.selectedRow(inComponent: 0)]
        }
    }
    
    //MARK: - 입력값 유효성 검사
    
    private func checkInputIsValid(segmentIndex: Int, button: UIButton) {
        let coinType = calcView.coinTypeTextField.text
        let buyStartDate = calcView.buyStartDateTextField.text
        let buyEndDate = calcView.buyEndDateTextField.text
        let sellDate = calcView.sellDateTextField.text
        let frequency = calcView.frequencyTextField.text
        let amount = calcView.amountTextField.text
        
        // 일괄매수를 선택한 경우
        if segmentIndex == 0 {
            
            // 코인 종류 선택값이 없는 경우
            if coinType == "" {
                inputError = .coinTypeInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.coinTypeErrorMessage,
                                 responder: calcView.coinTypeTextField)
                return
            }
            
            // 매수 날짜 입력값이 없는 경우
            if buyStartDate == "" {
                inputError = .buyStartDateInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.buyStartDateErrorMessage1,
                                 responder: calcView.buyStartDateTextField)
                return
            } else if sellDate != "" {
                // 매수 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                let isValidDate = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if !isValidDate {
                    inputError = .buyStartSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.buyStartDateErrorMessage3,
                                     responder: calcView.buyStartDateTextField)
                    return
                }
            }
            
            // 매도 날짜 입력값이 없는 경우
            if sellDate == "" {
                inputError = .sellDateInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.sellDateErrorMessage1,
                                 responder: calcView.sellDateTextField)
                return
            } else if buyStartDate != "" {
                // 매도 날짜 입력값이 존재하지만, 매수 날짜보다 이전 시점인 경우
                let isValidDate = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if !isValidDate {
                    inputError = .buyStartSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.sellDateErrorMessage2,
                                     responder: calcView.sellDateTextField)
                    return
                }
            }
            
            // 매수 금액 입력값이 없는 경우
            if amount == "" {
                inputError = .amountInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.amountErrorMessage1,
                                 responder: calcView.amountTextField)
                return
            } else if amount!.filter({ $0 == "." }).count > 1 {
                // 매수 금액 입력값이 존재하지만, 소수점이 2개 이상 입력된 경우
                inputError = .decimalInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.amountErrorMessage2,
                                 responder: calcView.amountTextField)
                return
            }
            
        }
        
        // -------------------------------------------------------------------------
        
        // 분할매수를 선택한 경우
        if segmentIndex == 1 {
            
            // 코인 종류 선택값이 없는 경우
            if coinType == "" {
                inputError = .coinTypeInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.coinTypeErrorMessage,
                                 responder: calcView.coinTypeTextField)
                return
            }
            
            // 매수 시작 날짜 입력값이 없는 경우
            if buyStartDate == "" {
                inputError = .buyStartDateInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.buyStartDateErrorMessage2,
                                 responder: calcView.buyStartDateTextField)
                return
            } else {
                // 매수 시작 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이후 시점인 경우
                let isValidDate1 = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.buyEndDatePicker.date)
                if buyStartDate != "" && !isValidDate1 {
                    inputError = .buyStartbuyEndInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.buyStartDateErrorMessage4,
                                     responder: calcView.buyStartDateTextField)
                    return
                }
                
                // 매수 시작 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                let isValidDate2 = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if buyStartDate != "" && !isValidDate2 {
                    inputError = .buyStartSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.buyStartDateErrorMessage5,
                                     responder: calcView.buyStartDateTextField)
                    return
                }
            }
            
            // 매수 종료 날짜 입력값이 없는 경우
            if buyEndDate == "" {
                inputError = .buyEndDateInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.buyEndDateErrorMessage1,
                                 responder: calcView.buyEndDateTextField)
                return
            } else {
                // 매수 종료 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
                let isValidDate1 = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.buyEndDatePicker.date)
                if buyStartDate != "" && !isValidDate1 {
                    inputError = .buyStartbuyEndInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.buyEndDateErrorMessage2,
                                     responder: calcView.buyEndDateTextField)
                    return
                }
                
                // 매수 종료 날짜 입력값이 존재하지만, 매도 날짜보다 이후 시점인 경우
                let isValidDate2 = calcView.buyEndDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if buyEndDate != "" && !isValidDate2 {
                    inputError = .buyEndSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.buyEndDateErrorMessage3,
                                     responder: calcView.buyEndDateTextField)
                    return
                }
            }
            
            // 매도 날짜 입력값이 없는 경우
            if sellDate == "" {
                inputError = .sellDateInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.sellDateErrorMessage1,
                                 responder: calcView.sellDateTextField)
                return
            } else {
                // 매도 날짜 입력값이 존재하지만, 매수 시작 날짜보다 이전 시점인 경우
                let isValidDate1 = calcView.buyStartDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if buyStartDate != "" && !isValidDate1 {
                    inputError = .buyStartSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.sellDateErrorMessage3,
                                     responder: calcView.sellDateTextField)
                    return
                }
                
                // 매도 날짜 입력값이 존재하지만, 매수 종료 날짜보다 이전 시점인 경우
                let isValidDate2 = calcView.buyEndDatePicker.date.isValidDateOrder(
                    with: calcView.sellDatePicker.date)
                if buyEndDate != "" && !isValidDate2 {
                    inputError = .buyEndSellInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.sellDateErrorMessage3,
                                     responder: calcView.sellDateTextField)
                    return
                }
            }
            
            // 매수 반복 주기 입력값이 없는 경우
            if frequency == "" {
                inputError = .frequencyInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.frequencyErrorMessage,
                                 responder: calcView.frequencyTextField)
                return
            }
            
            // 매번 매수 금액 입력값이 없는 경우
            if amount == "" {
                inputError = .amountInputError
                showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                 message: Constant.MessageSetting.amountErrorMessage3,
                                 responder: calcView.amountTextField)
                return
            } else {
                // 매 회 매수 금액 입력값이 존재하지만, 소수점이 2개 이상 입력된 경우
                if amount!.filter({ $0 == "." }).count > 1 {
                    inputError = .decimalInputError
                    showPopUpMessage(with: button, title: Constant.MessageSetting.errorTitle,
                                     message: Constant.MessageSetting.amountErrorMessage2,
                                     responder: calcView.amountTextField)
                    return
                }
            }
            
        }
    }
    
    //MARK: - 계산 수행
    
    // 버튼을 눌렀을 때
    @objc private func calcStartButtonTapped(_ button: UIButton) {
        let segmentIndex = calcView.segmentedControl.selectedSegmentIndex
        inputError = .noInputError
        
        // (a) 일괄매수를 선택한 경우
        if segmentIndex == 0 {
            checkInputIsValid(segmentIndex: segmentIndex, button: button)
            
            // noInputError인 경우 다음 줄로 넘어가서 실행, 그렇지 않은 경우 return으로 함수 종료
            guard inputError == .noInputError else { return }
            
            // 계산 작업 시작 -> activityIndicator 표시하기
            DispatchQueue.main.async {
                self.calcView.activityIndicator.startAnimating()
            }
            
            // API로 데이터 가져오기 및 수익계산에 필요한 저장속성
            guard let coinID = DataPassManager.shared.selectedCoinID else { return }
            let coinTypeString: String = coinID.lowercased()
            guard let coinName = DataPassManager.shared.selectedCoinName else { return }
            let coinNameString: String = coinName
            let buyStartDateString: String = calcView.buyStartDateTextField.text!
            let sellDateString: String = calcView.sellDateTextField.text!
            let amountString: String = calcView.amountTextField.text!
            
            let buyStartToSellLength: Int = CalcManager.shared.calculateDateInterval(type: .buyStartToSell, start: self.buyStartDateStringToCalculate, end: self.sellDateStringToCalculate)
            let buyToNowLength: Int = CalcManager.shared.calculateDateInterval(
                type: .buyStartToNow, start: self.buyStartDateStringToCalculate, end: nil)
            
            // 모든 입력 값에 대한 검사 종료 후, API로 가격 히스토리 데이터 가져오기
            NetworkManager.shared.fetchPriceHistory(with: coinTypeString,
                                                    duration: buyToNowLength) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let historyInfo):
                    self.historyDict = historyInfo
                    
                    CalcManager.shared.calculateROIIntensive(with: self.historyDict, amount: Double(amountString)!, buy: self.buyStartDateStringToCalculate, sell: self.sellDateStringToCalculate) {
                        (amount, roi, profit, balance,
                         historyPriceArray, historyAmountInvestedArray, historyROIArray, errorCode) in
                        switch errorCode {
                        case .noDateError:
                            //print("<일괄매수 수익 계산 결과>")
                            //print("원금: \(amount.toUSD())")
                            //print("수익률: \(roi.toPercentage())")
                            //print("수익금: \(profit.toUSD())")
                            //print("평가금: \(balance.toUSD())")
                            
                            // UI 관련 작업 -> 메인큐로 보내기
                            DispatchQueue.main.async {
                                // 계산 작업 종료 -> activityIndicator 숨기기
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.calcView.activityIndicator.stopAnimating()
                                    // HalfModalView로 결과 메세지 보여주기
                                    self.presentCalcResult(with: (amount, roi, profit, balance, coinNameString, buyStartDateString, sellDateString, buyStartToSellLength, historyPriceArray, historyAmountInvestedArray, historyROIArray), segmentIndex: 0)
                                }
                            }
                        case .buyStartDateError:
                            // UI 관련 작업 -> 메인큐로 보내기
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                              message: Constant.MessageSetting.buyStartDateNoDataErrorMessage1,
                                                              preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                                                 style: .default) { _ in
                                    self.calcView.buyStartDateTextField.becomeFirstResponder()
                                }
                                alert.addAction(cancelAction)
                                self.calcView.activityIndicator.stopAnimating()
                                self.present(alert, animated: true, completion: nil)
                            }
                        case .buyEndDateError:
                            fallthrough
                        case .sellDateError:
                            // UI 관련 작업 -> 메인큐로 보내기
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                              message: Constant.MessageSetting.sellDateNoDataErrorMessage,
                                                              preferredStyle: .alert)
                                let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                                                 style: .default) { _ in
                                    self.calcView.sellDateTextField.becomeFirstResponder()
                                }
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
        
        // (b) 분할매수를 선택한 경우
        if segmentIndex == 1 {
            checkInputIsValid(segmentIndex: segmentIndex, button: button)
            
            // noInputError인 경우 다음 줄로 넘어가서 실행, 그렇지 않은 경우 return으로 함수 종료
            guard inputError == .noInputError else { return }
            
            if inputError == .noInputError {
                // 계산 작업 시작 -> activityIndicator 표시하기
                DispatchQueue.main.async {
                    self.calcView.activityIndicator.startAnimating()
                }
                
                // API로 데이터 가져오기 및 수익계산에 필요한 저장속성
                guard let coinID = DataPassManager.shared.selectedCoinID else { return }
                let coinTypeString: String = coinID.lowercased()
                guard let coinName = DataPassManager.shared.selectedCoinName else { return }
                let coinNameString: String = coinName
                let buyStartDateString: String = calcView.buyStartDateTextField.text!
                let buyEndDateString: String = calcView.buyEndDateTextField.text!
                let sellDateString: String = calcView.sellDateTextField.text!
                let frequencyString: String = calcView.frequencyTextField.text!
                let amountString: String = calcView.amountTextField.text!
                
                let buyStartTobuyEndLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartTobuyEnd,
                    start: self.buyStartDateStringToCalculate,
                    end: self.buyEndDateStringToCalculate)
                let buyStartToSellLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartToSell,
                    start: self.buyStartDateStringToCalculate,
                    end: self.sellDateStringToCalculate)
                let buyToNowLength: Int = CalcManager.shared.calculateDateInterval(
                    type: .buyStartToNow,
                    start: self.buyStartDateStringToCalculate,
                    end: nil)
                
                // 위의 if문을 통해 모든 입력 값의 검사를 통과했다면 API로 가격 히스토리 데이터 가져오기
                NetworkManager.shared.fetchPriceHistory(with: coinTypeString, duration: buyToNowLength) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let historyInfo):
                        self.historyDict = historyInfo
                        
                        CalcManager.shared.calculateROIAveraged(with: self.historyDict, amount: Double(amountString)!, buyStart: self.buyStartDateStringToCalculate, buyEnd: self.buyEndDateStringToCalculate, sell: self.sellDateStringToCalculate) {
                            (amount, roi, profit, balance,
                             historyPriceArray, historyAmountInvestedArray, historyROIArray, errorCode) in
                            switch errorCode {
                            case .noDateError:
                                //print("<분할매수 수익 계산 결과>")
                                //print("원금: \(amount.toUSD())")
                                //print("수익률: \(roi.toPercentage())")
                                //print("수익금: \(profit.toUSD())")
                                //print("평가금: \(balance.toUSD())")
                                
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    // 계산 작업 종료 -> activityIndicator 숨기기
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        self.calcView.activityIndicator.stopAnimating()
                                        self.presentCalcResult(with: (amount, roi, profit, balance, coinNameString, buyStartDateString, buyEndDateString, sellDateString, frequencyString, amountString, buyStartTobuyEndLength, buyStartToSellLength, historyPriceArray, historyAmountInvestedArray, historyROIArray), segmentIndex: 1)
                                    }
                                }
                            case .buyStartDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                                  message: Constant.MessageSetting.buyStartDateNoDataErrorMessage2,
                                                                  preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                                                     style: .default) { _ in
                                        self.calcView.buyStartDateTextField.becomeFirstResponder()
                                    }
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .buyEndDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                                  message: Constant.MessageSetting.buyEndDateNoDataErrorMessage,
                                                                  preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                                                     style: .default) { _ in
                                        self.calcView.buyEndDateTextField.becomeFirstResponder()
                                    }
                                    alert.addAction(cancelAction)
                                    self.calcView.activityIndicator.stopAnimating()
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .sellDateError:
                                // UI 관련 작업 -> 메인큐로 보내기
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                                  message: Constant.MessageSetting.sellDateNoDataErrorMessage,
                                                                  preferredStyle: .alert)
                                    let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                                                     style: .default) { _ in
                                        self.calcView.sellDateTextField.becomeFirstResponder()
                                    }
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
        showPopUpMessage(with: button,
                         title: Constant.MessageSetting.resetTitle,
                         message: Constant.MessageSetting.resetMessage,
                         responder: nil)
    }
    
    @objc private func recentInputButtonTapped() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc private func helpButtonTapped() {
        // 도움말 VC 인스턴스 생성
        let helpVC = HelpViewController()
        // 도움말 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: helpVC)
        
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
                    return 300
                })]
            } else {
                sheet.detents = [.large()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = false
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
        if pickerView == calcView.frequencyPicker {
            return coinListData.frequencyArray.count
        }

        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == calcView.frequencyPicker {
            calcView.frequencyTextField.text = coinListData.frequencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
        
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

//MARK: - 구글 애드몹 관련 메서드

extension CalcViewController: GADBannerViewDelegate {
    
    func setupBannerViewToBottom(height: CGFloat = 50) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
        self.bannerView = GADBannerView(adSize: adSize)

        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.bannerView)
        NSLayoutConstraint.activate([
            self.bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.bannerView.heightAnchor.constraint(equalToConstant: height)
        ])

        self.bannerView.adUnitID = Constant.URLSetting.admobBottomBannerMyID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
    // Tells the delegate an ad request failed.
    private func adView(_ bannerView: GADBannerView,
                        didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
}
