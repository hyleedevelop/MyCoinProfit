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
        self.calcView.updateCoinType(to: coinName)
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
        self.navigationItem.title = LocalizedStringKey.calculate.localize
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        self.calcView.delegate = self
        self.view.backgroundColor = UIColor(named: "BGColor")
    }
    
    // Button 설정
    private func setupButton() {
        self.calcView.calcStartButton.addTarget(
            self, action: #selector(calcStartButtonTapped(_:)), for: .touchUpInside
        )
        
        // 앱의 테마 컬러 설정값 적용
        let themeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaults.themeColorNumber)
        self.calcView.updateButtonColor(index: themeIndex)
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
            self.calcView.setCalcStartButtonAlpha(to: 0.0)
            
            for i in 0..<targetArray1.count+1 {
                UIView.animate(withDuration: durationTime, delay: Double(i)*0.3) {
                    if i < targetArray1.count {
                        targetArray1[i].alpha = 1
                        targetArray2[i].alpha = 1
                    } else {
                        self.calcView.setCalcStartButtonAlpha(to: 1.0)
                    }
                }
            }
        }
    }
    
    internal func showInputErrorMessage(error: InputError, message: String) {
        // AlertController, AlertAction 생성
        let alert = UIAlertController(
            title: LocalizedStringKey.error.localize,
            message: message,
            preferredStyle: .alert
        )
        // 특정 TextField의 내용이 제대로 입력되지 않은 경우, 확인 버튼을 누르면 해당 TextField가 활성화되도록 설정
        let okAction = UIAlertAction(title: LocalizedStringKey.ok.localize, style: .default) { _ in
            self.calcView.designateFirstResponder(error: error)
        }
        
        // 액션 추가 및 팝업메세지 출력
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    internal func showPopUpMessage(with button: UIButton, title titleString: String, message messageString: String, responder textField: UITextField?) {
        // AlertController, AlertAction 생성
        let alert = UIAlertController(
            title: titleString,
            message: messageString,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: LocalizedStringKey.cancel.localize,
            style: .default,
            handler: nil
        )
        let okAction = UIAlertAction(
            title: LocalizedStringKey.reset.localize,
            style: .destructive
        ) { _ in
            self.calcView.resetTextFieldInput()
        }
        
        // 액션 추가 및 팝업메세지 출력
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
            segmentIndex: self.calcView.segmentIndex,
            with: calcResult as! InvestmentResult)
        
        // 화면 전환
        self.navigationController?.pushViewController(calcResultVC, animated: true)
    }
    
    //MARK: - 계산 수행
    
    // 버튼을 눌렀을 때
    @objc private func calcStartButtonTapped(_ button: UIButton) {
        // segmented control의 인덱스값 받아오기
        let segmentIndex = self.calcView.segmentIndex
        
        // TextField 입력값에 대한 유효성 검사 수행
        let error = self.calcView.validateTextfieldInput(button: button)
        
        // input error가 없다면 계속 진행
        guard error == .noInputError else {
            self.inputValidationDidComplete(error: error)
            return
        }
        
        // API 요청에 필요한 속성 초기화
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
        
        // 매수 시작 ~ 매수 종료의 날짜 간격
        var buyStartTobuyEndLength: Int = 0
        if segmentIndex == 1 {
            buyStartTobuyEndLength = CalculationManager.shared.calculateDateInterval(
                type: .buyStartTobuyEnd,
                start: self.buyStartDateStringToCalculate,
                end: self.buyEndDateStringToCalculate
            )
        }
        
        // 매수 시작 ~ 매도의 날짜 간격
        let buyStartToSellLength: Int = CalculationManager.shared.calculateDateInterval(
            type: .buyStartToSell,
            start: self.buyStartDateStringToCalculate,
            end: self.sellDateStringToCalculate
        )
        
        // 매수 시작 ~ 현재의 날짜 간격
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
                self.calcView.setActivityIndicator(mode: .start)
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
                    principal: Double(self.calcView.amount)!,
                    buy: self.buyStartDateStringToCalculate,
                    sell: self.sellDateStringToCalculate
                )
                : await CalculationManager.shared.calculateROIAveraged(
                    with: historyInfo,
                    principalPerDay: Double(self.calcView.amount)!,
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
                    let data: InvestmentResult = segmentIndex == 0
                    ? IntensiveInvestment(
                        amount: stats.principal,
                        roi: stats.roi,
                        profit: stats.profit,
                        balance: stats.balance,
                        coinNameString: coinNameString,
                        buyStartDateString: self.calcView.buyStartDate,
                        sellDateString: self.calcView.sellDate,
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
                        buyStartDateString: self.calcView.buyStartDate,
                        buyEndDateString: self.calcView.buyEndDate,
                        sellDateString: self.calcView.sellDate,
                        frequencyString: self.calcView.frequency,
                        amountString: self.calcView.amount,
                        buyStartTobuyEndLength: buyStartTobuyEndLength,
                        buyStartToSellLength: buyStartToSellLength,
                        historyPriceArray: stats.historyPriceArray,
                        historyAmountInvestedArray: stats.historyAmountInvestedArray,
                        historyROIArray: stats.historyROIArray
                    )
                    
                    self.calcView.setActivityIndicator(mode: .stop)
                    self.presentCalcResult(with: data, segmentIndex: segmentIndex)
                }
            case .buyStartDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: LocalizedStringKey.error.localize,
                        message: LocalizedStringKey.noDataOnFirstPurchaseDate.localize,
                        textField: self.calcView.buyStartDateTextField
                    )
                    self.calcView.setActivityIndicator(mode: .stop)
                }
            case .buyEndDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: LocalizedStringKey.error.localize,
                        message: LocalizedStringKey.noDataOnLastPurchaseDate.localize,
                        textField: self.calcView.buyEndDateTextField
                    )
                    self.calcView.setActivityIndicator(mode: .stop)
                }
            case .sellDateError:
                DispatchQueue.main.async {
                    self.showErrorMessage(
                        title: LocalizedStringKey.error.localize,
                        message: LocalizedStringKey.noDataOnSellDate.localize,
                        textField: self.calcView.sellDateTextField
                    )
                    self.calcView.setActivityIndicator(mode: .stop)
                }
            }
            
        }
        /*---------------------------------------------------------------------------*/
        
    }
    
    @objc private func calcResetButtonTapped(_ button: UIButton) {
        // Alert 메세지 표시
        self.showPopUpMessage(
            with: button,
            title: LocalizedStringKey.confirm.localize,
            message: LocalizedStringKey.resetMessage.localize,
            responder: nil
        )
    }
    
    @objc private func recentInputButtonTapped() {
        let settingVC = SettingViewController()
        self.navigationController?.pushViewController(settingVC, animated: true)
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

//MARK: - 뷰의 델리게이트 메서드

extension CalcViewController: CalcViewDelegate {
    
    // TextField 입력값 검증 결과 에러가 발생했을 때
    func inputValidationDidComplete(error: InputError) {
        switch error {
        //case .coinTypeInputError:
        case .coinTypeInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.noCoinType.localize
            )
        case .buyStartDateInputError:
            self.showInputErrorMessage(
                error: error,
                message: self.calcView.segmentIndex == 0
                ? LocalizedStringKey.noPurchaseDate.localize
                : LocalizedStringKey.noFirstPurchaseDate.localize
            )
        case .buyEndDateInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.noLastPurchaseDate.localize
            )
        case .sellDateInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.noSellDate.localize
            )
        case .frequencyInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.noFrequency.localize
            )
        case .amountInputError:
            self.showInputErrorMessage(
                error: error,
                message: self.calcView.segmentIndex == 0
                ? LocalizedStringKey.noPurchaseAmount.localize
                : LocalizedStringKey.noEachPurchaseAmount.localize
            )
        case .buyStartbuyEndInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.firstPurchaseAndLastPurchase.localize
            )
        case .buyStartSellInputError:
            self.showInputErrorMessage(
                error: error,
                message: self.calcView.segmentIndex == 0
                ? LocalizedStringKey.purchaseAndSell.localize
                : LocalizedStringKey.firstPurchaseAndSell.localize
            )
        case .buyEndSellInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.lastPurchaseAndSell.localize
            )
        case .decimalInputError:
            self.showInputErrorMessage(
                error: error,
                message: LocalizedStringKey.manyDecimalpoints.localize
            )
        default:
            break
        }
    }
    
}
