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
    
    var historyDict = [String: [[Double]]]()  // JSON parsing이 끝난 뒤 히스토리 데이터를 담을 딕셔너리
    
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
        calcView.calcStartButton.addTarget(self, action: #selector(calcButtonTapped(_:)), for: .touchUpInside)
        calcView.calcResetButton.addTarget(self, action: #selector(calcButtonTapped(_:)), for: .touchUpInside)
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
    
    private func displayResult(with result: (String, String, String, String)) {
        let messageString = "원금: \(result.0)" + "\n" + "수익률: \(result.1)" + "\n" +
                            "수익금: \(result.2)" + "\n" + "투자 후 자산: \(result.3)"
        let alert = UIAlertController(title: "계산 결과", message: messageString, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped(_ textField: UITextField) {
        self.view.endEditing(true)
    }
    
    @objc private func pickerSelected(_ sender: UIDatePicker) {
        let pickedDate = sender.date
        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy-MM-dd"
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        
        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        
        if sender == calcView.coinTypePicker {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateTextField.text = self.coinTypeString
        } else if sender == calcView.buyStartDatePicker {
            calcView.buyStartDateTextField.textColor = .label
            calcView.buyStartDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        } else if sender == calcView.buyEndDatePicker {
            calcView.buyEndDateTextField.textColor = .label
            calcView.buyEndDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        } else if sender == calcView.sellDatePicker {
            calcView.sellDateTextField.textColor = .label
            calcView.sellDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
        }
                    
        //self.endDateString = pickedDateFormatter2.string(from: pickedDate)
        //print("endDateString: \(endDateString)")
    }
    
    @objc private func calcButtonTapped(_ button: UIButton) {
        // (1) 계산 버튼을 눌렀을 때
        if button == calcView.calcStartButton {
            
            // 일괄매수를 선택한 경우
            if calcView.segmentedControl.selectedSegmentIndex == 0 {
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
                
                let coinType = calcView.coinTypeTextField.text!.lowercased()
                let startDate = calcView.buyStartDateTextField.text!
                let endDate = calcView.sellDateTextField.text!
                let investmentLength = CalcManager.shared.calculateDateInterval(start: startDate, end: endDate)
                
                // 위의 if문을 통해 모든 입력 값의 검사를 통과했다면 API로 가격 히스토리 데이터 가져오기
                NetworkManager.shared.fetchPriceHistory(with: coinType, howManyDays: investmentLength) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let historyInfo):

                        print("계산 시작 시간: \(Date())")
                        
                        self.historyDict = historyInfo
                        CalcManager.shared.calculateROI(segment: 0, with: self.historyDict) { (amount, roi, profit, balance) in
                            print("원금: \(amount)")
                            print("수익률: \(roi)")
                            print("수익금: \(profit)")
                            print("투자 후 자산: \(balance)")
                            
                            // 화면 표출에 관련 -> 메인큐로 작업 보내기
                            DispatchQueue.main.async {
                                self.displayResult(with: (amount, roi, profit, balance))
                            }
                        }
                        
                        print("계산 종료 시간: \(Date())")
                        
                        // API로 데이터를 받아와 ROI를 계산하는 과정이 비동기 직렬큐에서 처리하도록 설정
                        //DispatchQueue(label: "serial").async {
                        //}
                    case .failure(.networkingError):
                        print("ERROR: networking")
                    case .failure(.dataError):
                        print("ERROR: data")
                    case .failure(.parseError):
                        print("ERROR: parse")
                    }
                }
                
                //presentPopUpMessage(with: button, title: calcView.calcResetButton.currentTitle!, message: "계산이 완료되었습니다.", responder: nil)
            }
                
            // 분할매수를 선택한 경우
            if calcView.segmentedControl.selectedSegmentIndex == 1 {
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
                
                //---------------------------------
                // fetchPriceHistory 메서드 들어갈 자리
                //---------------------------------
                
                calcView.presentLoadingIndicator()
            }
            
        }
        
        // (2) 초기화 버튼을 눌렀을 때
        if button == calcView.calcResetButton {
            presentPopUpMessage(with: button, title: calcView.calcResetButton.currentTitle!, message: "입력된 내용을 모두 지우시겠습니까?", responder: nil)
        }
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
