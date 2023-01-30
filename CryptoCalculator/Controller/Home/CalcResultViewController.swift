//
//  CalcResultModalViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/10.
//

import UIKit
import Screenshots
import GoogleMobileAds

final class CalcResultViewController: UIViewController {
    
    let calcVC = CalcViewController()
    
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
        //tv.sectionHeaderTopPadding = 0
        tv.sectionFooterHeight = 30
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(StatsCell.self, forCellReuseIdentifier: "StatsCell")
        tv.register(GraphCell.self, forCellReuseIdentifier: "GraphCell")
        return tv
    }()

//    var statsDic: [String: Any] = ["amountTotal":"", "amountEach":"",
//                                   "roi":"", "profit":"", "balance"]
    
    var segmentIndex: Int = 0
    var statsDataArrayLSI = [String]()
    
    var amountTotal: String = ""
    var amountEach: String = ""
    var roi: String = ""
    var profit: String = ""
    var balance: String = ""
    var coinType: String = ""
    var buyStartDate: String = ""
    var buyEndDate: String = ""
    var sellDate: String = ""
    var buyStartToBuyEndLength: Int = 0
    var buyStartToSellLength: Int = 0
    var frequency: String = ""
    var isROIPositive: Bool = true
    var lossOrGainColor: UIColor = Constant.UIColorSetting.positiveColor
    var coinPriceArray = [Double]()
    var totalInvestedArray = [Double]()
    var roiArray = [Double]()
    
    
    private var dataSource = [CalcResultCellData]()
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcVC.calcResultDataDelegate = self
    
        setupNavBar()
        setupView()
        setupTableView()
        setupTableViewDataSource()
        
        setupBannerViewToBottom()
    }
    
    private func setupNavBar() {
        //navigationItem.title = "도움말"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor(named: "BGColor")
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.label]
        
        // scrollEdge: 스크롤 하기 전의 NavigationBar
        // standard: 스크롤을 하고 있을 때의 NavigationBar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .label
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
//        navigationItem.backBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationItem.title = "Result"
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = UIColor(named: "BGColor")
        
    }

    // TableView 설정
    private func setupTableView() {
        view.addSubview(tableView)
        
        // 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // AutoLayout 설정
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }
    
    // TableViewCell에 표출할 내용을 담은 Model
    private func setupTableViewDataSource() {
        switch segmentIndex {
        case 0:
            self.dataSource = [CalcResultCellDataManager.shared.getStatsDataLSI(),
                               CalcResultCellDataManager.shared.getGraphData()]
        case 1:
            self.dataSource = [CalcResultCellDataManager.shared.getStatsDataDCA(),
                               CalcResultCellDataManager.shared.getGraphData()]
        default:
            fatalError()
        }
        
        
        tableView.reloadData()
    }
    
    // 스크린샷을 사진 앱에 저장 (1)
    private func takeScreenshot(of view: UIView) {
        if let image = tableView.screenshot {
            // photo library 접근 권한을 허용해줘야 함(Info.plist)
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWasSaved), nil)
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
            let alert = UIAlertController(title: "Confirm", message: Constant.MessageSetting.exportAsImageMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.takeScreenshot(of: self.view)
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

// CalcViewController로부터 데이터를 전달받기 위해 커스텀 프로토콜 채택
extension CalcResultViewController: CalcResultDelegate {
    
    // 이전 화면에서 데이터를 전달받아 작업할 내용
    func receiveCalcResultData(segmentIndex index: Int, with data: Any) {
        self.segmentIndex = index
        
        if index == 0 {  // 한번에 매수하기
            guard let data = data as? CalcResultType1 else { return }

            self.amountTotal = data.0.toUSD()
            self.roi = data.1.toPercentage()
            self.isROIPositive = data.1 >= 0 ? true : false
            self.lossOrGainColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                                 : Constant.UIColorSetting.negativeColor
            self.profit = data.2.toUSDPlusSigned()
            self.balance = data.3.toUSD()
            self.coinType = data.4
            self.buyStartDate = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            self.sellDate = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            self.buyStartToSellLength = data.7 + 1
            self.coinPriceArray = data.8
            self.totalInvestedArray = data.9
            self.roiArray = data.10
            
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 0, newValue: coinType)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 1, newValue: buyStartDate)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 2, newValue: sellDate)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 3, newValue: "\(buyStartToSellLength.separatedByComma()) Days")
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 4, newValue: amountTotal)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 5, newValue: balance)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 6, newValue: "\(profit)\n(\(roi))")
        }

        if index == 1 {  // 나눠서 매수하기
            guard let data = data as? CalcResultType2 else { return }

            self.amountTotal = data.0.toUSD()
            self.roi = data.1.toPercentage()
            self.isROIPositive = data.1 >= 0 ? true : false
            self.lossOrGainColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                                 : Constant.UIColorSetting.negativeColor
            self.profit = data.2.toUSDPlusSigned()
            self.balance = data.3.toUSD()
            self.coinType = data.4
            self.buyStartDate = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            self.buyEndDate = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            self.sellDate = String(data.7[...data.7.index(data.7.startIndex, offsetBy: 11)]).uppercased()
            self.frequency = data.8
            self.amountEach = "\(data.9)달러"
            self.buyStartToBuyEndLength = data.10 + 1
            self.buyStartToSellLength = data.11 + 1
            self.coinPriceArray = data.12
            self.totalInvestedArray = data.13
            self.roiArray = data.14
            
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 0, newValue: coinType)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 1, newValue: buyStartDate)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 2, newValue: buyEndDate)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 3, newValue: sellDate)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 4, newValue: frequency)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 5, newValue: "\(buyStartToBuyEndLength.separatedByComma()) Days")
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 6, newValue: "\(buyStartToSellLength.separatedByComma()) Days")
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 7, newValue: amountTotal)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 8, newValue: balance)
            CalcResultCellDataManager.shared.updateStatsDataDCA(index: 9, newValue: "\(profit)\n(\(roi))")
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CalcResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    // Section 내의 Cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .stats(statsModel):
            return statsModel.count
        case let .graph(graphModel):
            return graphModel.count
        }
    }
    
    // Section Header의 제목 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.dataSource[section] {
        case .stats(_):
            return "Stats"
        case .graph(_):
            return "Performance Chart"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        switch self.dataSource[section] {
        case .stats(_):
            title.text = "Stats"
        case .graph(_):
            title.text = "Performance Charts"
        }
        title.font = UIFont.systemFont(ofSize: 18,
                                       weight: .bold)
        title.textColor = .label
        //title.backgroundColor = UILabel("")

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.font = title.font
        header.textLabel?.textColor = title.textColor
        header.textLabel?.text = title.text?.localizedCapitalized
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.dataSource[indexPath.section] {
        case .stats(_):
            return 44
        case .graph(_):
            return 220
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
            
            var dataArray = [Double]()
            if indexPath.row == 0 { dataArray = self.coinPriceArray }
            if indexPath.row == 1 { dataArray = self.totalInvestedArray }
            if indexPath.row == 2 { dataArray = self.roiArray.map{ $0 * 100.0 } }
            
            //cell.isUserInteractionEnabled = true
            cell.backgroundColor = UIColor.systemBackground
            cell.prepareGraph(segment: self.segmentIndex, mode: indexPath.row,
                              title: model.title, data: dataArray,
                              buyStartDate: self.buyStartDate,
                              buyEndDate: self.buyEndDate,
                              sellDate: self.sellDate,
                              buyDays: self.buyStartToBuyEndLength)
            return cell
        }
        
    }
    
}

//MARK: - 구글 애드몹 관련 메서드

extension CalcResultViewController: GADBannerViewDelegate {
    
    func setupBannerViewToBottom(height: CGFloat = 50) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
        bannerView = GADBannerView(adSize: adSize)

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: height)
        ])

        //bannerView.adUnitID = "ca-app-pub-5804054899003424/3613736945"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
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
    
    // Tells the delegate that a full-screen view will be presented in response
    // to the user clicking on an ad.
    private func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        
    }
    
    // Tells the delegate that the full-screen view will be dismissed.
    private func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    // Tells the delegate that the full-screen view has been dismissed.
    private func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        
    }
    
    // Tells the delegate that a user click will open another app (such as
    // the App Store), backgrounding the current app.
    private func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        
    }
    
}
