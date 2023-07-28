//
//  CalcResultModalViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/10.
//

import UIKit
import Screenshots
import GoogleMobileAds

// 데이터 전달을 위한 커스텀 델리게이트 구현에 필요한 프로토콜
protocol CalcResultDelegate: AnyObject {
    func receiveCalcResultData(segmentIndex index: Int, with data: InvestmentResult)
}

final class CalcResultViewController: UIViewController {
    
    //MARK: - UI 관련 속성
    
    // 구글 애드몹
    lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return banner
    }()
    
    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.systemBackground
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.sectionFooterHeight = 30
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(StatsCell.self, forCellReuseIdentifier: "StatsCell")
        tv.register(GraphCell.self, forCellReuseIdentifier: "GraphCell")
        return tv
    }()

    //MARK: - 인스턴스 관련 속성
    
    private let calcVC = CalcViewController()
    private var dataSource = [CalcResultCellData]()
    private var intensiveInvestment: IntensiveInvestment!
    private var averagedInvestment: AveragedInvestment!
    private let statsDataArrayLSI = [String]()
    
    //MARK: - 일반 속성
    
    private var segmentIndex: Int = 0
    
    //MARK: - 뷰의 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calcVC.calcResultDataDelegate = self
    
        self.setupNavBar()
        self.setupView()
        self.setupTableView()
        self.setupTableViewDataSource()
        
        self.setupBannerViewToBottom()
    }
    
    //MARK: - UI 관련 메서드
    
    private func setupNavBar() {
        self.navigationController?.applyDefaultSettings()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(self.buttonTapped(_:))
        )
        self.navigationItem.rightBarButtonItem?.tintColor = .label
        self.navigationItem.title = LocalizedStringKey.result.localize
    }
    
    // View 설정
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BGColor")
    }

    // TableView 설정
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        // 대리자 설정
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // AutoLayout 설정
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }
    
    // TableViewCell에 표출할 내용을 담은 Model
    private func setupTableViewDataSource() {
        switch segmentIndex {
        case 0: self.dataSource = [
            CalcResultCellManager.shared.getStatsDataLSI(),
            CalcResultCellManager.shared.getGraphData()
        ]
        case 1: self.dataSource = [
            CalcResultCellManager.shared.getStatsDataDCA(),
            CalcResultCellManager.shared.getGraphData()
        ]
        default: break
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // 스크린샷을 사진 앱에 저장 (1)
    private func takeScreenshot(of view: UIView) {
        if let image = self.tableView.screenshot {
            // photo library 접근 권한을 허용해줘야 함(Info.plist)
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.imageWasSaved), nil)
        }
    }
    
    // 스크린샷을 사진 앱에 저장 (2)
    @objc private func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    // 버튼을 눌렀을 때 실행할 내용
    @objc private func buttonTapped(_ button: UIButton) {
        if button == navigationItem.rightBarButtonItem {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(
                title: LocalizedStringKey.confirm.localize,
                message: LocalizedStringKey.exportMessage.localize,
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(
                title: LocalizedStringKey.no.localize,
                style: .default,
                handler: nil
            )
            let okAction = UIAlertAction(
                title: LocalizedStringKey.yes.localize,
                style: .default
            ) { _ in
                self.takeScreenshot(of: self.view)
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK: - 데이터 전달을 위한 커스텀 델리게이트 메서드

// CalcViewController로부터 데이터를 전달받기 위해 커스텀 프로토콜 채택
extension CalcResultViewController: CalcResultDelegate {
    
    // 이전 화면에서 데이터를 전달받아 작업할 내용
    func receiveCalcResultData(segmentIndex index: Int, with data: InvestmentResult) {
        self.segmentIndex = index
        
        if index == 0 {  // 한번에 매수하기
            self.intensiveInvestment = data as? IntensiveInvestment
            guard let data = data as? IntensiveInvestment else { return }
            
            let coinType = data.coinNameString
            var buyStartDate: String {
                let range: PartialRangeThrough = ...data.buyStartDateString.index(
                    data.buyStartDateString.startIndex, offsetBy: 11
                )
                return String(data.buyStartDateString[range]).uppercased()
            }
            var sellDate: String {
                let range: PartialRangeThrough = ...data.sellDateString.index(
                    data.sellDateString.startIndex, offsetBy: 11
                )
                return String(data.sellDateString[range]).uppercased()
            }
            let buyStartToSellLength = "\((data.buyStartToSellLength + 1).separatedByComma()) Days"
            let amountTotal = data.amount.toUSD()
            let balance = data.balance.toUSD()
            let profitROI = "\(data.profit.toUSDPlusSigned())\n(\(data.roi.toPercentage()))"
            
            // 7개의 데이터: 코인 종류, 매수 날짜, 매도 날짜, 코인 보유 일수, 원금, 평가금, 수익금(수익률)
            let strings = [
                coinType, buyStartDate, sellDate, buyStartToSellLength,
                amountTotal, balance, profitROI
            ]
            
            for (index, string) in strings.enumerated() {
                CalcResultCellManager.shared.updateStatsDataLSI(index: index, newValue: string)
            }
        }

        if index == 1 {  // 나눠서 매수하기
            self.averagedInvestment = data as? AveragedInvestment
            guard let data = data as? AveragedInvestment else { return }

            let coinType = data.coinNameString
            var buyStartDate: String {
                let range: PartialRangeThrough = ...data.buyStartDateString.index(
                    data.buyStartDateString.startIndex, offsetBy: 11
                )
                return String(data.buyStartDateString[range]).uppercased()
            }
            var buyEndDate: String {
                let range: PartialRangeThrough = ...data.buyEndDateString.index(
                    data.buyEndDateString.startIndex, offsetBy: 11
                )
                return String(data.buyEndDateString[range]).uppercased()
            }
            var sellDate: String {
                let range: PartialRangeThrough = ...data.sellDateString.index(
                    data.sellDateString.startIndex, offsetBy: 11
                )
                return String(data.sellDateString[range]).uppercased()
            }
            let frequency = data.frequencyString
            let buyStartToBuyEndLength = "\((data.buyStartTobuyEndLength + 1).separatedByComma()) Days"
            let buyStartToSellLength = "\((data.buyStartToSellLength + 1).separatedByComma()) Days"
            let amountTotal = data.amount.toUSD()
            let balance = data.balance.toUSD()
            let profitROI = "\(data.profit.toUSDPlusSigned())\n(\(data.roi.toPercentage()))"
            
            // 10개의 데이터: 코인 종류, 매수 시작 날짜, 매수 종료 날짜, 매도 날짜, 매수 주기,
            //             코인 매수 일수, 코인 보유 일수, 원금, 평가금, 수익금(수익률)
            let strings = [
                coinType, buyStartDate, buyEndDate, sellDate, frequency,
                buyStartToBuyEndLength, buyStartToSellLength, amountTotal, balance, profitROI
            ]
            
            for (index, string) in strings.enumerated() {
                CalcResultCellManager.shared.updateStatsDataDCA(index: index, newValue: string)
            }
        }
    }
    
}

//MARK: - TableView에 대한 델리게이트 메서드

extension CalcResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    // Section 내의 Cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .stats(statsModel): return statsModel.count
        case let .graph(graphModel): return graphModel.count
        }
    }
    
    // Section Header의 제목 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.dataSource[section] {
        case .stats(_): return LocalizedStringKey.stats.localize
        case .graph(_): return LocalizedStringKey.performanceCharts.localize
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        switch self.dataSource[section] {
        case .stats(_): title.text = LocalizedStringKey.stats.localize
        case .graph(_): title.text = LocalizedStringKey.performanceCharts.localize
        }
        
        title.font = UIFont.systemFont(ofSize: 18,
                                       weight: .bold)
        title.textColor = .label

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.font = title.font
        header.textLabel?.textColor = title.textColor
        header.textLabel?.text = title.text?.localizedCapitalized
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.section] {
        case .stats(_): return 44
        case .graph(_): return 220
        }
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
        case let .stats(statsModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
            let model = statsModel[indexPath.row]
            
            //if indexPath.row == 6 { cell.valueLabel.textColor = lossOrGainColor }
            cell.backgroundColor = UIColor.systemBackground
            cell.prepareStats(segment: self.segmentIndex, mode: indexPath.row,
                              icon: model.icon, title: model.title, value: model.value)
            
            return cell
                
        case let .graph(graphModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as! GraphCell
            let model = graphModel[indexPath.row]
            
            var dataArray = [[Double]]()
            if self.segmentIndex == 0 {
                dataArray = [
                    self.intensiveInvestment.historyAmountInvestedArray,
                    self.intensiveInvestment.historyPriceArray,
                    self.intensiveInvestment.historyROIArray.map { $0 * 100.0 }
                ]
            } else {
                dataArray = [
                    self.averagedInvestment.historyAmountInvestedArray,
                    self.averagedInvestment.historyPriceArray,
                    self.averagedInvestment.historyROIArray.map { $0 * 100.0 }
                ]
            }
                        
            cell.backgroundColor = UIColor.systemBackground
            
            cell.prepareGraph(
                segment: self.segmentIndex,
                mode: indexPath.row,
                title: model.title,
                data: dataArray[indexPath.row]
            )
            
            return cell
        }
        
    }
    
}

//MARK: - 구글 애드몹에 대한 델리게이트 메서드

extension CalcResultViewController: GADBannerViewDelegate {
    
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
