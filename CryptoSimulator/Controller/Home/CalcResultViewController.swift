//
//  CalcResultModalViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/10.
//

import UIKit

final class CalcResultViewController: UIViewController {
    
    let calcVC = CalcViewController()
    let calcResultView = CalcResultView()
    
    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(named: "IBColor")
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
    var buyStartTobuyEndLength: String = ""
    var buyStartToSellLength: String = ""
    var frequency: String = ""
    var isROIPositive: Bool = true
    var lossOrGainColor: UIColor = Constant.UIColorSetting.positiveColor
    
    private var dataSource = [CalcResultCellData]()
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcVC.calcResultDataDelegate = self
    
        setupNavBar()
        setupView()
        setupTableView()
        setupTableViewDataSource()
        setupButton()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//    }
//
//    override func loadView() {
//        view = calcResultView
//    }
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
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
        self.dataSource = [CalcResultCellDataManager.shared.getStatsDataLSI(),
                           CalcResultCellDataManager.shared.getGraphData()]
        
        tableView.reloadData()
    }
    
    // 화면 하단의 Button 설정
    private func setupButton() {
        //calcResultView.showChartButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    // 스크린샷을 사진 앱에 저장 (1)
    private func takeScreenshot(of view: UIView) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.bounds.width, height: view.bounds.height), false, 2)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // photo library 접근 권한을 허용해줘야 함(Info.plist)
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
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
            let alert = UIAlertController(title: "Confirm", message: "Do you want to save the result\nas image?", preferredStyle: .alert)
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
        if index == 0 {  // 한번에 매수하기
            guard let data = data as? CalcResultType1 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")

            amountTotal = data.0.toUSD()
            roi = data.1.toPercentage()
            isROIPositive = data.1 >= 0 ? true : false
            lossOrGainColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                            : Constant.UIColorSetting.negativeColor
            profit = data.2.toUSDPlusSigned()
            balance = data.3.toUSD()
            coinType = data.4
            // 날짜 문자열에서 요일 제거한 나머지 부분
            buyStartDate = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            sellDate = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            buyStartToSellLength = String(data.7)
            
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 0, newValue: coinType)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 1, newValue: buyStartDate)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 2, newValue: sellDate)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 3, newValue: "\(buyStartToSellLength) Days")
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 4, newValue: amountTotal)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 5, newValue: balance)
            CalcResultCellDataManager.shared.updateStatsDataLSI(index: 6, newValue: "\(profit)\n(\(roi))")
        }

        if index == 1 {  // 나눠서 매수하기
            guard let data = data as? CalcResultType2 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")

            self.amountTotal = data.0.toUSD()
            self.roi = data.1.toPercentage()
            self.isROIPositive = data.1 >= 0 ? true : false
            self.lossOrGainColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                                          : Constant.UIColorSetting.negativeColor
            self.profit = data.2.toUSDPlusSigned()
            self.balance = data.3.toUSD()
            self.coinType = data.4
            // 날짜 문자열에서 요일 제거한 나머지 부분
            self.buyStartDate = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            self.buyEndDate = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            self.sellDate = String(data.7[...data.7.index(data.7.startIndex, offsetBy: 11)]).uppercased()
            self.frequency = data.8
            self.amountEach = "\(data.9)달러"
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
            return "Time Series"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        switch self.dataSource[section] {
        case .stats(_):
            title.text = "Stats"
        case .graph(_):
            title.text = "Time Series"
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
            return 50
        case .graph(_):
            return 250
        }
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
        case let .stats(statsModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
            let model = statsModel[indexPath.row]
            
            if indexPath.row == 6 { cell.valueLabel.textColor = lossOrGainColor }
            cell.backgroundColor = UIColor(named: "IBColor")
            cell.prepareStats(icon: model.icon, title: model.title, value: model.value)
            
            return cell
                
        case let .graph(graphModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as! GraphCell
            let model = graphModel[indexPath.row]
            
            cell.backgroundColor = UIColor(named: "IBColor")
            cell.prepareGraph(title: model.title)
            
            return cell
        }
        
    }
    
}
