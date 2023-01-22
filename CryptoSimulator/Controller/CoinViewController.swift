//
//  PriceViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class CoinViewController: UIViewController {
    
    // SearchBar
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.sizeToFit()
        sc.searchBar.placeholder = "Enter coin name or symbol"
        sc.searchBar.searchBarStyle = .prominent
        sc.searchBar.searchTextField.keyboardType = .alphabet
        sc.searchBar.searchTextField.autocapitalizationType = .none
        sc.searchBar.searchTextField.autocorrectionType = .no
        sc.searchBar.setValue("취소", forKey: "cancelButtonText")
        return sc
    }()
    
    // 시가총액 기준 정렬 버튼
    private lazy var sortMarketCapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Market Cap ▼", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 0
        button.addTarget(self, action: #selector(sortMarketCapButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    // 가격 24시간 변화율 기준 정렬 버튼
    private lazy var sortPriceChangeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("24H Price Change", for: .normal)
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
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.clipsToBounds = false
        view.layer.cornerRadius = 0
        return view
    }()
    
    // 로딩 아이콘
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.UIColorSetting.themeColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    //weak var coinTypeDataDelegate: CoinTypeDelegate?
    
    // Timer 인스턴스 만들기
    var apiTimer: Timer?
    
    // TableView 인스턴스 만들기
    private let tableView = UITableView()
    
    // 데이터를 담을 그릇
    var coinArray = [CurrentPriceData]()  // 원본 데이터
    var coinArrayFiltered = [CurrentPriceData]()  // SearchBar 검색 결과에 의해 필터링된 데이터
    
    // 데이터 정렬 기준
    private var isUSD: Bool = true
    private var isMarketCap: Bool = true
    private var isPriceChange: Bool = true
    
    // 초기 실행
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupNavBar()
        setupView()
        setupButton()
        setupTableContainerView()
        setupTableView()
        //loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 코인시세 화면이 보여질 때마다 데이터 갱신
        loadData()
        // 코인시세 화면이 보여질 때마다 5분마다 데이터를 갱신하는 Timer 시작
        apiTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(updateData),
                                        userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 코인시세 화면에서 벗어나면 생성되어있던 Timer 종료
        apiTimer?.invalidate()
    }
    
    @objc private func updateData() {
        loadData()
        print("[\(Date())] 코인 데이터 업데이트 완료")
        //apiTimer.invalidate()
    }
    
    // REST API를 이용해 서버에서 데이터 가져오기
    private func loadData() {
        tableView.backgroundColor = .clear
        activityIndicator.startAnimating()
        
        // 강한 참조가 일어나지 않도록 [weak self]를 사용하여 구현
        NetworkManager.shared.fetchCurrentPrice { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let coinData):
                self.coinArray = coinData
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
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
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        tableView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = Constant.UIColorSetting.lightModeInbox
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.systemGray2]
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.searchController = searchController
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        
        
        navigationItem.title = "Select Your Coin"
        
        navigationItem.preferredSearchBarPlacement = .stacked
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
    }
    
    // 화면 상단의 필터링/정렬 버튼 설정
    private func setupButton() {
        view.addSubview(sortMarketCapButton)
        view.addSubview(sortPriceChangeButton)
        
        sortMarketCapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortMarketCapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            sortMarketCapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortMarketCapButton.widthAnchor.constraint(equalToConstant: 120),
            sortMarketCapButton.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        sortPriceChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortPriceChangeButton.leadingAnchor.constraint(equalTo: sortMarketCapButton.trailingAnchor, constant: 10),
            sortPriceChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortPriceChangeButton.widthAnchor.constraint(equalToConstant: 160),
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

        // Cell 등록
        tableView.register(CoinListCell.self, forCellReuseIdentifier: "CoinCell")
        // Cell 사이의 구분선 설정
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        
        // Table 테두리 설정
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 0

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
    
    // SearchBar에서 검색한 단어로 필터링하여 TableView 표출
    private func filterContentForSearchText(searchText: String) {
        coinArrayFiltered = coinArray.filter { coin in
            if isSearchBarEmpty() {
                return false
            } else {
                return coin.symbol.lowercased().contains(searchText.lowercased()) ||
                       coin.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        // 변경사항을 반영하기 위해 TableView 갱신
        self.tableView.reloadData()
    }
    
    // SearchBar에 입력된 내용의 존재 여부 확인
    private func isSearchBarEmpty() -> Bool {
        // SearchBar에 입력된 내용이 있다면 true를 반환
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Filtering 여부 확인
    private func isFiltering() -> Bool {
        // SearchController가 활성화 되어있고 SearchBar에 입력된 내용이 있다면 true를 리턴
        return searchController.isActive && !isSearchBarEmpty()
    }
    
    // 화면을 터치하면 키보드 편집 끝내기(내리기)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchController.searchBar.endEditing(true)
    }
    
    @objc private func buttonTapped(_ button: UIButton) {
        if button == navigationItem.rightBarButtonItem {
            self.dismiss(animated: true)
        }
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
                    return context.maximumDetentValue * 0.4
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
    
    @objc private func sortMarketCapButtonTapped() {
        sortMarketCapButton.layer.borderColor = UIColor.label.cgColor
        sortMarketCapButton.layer.borderWidth = 1.5
        
        sortPriceChangeButton.setTitle("24H Price Change", for: .normal)
        sortPriceChangeButton.layer.borderWidth = 0
        
        isMarketCap = !isMarketCap
        let buttonTitle = isMarketCap ? "Market Cap ▼" : "Market Cap ▲"
        sortMarketCapButton.setTitle(buttonTitle, for: .normal)
        
        if isFiltering() {
            coinArrayFiltered = isMarketCap
                              ? coinArrayFiltered.sorted(by: { $0.marketCap > $1.marketCap })
                              : coinArrayFiltered.sorted(by: { $0.marketCap < $1.marketCap })
        } else {
            coinArray = isMarketCap
                      ? coinArray.sorted(by: { $0.marketCap > $1.marketCap })
                      : coinArray.sorted(by: { $0.marketCap < $1.marketCap })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func sortPriceChangeButtonTapped() {
        sortMarketCapButton.setTitle("Market Cap", for: .normal)
        sortMarketCapButton.layer.borderWidth = 0
        
        sortPriceChangeButton.layer.borderColor = UIColor.label.cgColor
        sortPriceChangeButton.layer.borderWidth = 1.5
        
        isPriceChange = !isPriceChange
        let buttonTitle = isPriceChange ? "24H Price Change ▼" : "24H Price Change ▲"
        sortPriceChangeButton.setTitle(buttonTitle, for: .normal)
        
        if isFiltering() {
            coinArrayFiltered = isPriceChange
                              ? coinArrayFiltered.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
                              : coinArrayFiltered.sorted(by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H })
        } else {
            coinArray = isPriceChange
                      ? coinArray.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H })
                      : coinArray.sorted(by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CoinViewController: UITableViewDataSource, UITableViewDelegate {
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // TableViewCell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() { return coinArrayFiltered.count }
        return coinArray.count
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinListCell
        
        let coin: CurrentPriceData
        if isFiltering() {
            coin = coinArrayFiltered[indexPath.row]
        } else {
            coin = coinArray[indexPath.row]
        }
        //let coin = coinArray[indexPath.row]
        cell.configure(with: coin, arrayIndex: indexPath.row, currency: isUSD)
        cell.selectionStyle = .none
        return cell
    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinID = isFiltering() ? coinArrayFiltered[indexPath.row].id : coinArray[indexPath.row].id
        let coinName = isFiltering() ? coinArrayFiltered[indexPath.row].name : coinArray[indexPath.row].name
        let coinSymbol = isFiltering() ? coinArrayFiltered[indexPath.row].symbol.uppercased() : coinArray[indexPath.row].symbol.uppercased()
        //let coinMinimumDate = isFiltering() ? coinArrayFiltered[indexPath.row].atlDate : coinArray[indexPath.row].atlDate
        
        // AlertController, AlertAction 생성
        let alert = UIAlertController(title: "Confirm", message: "Do you want to choose\n \(coinName)(\(coinSymbol))?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            // calcView.coinTypeTextField.text에 선택한 코인의 이름 넣기
            //self.coinView.coinTypeTextField.text = coinArray[indexPath.row].name
            print("\(coinName) / \(coinSymbol)")
            
            // Singleton 패턴으로 데이터 전달하기
            DataPassManager.shared.selectedCoinID = coinID
            DataPassManager.shared.selectedCoinName = coinName
            DataPassManager.shared.selectedCoinSymbol = coinSymbol
            self.dismiss(animated: true)
            self.dismiss(animated: true)
        }
        
        // 액션 추가 및 팝업메세지 출력
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UISearchBarDelegate

extension CoinViewController: UISearchBarDelegate {
    
}

//MARK: - UISearchResultUpdating

extension CoinViewController: UISearchResultsUpdating {
    // 검색 결과를 반영하여 TableView 업데이트
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

//MARK: - TabBar 아이콘을 클릭했을 때 최상단 TableViewCell로 이동 (Custom Delegate Pattern)

extension CoinViewController: TabBarReselectHandling {
    func handleReselect() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
