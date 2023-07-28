//
//  PriceViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit
import NVActivityIndicatorView

final class CoinListViewController: UIViewController {
    
    //MARK: - UI 관련 속성
    
    // SearchBar
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.searchBar.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.sizeToFit()
        sc.searchBar.placeholder = LocalizedStringKey.enterCoinNameOrSymbol.localize
        sc.searchBar.searchBarStyle = .prominent
        sc.searchBar.searchTextField.keyboardType = .alphabet
        sc.searchBar.searchTextField.autocapitalizationType = .none
        sc.searchBar.searchTextField.autocorrectionType = .no
        sc.searchBar.setValue(LocalizedStringKey.cancel.localize, forKey: "cancelButtonText")
        return sc
    }()
    
    // 시가총액 기준 정렬 버튼
    private lazy var sortMarketCapButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalizedStringKey.marketCapDescending.localize, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.clipsToBounds = true
        button.layer.cornerRadius = 12.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 0
        button.addTarget(self, action: #selector(self.sortMarketCapButtonTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1.5
        return button
    }()
    
    // 가격 24시간 변화율 기준 정렬 버튼
    private lazy var sortPriceChangeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(LocalizedStringKey.priceChange.localize, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.clipsToBounds = true
        button.layer.cornerRadius = 12.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 1
        button.addTarget(self, action: #selector(self.sortPriceChangeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // TableView를 담고 있는 View
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BGColor")
        view.clipsToBounds = false
        view.layer.cornerRadius = 0
        return view
    }()
    
    // 로딩 아이콘
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 50, height: 50),
            type: .ballRotateChase,
            color: .white,
            padding: .zero
        )
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.label
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    //MARK: - 인스턴스 관련 속성
    
    // Timer 인스턴스 만들기
    private var apiTimer: Timer?
    
    // TableView 인스턴스 만들기
    private let tableView = UITableView()
    
    // 데이터를 담을 그릇
    private var coinArray = [CurrentPriceData]()  // 원본 데이터
    private var filteredCoinArray = [CurrentPriceData]()  // SearchBar 검색 결과에 의해 필터링된 데이터
    
    // 데이터 정렬 기준
    private var isUSD: Bool = true
    private var isMarketCap: Bool = true
    private var isPriceChange: Bool = true
    
    //MARK: - 뷰의 생명 주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setupActivityIndicator()
        self.setupNavBar()
        self.setupView()
        self.setupButton()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 코인시세 화면이 보여질 때마다 데이터 갱신
        self.fetchData()
        // 코인시세 화면이 보여질 때마다 5분마다 데이터를 갱신하는 Timer 시작
        self.apiTimer = Timer.scheduledTimer(
            timeInterval: 300, target: self, selector: #selector(updateData),
            userInfo: nil, repeats: true
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 코인시세 화면에서 벗어나면 생성되어있던 Timer 종료
        self.apiTimer?.invalidate()
    }
    
    //MARK: - UI 관련 메서드
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        self.tableView.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        self.navigationController?.applyDefaultSettings()

        self.navigationItem.searchController = searchController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"), style: .plain,
            target: self, action: #selector(buttonTapped(_:))
        )
        self.navigationItem.rightBarButtonItem?.tintColor = .systemGray2
        self.navigationItem.hidesSearchBarWhenScrolling = false        
        self.navigationItem.title = LocalizedStringKey.selectType.localize
    }
    
    // View 설정
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BGColor")
    }
    
    // 화면 상단의 필터링/정렬 버튼 설정
    private func setupButton() {
        // 시가총액 기준 정렬 버튼
        self.view.addSubview(self.sortMarketCapButton)
        self.sortMarketCapButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sortMarketCapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.sortMarketCapButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.sortMarketCapButton.widthAnchor.constraint(equalToConstant: 120),
            self.sortMarketCapButton.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        // 24시간 가격 변화율 기준 정렬 버튼
        self.view.addSubview(self.sortPriceChangeButton)
        sortPriceChangeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.sortPriceChangeButton.leadingAnchor.constraint(equalTo: self.sortMarketCapButton.trailingAnchor, constant: 10),
            self.sortPriceChangeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.sortPriceChangeButton.widthAnchor.constraint(equalToConstant: 160),
            self.sortPriceChangeButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // TableView 설정
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        
        // 대리자 설정
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Cell 등록
        self.tableView.register(
            CoinListCell.self, forCellReuseIdentifier: Constant.Identifier.coinCell
        )
        
        // Cell 사이의 구분선 설정
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset.left = 0
        
        // Table 테두리 설정
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 0
        self.tableView.layer.borderWidth = 0

        // TableView 맨 위의 Cell로 이동하기
        self.tableView.scrollsToTop = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)

        // AutoLayout 설정
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            self.tableView.topAnchor.constraint(equalTo: self.sortMarketCapButton.bottomAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
        ])
    }
    
    //MARK: - 검색 관련 메서드
    
    // SearchBar에서 검색한 단어로 필터링하여 TableView 표출
    private func filterContentForSearchText(searchText: String) {
        self.filteredCoinArray = self.coinArray.filter {
            return self.isSearchBarEmpty
            ? false
            : $0.symbol.lowercased().contains(searchText.lowercased()) ||
              $0.name.lowercased().contains(searchText.lowercased())
        }
        
        // 변경사항을 반영하기 위해 TableView 갱신
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Filtering 여부 확인
    private var isResultFiltered: Bool {
        // SearchController가 활성화 되어있고 SearchBar에 입력된 내용이 있다면 true를 리턴
        return self.searchController.isActive && !isSearchBarEmpty
    }
    
    // SearchBar에 입력된 내용의 존재 여부 확인
    private var isSearchBarEmpty: Bool {
        // SearchBar에 입력된 내용이 있다면 true를 반환
        return self.searchController.searchBar.text?.isEmpty ?? true
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
    
    //MARK: - 테이블뷰 아이템 정렬 관련 메서드
    
    @objc private func sortMarketCapButtonTapped() {
        self.sortMarketCapButton.layer.borderColor = UIColor.label.cgColor
        self.sortMarketCapButton.layer.borderWidth = 1.5
        
        self.sortPriceChangeButton.setTitle(LocalizedStringKey.priceChange.localize, for: .normal)
        self.sortPriceChangeButton.layer.borderWidth = 0
        
        self.isMarketCap.toggle()
        self.sortMarketCapButton.setTitle(
            self.isMarketCap
            ? LocalizedStringKey.marketCapDescending.localize
            : LocalizedStringKey.marketCapAscending.localize,
            for: .normal
        )
        
        if self.isResultFiltered {
            self.filteredCoinArray = self.isMarketCap
            ? self.filteredCoinArray.sorted(by: { $0.marketCap > $1.marketCap })
            : self.filteredCoinArray.sorted(by: { $0.marketCap < $1.marketCap })
        } else {
            self.coinArray = self.isMarketCap
            ? self.coinArray.sorted(by: { $0.marketCap > $1.marketCap })
            : self.coinArray.sorted(by: { $0.marketCap < $1.marketCap })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc private func sortPriceChangeButtonTapped() {
        self.sortMarketCapButton.setTitle(LocalizedStringKey.marketCap.localize, for: .normal)
        self.sortMarketCapButton.layer.borderWidth = 0
        
        self.sortPriceChangeButton.layer.borderColor = UIColor.label.cgColor
        self.sortPriceChangeButton.layer.borderWidth = 1.5
        
        self.isPriceChange.toggle()
        self.sortPriceChangeButton.setTitle(
            self.isPriceChange
            ? LocalizedStringKey.priceChangeDescending.localize
            : LocalizedStringKey.priceChangeAscending.localize,
            for: .normal
        )
        
        if self.isResultFiltered {
            self.filteredCoinArray = self.isPriceChange
            ? self.filteredCoinArray.sorted(
                by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H }
            )
            : self.filteredCoinArray.sorted(
                by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H }
            )
        } else {
            self.coinArray = self.isPriceChange
            ? self.coinArray.sorted(
                by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H }
            )
            : self.coinArray.sorted(
                by: { $0.priceChangePercentage24H < $1.priceChangePercentage24H }
            )
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - 네트워킹 관련 메서드
    
    @objc private func updateData() {
        self.fetchData()
    }
    
    // REST API를 이용해 서버에서 데이터 가져오기
    private func fetchData() {
        DispatchQueue.main.async {
            self.tableView.backgroundColor = UIColor(named: "BGColor")
            self.activityIndicator.startAnimating()
        }
        
        // 현재 코인 가격 데이터 받아오기
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
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CoinListViewController: UITableViewDataSource, UITableViewDelegate {
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // TableViewCell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isResultFiltered ? self.filteredCoinArray.count : self.coinArray.count
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.coinCell, for: indexPath) as? CoinListCell else { return UITableViewCell() }
        
        let coin: CurrentPriceData = self.isResultFiltered
        ? filteredCoinArray[indexPath.row]
        : coinArray[indexPath.row]
        
        cell.configure(with: coin, arrayIndex: indexPath.row, currency: isUSD)
        cell.selectionStyle = .none
        return cell
    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinID = self.isResultFiltered
        ? self.filteredCoinArray[indexPath.row].id
        : self.coinArray[indexPath.row].id
        
        let coinName = self.isResultFiltered
        ? self.filteredCoinArray[indexPath.row].name
        : self.coinArray[indexPath.row].name
        
        let coinSymbol = self.isResultFiltered
        ? self.filteredCoinArray[indexPath.row].symbol.uppercased()
        : self.coinArray[indexPath.row].symbol.uppercased()
        
        // AlertController, AlertAction 생성
        let languageCode = String(NSLocale.preferredLanguages[0]).dropLast(3)  // 언어코드-지역코드 (ko-KR => ko, en-US => en)
        let message = languageCode == "en"
        ? LocalizedStringKey.selectCoinMessage.localize + "\n\(coinName)(\(coinSymbol))?"
        : "\(coinName)(\(coinSymbol))" + LocalizedStringKey.selectCoinMessage.localize
        
        let alert = UIAlertController(
            title: LocalizedStringKey.confirm.localize,
            message: message, preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: LocalizedStringKey.no.localize,
            style: .default,
            handler: nil
        )
        let okAction = UIAlertAction(
            title: LocalizedStringKey.yes.localize,
            style: .default
        ) { [weak self] _ in
            // Singleton 패턴으로 CalcVC의 coinTypeTextField에게 데이터 전달하기
            DataPassManager.shared.selectedCoinID = coinID
            DataPassManager.shared.selectedCoinName = coinName
            DataPassManager.shared.selectedCoinSymbol = coinSymbol
            //self.dismiss(animated: true)
            guard let self = self else { return }
            self.searchController.isActive = false
            self.dismiss(animated: true)
        }
        
        // 액션 추가 및 팝업메세지 출력
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - 서치바 관련 델리게이트 메서드

extension CoinListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    // 검색 결과를 반영하여 TableView를 업데이트하는 메서드 실행
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchText: searchBar.text!)
    }
    
}
