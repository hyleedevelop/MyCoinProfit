//
//  PriceViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit
import Kingfisher

class CoinViewController: UIViewController {
    
    private var isUSD: Bool = true
    private var isMarketCap: Bool = true
    private var isPriceChange: Bool = true
    
    // SearchBar
//    lazy var searchController: UISearchController = {
//        let sc = UISearchController(searchResultsController: nil)
//        sc.searchResultsUpdater = self
//        sc.searchBar.delegate = self
//        sc.obscuresBackgroundDuringPresentation = false
//        sc.searchBar.sizeToFit()
//        sc.searchBar.placeholder = "코인 검색"
//        sc.searchBar.searchBarStyle = .prominent
//        return sc
//    }()
    
    // 통화 변경 버튼
    private lazy var currencySwitchButton: UIButton = {
        let button = UIButton()
        button.setTitle("달러", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 0
        button.addTarget(self, action: #selector(currencySwitchButtonTapped), for: .touchUpInside)
        //if #available(iOS 14.0, *) {
        //    button.menu = UIMenu(title: "통화 선택하기", image: nil, identifier: nil, options: .displayInline, children: [selectUSD, selectKRW, cancelCurrency])
        //}
        return button
    }()
    
    // 통화 변경 버튼 액션
    private let selectUSD = UIAction(title: "달러", image: UIImage(systemName: "dollarsign")) { _ in }
    private let selectKRW = UIAction(title: "원화", image: UIImage(systemName: "wonsign")) { _ in }
    private let cancelCurrency = UIAction(title: "선택 취소", image: nil, attributes: .destructive) { _ in }
    
    // 시가총액 기준 정렬 버튼
    private lazy var sortMarketCapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("시가총액 ▼", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 0
        button.addTarget(self, action: #selector(sortMarketCapButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 가격 24시간 변화율 기준 정렬 버튼
    private lazy var sortPriceChangeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("24H 가격변동", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 1
        button.addTarget(self, action: #selector(sortPriceChangeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // TableView를 담고 있는 View
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        //view.backgroundColor = Constant.UISetting.color2
        view.clipsToBounds = false
        view.layer.cornerRadius = 0
        return view
    }()
    
    private let tableView = UITableView()
    
    // 코인 데이터를 담을 배열
    var coinArray: [CoinData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupButton()
        setupTableContainerView()
        setupTableView()
        setupData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // 서버에서 데이터 가져오는 작업을 모두 마친 후에 reload 하기
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchButtonTapped))
        //navigationItem.rightBarButtonItem?.tintColor = .orange
        navigationItem.title = Constant.MenuSetting.menuName1
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    @objc private func searchButtonTapped() {
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        
        //self.modalPresentationStyle = .automatic
        //self.modalTransitionStyle = .coverVertical
        //self.present(searchVC, animated: true, completion: nil)

    }
    
    // 화면 상단의 필터링/정렬 버튼 설정
    private func setupButton() {
        view.addSubview(currencySwitchButton)
        view.addSubview(sortMarketCapButton)
        view.addSubview(sortPriceChangeButton)
        
        currencySwitchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencySwitchButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            currencySwitchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            currencySwitchButton.widthAnchor.constraint(equalToConstant: 42),
            currencySwitchButton.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        sortMarketCapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortMarketCapButton.leadingAnchor.constraint(equalTo: currencySwitchButton.trailingAnchor, constant: 10),
            sortMarketCapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortMarketCapButton.widthAnchor.constraint(equalToConstant: 83),
            sortMarketCapButton.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        sortPriceChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortPriceChangeButton.leadingAnchor.constraint(equalTo: sortMarketCapButton.trailingAnchor, constant: 10),
            sortPriceChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortPriceChangeButton.widthAnchor.constraint(equalToConstant: 115),
            sortPriceChangeButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }

    // TableView를 담고있는 ContainerView 설정
    private func setupTableContainerView() {
        view.addSubview(tableContainerView)
        
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            tableContainerView.topAnchor.constraint(equalTo: sortMarketCapButton.bottomAnchor, constant: 10),
            tableContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
        ])
    }
    
    // TableView 설정
    private func setupTableView() {
        view.addSubview(tableView)
        
        // 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        // Cell 높이 설정
        tableView.rowHeight = 64
        // Cell 등록
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        // Cell 사이의 구분선 설정
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        
        // Table 테두리 설정
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 0
//        tableView.layer.borderColor = CGColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1)

        // TableView 맨 위의 Cell로 이동하기
        tableView.scrollsToTop = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        // AutoLayout 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: -0)
        ])
    }
    

    
    // 네트워킹을 통해 서버에서 데이터 가져오기
    private func setupData() {
        NetworkManager.shared.fetchCoinData { [weak self] result in
            switch result {
            case .success(let coinData):
                
                /* 정렬기준 결정 */
                //let sortedCoinData = coinData.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
                //let sortedCoinData = coinData.sorted(by: { $0.marketCap > $1.marketCap })
                //self?.coinArray = sortedCoinData
                
                self?.coinArray = coinData

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
        
    @objc private func currencySwitchButtonTapped() {
        currencySwitchButton.layer.borderColor = UIColor.label.cgColor
        currencySwitchButton.layer.borderWidth = 1.5
        
        sortMarketCapButton.setTitle("시가총액", for: .normal)
        sortMarketCapButton.layer.borderWidth = 0
        
        sortPriceChangeButton.setTitle("24H 가격변동", for: .normal)
        sortPriceChangeButton.layer.borderWidth = 0
        
        isUSD = !isUSD
        if isUSD {
            currencySwitchButton.setTitle("달러", for: .normal)
        } else {
            currencySwitchButton.setTitle("원화", for: .normal)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func sortMarketCapButtonTapped() {
        currencySwitchButton.layer.borderWidth = 0
        
        sortMarketCapButton.layer.borderColor = UIColor.label.cgColor
        sortMarketCapButton.layer.borderWidth = 1.5
        
        sortPriceChangeButton.setTitle("24H 가격변동", for: .normal)
        sortPriceChangeButton.layer.borderWidth = 0
        
        isMarketCap = !isMarketCap
        if isMarketCap {
            sortMarketCapButton.setTitle("시가총액 ▼", for: .normal)
            self.coinArray = coinArray.sorted(by: { $0.marketCap > $1.marketCap })
        } else {
            sortMarketCapButton.setTitle("시가총액 ▲", for: .normal)
            self.coinArray = coinArray.sorted(by: { $0.marketCap < $1.marketCap })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func sortPriceChangeButtonTapped() {
        currencySwitchButton.layer.borderWidth = 0
        
        sortMarketCapButton.setTitle("시가총액", for: .normal)
        sortMarketCapButton.layer.borderWidth = 0
        
        sortPriceChangeButton.layer.borderColor = UIColor.label.cgColor
        sortPriceChangeButton.layer.borderWidth = 1.5
        
        isPriceChange = !isPriceChange
        if isPriceChange {
            sortPriceChangeButton.setTitle("24H 가격변동 ▼", for: .normal)
            self.coinArray = coinArray.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
        } else {
            sortPriceChangeButton.setTitle("24H 가격변동 ▲", for: .normal)
            self.coinArray = coinArray.sorted(by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CoinViewController: UITableViewDataSource, UITableViewDelegate {
    // TableViewCell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinArray.count
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinTableViewCell
        
        // 코인 랭크 넣기
        cell.coinRank.text = String(indexPath.row + 1)
        
        // 코인 이미지 넣기 (KingFisher 사용)
        let imageURL = URL(string: coinArray[indexPath.row].image)
        cell.coinImageView.kf.setImage(with: imageURL)
        cell.coinImageView.kf.indicatorType = .activity

        // 코인 이름 넣기
        cell.coinNameLabel.text = coinArray[indexPath.row].name
        
        // 코인 심볼 넣기
        cell.coinSymbolLabel.text = coinArray[indexPath.row].symbol.uppercased()

        // 코인 가격 넣기
        let priceText: String
        if isUSD {
            priceText = coinArray[indexPath.row].currentPrice.toUSD()
        } else {
            priceText = (1279.5*coinArray[indexPath.row].currentPrice).toKRW()
        }
        cell.coinPriceLabel.text = priceText
        
        // 코인 가격 24시간 변화율 넣기
        let priceChangeValue = round(coinArray[indexPath.row].priceChangePercentage24H*100)/100
        cell.coinPriceChangeLabel.text = String(priceChangeValue) + "%"
        cell.coinPriceChangeLabel.textColor = priceChangeValue >= 0 ? Constant.ColorSetting.positiveColor : Constant.ColorSetting.negativeColor
        
        // 즐겨찾기(☆) 버튼
        //cell.watchlistButton.addTarget(self, action: #selector(watchlistButtonMarked), for: .touchUpInside)
        
        // 셀 선택 시 아무런 반응 없도록 설정
        cell.selectionStyle = .none
        
        return cell
    }
    
    // 셀의 높이 자동 설정
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 다음화면으로 이동
//        let detailVC = DetailViewController()
//        detailVC.movieData = moviesArray[indexPath.row]
//        //show(detailVC, sender: nil)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UISearchResultUpdating

//extension CoinViewController: UISearchResultsUpdating {
//    // 검색 결과를 반영하여 TableView 업데이트
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        //let filteredCoinData = coinArray.filter{ }
//
//    }
//}


//MARK: - TabBar 아이콘을 클릭했을 때 최상단 TableViewCell로 이동 (Custom Delegate Pattern)
extension CoinViewController: TabBarReselectHandling {
    func handleReselect() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
