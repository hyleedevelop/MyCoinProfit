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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        //setupToolBar()
        setupPickerView()
        setupButton()
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
    
    private func setupToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        let toolBarFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarDoneButton = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: #selector(doneButtonTapped(_:)))
        toolBar.sizeToFit()
        toolBar.setItems([toolBarFlexibleSpace, toolBarDoneButton], animated: true)
        
        _ = [calcView.coinTypeTextField, calcView.buyStartDateTextField, calcView.buyEndDateTextField, calcView.sellDateTextField, calcView.amountTextField, calcView.frequencyTextField].map { $0.inputAccessoryView = toolBar }
    }
    
    private func setupPickerView() {
        // UIPickerView 사용 시 delegate 패턴으로 구현 (UIDatePickerView는 필요없음)
        _ = [calcView.coinTypePicker, calcView.frequencyPicker].map { $0.delegate = self }
    
        calcView.coinTypeTextField.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.buyStartDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.buyEndDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.sellDatePicker.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
        calcView.frequencyTextField.addTarget(self, action: #selector(pickerSelected(_:)), for: .valueChanged)
    }
    
    private func setupButton() {
        calcView.calcStartButton.addTarget(self, action: #selector(calcStartButtonTapped(_:)), for: .touchUpInside)
        calcView.calcResetButton.addTarget(self, action: #selector(calcResetButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func presentPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?) {
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
                self.calcView.coinTypeTextField.text = ""
                self.calcView.buyStartDateTextField.text = ""
                self.calcView.buyEndDateTextField.text = ""
                self.calcView.sellDateTextField.text = ""
                self.calcView.amountTextField.text = ""
                self.calcView.frequencyTextField.text = ""
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
        
        if segmentIndex == 0 {
            let downcastingResult = result as! (Double, Double, Double, Double)
            messageString = "원금: \(downcastingResult.0.toUSD())" + "\n" +
                            "수익률: \(downcastingResult.1.toPercentage())" + "\n" +
                            "수익금: \(downcastingResult.2.toUSD())" + "\n" +
                            "잔고: \(downcastingResult.3.toUSD())"
        }
        
        if segmentIndex == 1 {
//            let downcastResult = result as! (String, String, String, Int, Int, Int)
//            messageString = "매수시작 날짜: \(downcastResult.0)" + "\n" +
//                            "매수종료 날짜: \(downcastResult.1)" + "\n" +
//                            "매도날짜: \(downcastResult.2)" + "\n" +
//                            "매수시작 ~ 매수종료: \(downcastResult.3)일" + "\n" +
//                            "매수시작 ~ 매도: \(downcastResult.4)일" + "\n" +
//                            "매수시작 ~ 현재: \(downcastResult.5)일"
            let downcastingResult = result as! (Double, Double, Double, Double)
            messageString = "원금: \(downcastingResult.0.toUSD())" + "\n" +
                            "수익률: \(downcastingResult.1.toPercentage())" + "\n" +
                            "수익금: \(downcastingResult.2.toUSD())" + "\n" +
                            "잔고: \(downcastingResult.3.toUSD())"
        }
        
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
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.coinTypeLabel.text!)를 선택하세요",
                                    responder: calcView.coinTypeTextField)
                return
            } else if calcView.buyStartDateTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyStartDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyStartDateTextField)
                return
            } else if calcView.sellDateTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.sellDateLabel.text!)를 선택하세요",
                                    responder: calcView.sellDateTextField)
                return
            } else if calcView.amountTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.amountLabel.text!)를 입력하세요",
                                    responder: calcView.amountTextField)
                return
            }
            
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
        
        // (b) 분할매수를 선택한 경우
        if calcView.segmentedControl.selectedSegmentIndex == 1 {
            
            // 입력값 검사
            if calcView.coinTypeTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.coinTypeLabel.text!)를 선택하세요",
                                    responder: calcView.coinTypeTextField)
                return
            } else if calcView.buyStartDateTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyStartDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyStartDateTextField)
                return
            } else if calcView.buyEndDateTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.buyEndDateLabel.text!)를 선택하세요",
                                    responder: calcView.buyEndDateTextField)
                return
            } else if calcView.sellDateTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.sellDateLabel.text!)를 선택하세요",
                                    responder: calcView.sellDateTextField)
                return
            } else if calcView.amountTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.amountLabel.text!)를 입력하세요",
                                    responder: calcView.amountTextField)
                return
            } else if calcView.frequencyTextField.text == "" {
                presentPopUpMessage(with: button, title: "오류",
                                    message: "\(calcView.frequencyLabel.text!)를 선택하세요",
                                    responder: calcView.frequencyTextField)
                return
            }
            
            // 계산 작업 시작 -> activityIndicator 표시하기
            DispatchQueue.main.async {
                self.calcView.activityIndicator.startAnimating()
            }
            
            // API로 데이터 가져오기 및 수익계산에 필요한 저장속성
            let coinTypeString: String = calcView.coinTypeTextField.text!.lowercased()
            let buyStartDateString: String = calcView.buyStartDateTextField.text!
            let buyEndDateString: String = calcView.buyEndDateTextField.text!
            let sellDateString: String = calcView.sellDateTextField.text!
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
    
    @objc private func calcResetButtonTapped(_ button: UIButton) {
        presentPopUpMessage(with: button, title: calcView.calcResetButton.currentTitle!,
                            message: "입력된 내용을 모두 지우시겠습니까?", responder: nil)
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
