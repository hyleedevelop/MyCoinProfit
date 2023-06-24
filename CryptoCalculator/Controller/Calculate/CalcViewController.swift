//
//  CalcTypeViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/29.
//

import UIKit
import GoogleMobileAds

final class CalcViewController: UIViewController {

    //MARK: - 인스턴스 관련 속성
    
    internal let calcView = CalcView()  // UIView
    internal let coinListData = PickerData()  // structure
    internal var historyDict = [String: [[Double?]]]()  // JSON parsing이 끝난 뒤 히스토리 데이터를 담을 딕셔너리
    
    //MARK: - UI 관련 속성
    
    // 구글 애드몹
    private lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return banner
    }()
    
    //MARK: - 일반 속성
    
    internal var buyStartDateStringToCalculate: String = ""
    internal var buyEndDateStringToCalculate: String = ""
    internal var sellDateStringToCalculate: String = ""
    internal var buyStartDateDefaultSetting: Bool = true
    internal var buyEndDateDefaultSetting: Bool = true
    internal var sellDateDefaultSetting: Bool = true
    
    weak var calcResultDataDelegate: CalcResultDelegate?
    
    //MARK: - 뷰의 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
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
    
    //MARK: - UI 관련 메서드
    
    // NavigationBar 설정
    private func setupNavigationBar() {
        self.navigationController?.applyDefaultSettings()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"), style: .plain,
            target: self, action: #selector(calcResetButtonTapped(_:))
        )
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationItem.title = Constant.TitleSetting.calcVC
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BGColor")
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
            self.calcView.calcStartButton.layer.sublayers?.remove(at: firstIndex)
        }
        
        // 버튼에 새로운 sublayer를 추가
        self.calcView.updateButtonColor(index: themeIndex)
    }
    
    // 수익계산 화면을 처음 표시할 때 ContainerView를 하나씩 보여주는 애니메이션 효과 적용
    private func playAnimation() {
        let durationTime = 1.0
        let targetArray1 = [self.calcView.coinTypeLabel,
                            self.calcView.buyStartDateLabel,
                            self.calcView.sellDateLabel,
                            self.calcView.amountLabel]
        let targetArray2 = [self.calcView.coinTypeContainerView,
                            self.calcView.buyStartDateContainerView,
                            self.calcView.sellDateContainerView,
                            self.calcView.amountContainerView]
        
        DispatchQueue.main.async {
            targetArray1.forEach { $0.alpha = 0 }
            targetArray2.forEach { $0.alpha = 0 }
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
    
    internal func showPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?) {
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
    
    // 에러 메세지 보여주기
    private func showErrorMessage(title: String, message: String, textField: UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constant.MessageSetting.closeTitle,
                                         style: .default) { _ in
            textField.becomeFirstResponder()
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 계산 결과 화면 보여주기
    private func presentCalcResult(with calcResult: Any, segmentIndex index: Int) {
        // 계산결과 VC 인스턴스 생성
        let calcResultVC = CalcResultViewController()
        // 계산결과 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: calcResultVC)

        // Bottom Sheet 관련 설정
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = true  // true이면 dismiss 할 수 없음
        
        // CalcResultVC의 대리자에게 데이터 전달
        //coinVC.coinTypeDataDelegate = self
        calcResultVC.receiveCalcResultData(
            segmentIndex: calcView.segmentedControl.selectedSegmentIndex,
            with: calcResult as! InvestmentResult)
        
        // 화면 전환
        self.navigationController?.pushViewController(calcResultVC, animated: true)
    }
    
    //MARK: - 계산 수행
    
    // 버튼을 눌렀을 때
    @objc private func calcStartButtonTapped(_ button: UIButton) {
        // segmented control의 인덱스값 받아오기
        let segmentIndex = calcView.segmentedControl.selectedSegmentIndex
        
        // TextField 입력값에 대한 유효성 검사 -> input error가 없다면 계속 진행
        let errorType = self.validateTextfieldInput(type: segmentIndex, button: button)
        guard errorType == .noInputError else { return }
        
        // 투자 정보 관련 속성 초기화
        /*---------------------------------------------------------------------------*/
        // 코인 ID (소문자)
        var coinTypeString: String {
            guard let coinID = DataPassManager.shared.selectedCoinID else { return "" }
            return coinID.lowercased()
        }

        // 코인 이름
        var coinNameString: String {
            return DataPassManager.shared.selectedCoinName ?? ""
        }
        
        // 매수 및 매도 관련 날짜
        let buyStartDateString: String = calcView.buyStartDateTextField.text!
        let buyEndDateString: String = calcView.buyEndDateTextField.text!
        let sellDateString: String = calcView.sellDateTextField.text!
        
        // 매수 주기
        let frequencyString: String = calcView.frequencyTextField.text!
        
        // 매수 금액
        let amountString: String = calcView.amountTextField.text!
        
        // 매수 및 매도 관련 기간
        var buyStartTobuyEndLength: Int = 0
        if segmentIndex == 1 {
            buyStartTobuyEndLength = CalculationManager.shared.calculateDateInterval(
                type: .buyStartTobuyEnd,
                start: self.buyStartDateStringToCalculate,
                end: self.buyEndDateStringToCalculate
            )
        }
        
        let buyStartToSellLength: Int = CalculationManager.shared.calculateDateInterval(
            type: .buyStartToSell,
            start: self.buyStartDateStringToCalculate,
            end: self.sellDateStringToCalculate
        )
        
        let buyToNowLength: Int = CalculationManager.shared.calculateDateInterval(
            type: .buyStartToNow,
            start: self.buyStartDateStringToCalculate,
            end: nil
        )
        /*---------------------------------------------------------------------------*/
        
        // async/await를 이용한 비동기 처리
        /*---------------------------------------------------------------------------*/
        Task.init {
            // 작업 시작 -> activityIndicator 표시하기
            DispatchQueue.main.async {
                self.calcView.activityIndicator.startAnimating()
            }
            
            // ⭐️ 코인 가격 히스토리 데이터 가져오기 (escaping closure -> async/await 코드 변경)
            let priceHistoryData: Result<[String : [[Double?]]], NetworkError> =
            await NetworkManager.shared.fetchPriceHistory(
                with: coinTypeString, duration: buyToNowLength
            )
            
            var calculatedData: CalcResultData?
            
            switch priceHistoryData {
            case .success(let historyInfo):
                // ⭐️ 투자 수익률 관련 통계치 계산하기 (escaping closure -> async/await 코드 변경)
                calculatedData = segmentIndex == 0
                ? await CalculationManager.shared.calculateROIIntensive(
                    with: historyInfo,
                    principal: Double(amountString)!,
                    buy: self.buyStartDateStringToCalculate,
                    sell: self.sellDateStringToCalculate
                )
                : await CalculationManager.shared.calculateROIAveraged(
                    with: historyInfo,
                    principalPerDay: Double(amountString)!,
                    buyStart: self.buyStartDateStringToCalculate,
                    buyEnd: self.buyEndDateStringToCalculate,
                    sell: self.sellDateStringToCalculate
                )
            case .failure(.networkingError): print("ERROR: networking")
            case .failure(.dataError): print("ERROR: data")
            case .failure(.parseError): print("ERROR: parse")
            }
            
            guard let stats = calculatedData else { return }
            
            switch stats.errorCode {
            case .noDateError:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.calcView.activityIndicator.stopAnimating()
                    
                    let data: InvestmentResult = segmentIndex == 0
                    ? IntensiveInvestment(
                        amount: stats.principal,
                        roi: stats.roi,
                        profit: stats.profit,
                        balance: stats.balance,
                        coinNameString: coinNameString,
                        buyStartDateString: buyStartDateString,
                        sellDateString: sellDateString,
                        buyStartToSellLength: buyStartToSellLength,
                        historyPriceArray: stats.historyPriceArray,
                        historyAmountInvestedArray: stats.historyAmountInvestedArray,
                        historyROIArray: stats.historyROIArray
                    )
                    : AveragedInvestment(
                        amount: stats.principal,
                        roi: stats.roi,
                        profit: stats.profit,
                        balance: stats.balance,
                        coinNameString: coinNameString,
                        buyStartDateString: buyStartDateString,
                        buyEndDateString: buyEndDateString,
                        sellDateString: sellDateString,
                        frequencyString: frequencyString,
                        amountString: amountString,
                        buyStartTobuyEndLength: buyStartTobuyEndLength,
                        buyStartToSellLength: buyStartToSellLength,
                        historyPriceArray: stats.historyPriceArray,
                        historyAmountInvestedArray: stats.historyAmountInvestedArray,
                        historyROIArray: stats.historyROIArray
                    )
                    
                    self.presentCalcResult(with: data, segmentIndex: segmentIndex)
                }
            case .buyStartDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: Constant.MessageSetting.errorTitle,
                        message: Constant.MessageSetting.buyStartDateNoDataErrorMessage1,
                        textField: self.calcView.buyStartDateTextField
                    )
                    self.calcView.activityIndicator.stopAnimating()
                }
            case .buyEndDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: Constant.MessageSetting.errorTitle,
                        message: Constant.MessageSetting.buyEndDateNoDataErrorMessage,
                        textField: self.calcView.buyEndDateTextField
                    )
                    self.calcView.activityIndicator.stopAnimating()
                }
            case .sellDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: Constant.MessageSetting.errorTitle,
                        message: Constant.MessageSetting.sellDateNoDataErrorMessage,
                        textField: self.calcView.sellDateTextField
                    )
                    self.calcView.activityIndicator.stopAnimating()
                }
            }
            
        }
        /*---------------------------------------------------------------------------*/
        
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
