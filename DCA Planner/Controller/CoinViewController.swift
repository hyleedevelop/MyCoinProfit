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
        sc.searchBar.placeholder = "코인 이름 또는 심볼 입력"
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
        button.setTitle("시가총액 ▼", for: .normal)
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
        view.clipsToBounds = false
        view.layer.cornerRadius = 0
        return view
    }()
    
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
        
        setupData()
        setupNavBar()
        setupView()
        setupButton()
        setupTableContainerView()
        setupTableView()
    }
    
    // REST API를 이용해 서버에서 데이터 가져오기
    private func setupData() {
        NetworkManager.shared.fetchCurrentPrice { [weak self] result in
            switch result {
            case .success(let coinData):
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
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.ColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.ColorSetting.themeColor
        navigationItem.title = Constant.MenuSetting.menuName1
        navigationItem.searchController = searchController
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // 화면 상단의 필터링/정렬 버튼 설정
    private func setupButton() {
        view.addSubview(sortMarketCapButton)
        view.addSubview(sortPriceChangeButton)
        
        sortMarketCapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortMarketCapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            sortMarketCapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortMarketCapButton.widthAnchor.constraint(equalToConstant: 83),
            sortMarketCapButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        sortPriceChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortPriceChangeButton.leadingAnchor.constraint(equalTo: sortMarketCapButton.trailingAnchor, constant: 10),
            sortPriceChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            sortPriceChangeButton.widthAnchor.constraint(equalToConstant: 117),
            sortPriceChangeButton.heightAnchor.constraint(equalToConstant: 24),
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
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
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
                    return context.maximumDetentValue * 0.75
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
        
        sortPriceChangeButton.setTitle("24H 가격변동", for: .normal)
        sortPriceChangeButton.layer.borderWidth = 0
        
        isMarketCap = !isMarketCap
        let buttonTitle = isMarketCap ? "시가총액 ▼" : "시가총액 ▲"
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
        sortMarketCapButton.setTitle("시가총액", for: .normal)
        sortMarketCapButton.layer.borderWidth = 0
        
        sortPriceChangeButton.layer.borderColor = UIColor.label.cgColor
        sortPriceChangeButton.layer.borderWidth = 1.5
        
        isPriceChange = !isPriceChange
        let buttonTitle = isPriceChange ? "24H 가격변동 ▼" : "24H 가격변동 ▲"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinTableViewCell
        
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
//        // 다음화면으로 이동
//        let detailVC = DetailViewController()
//        detailVC.movieData = moviesArray[indexPath.row]
//        //show(detailVC, sender: nil)
//        navigationController?.pushViewController(detailVC, animated: true)
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
