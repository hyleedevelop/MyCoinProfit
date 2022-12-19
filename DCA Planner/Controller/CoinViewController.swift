//
//  PriceViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

class CoinViewController: UIViewController {
    
    private let tableLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "시가총액 순"
        return label
    }()
    
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        //view.backgroundColor = Constant.UISetting.color2
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupUI()
        setupTableContainerView()
        setupTableView()
        
//        NetworkManager.shared.fetchCoinData { result in
//            switch result {
//            case .success(let coinData):
//                print(coinData.count)
//            case .failure(.networkingError):
//                print("ERROR: networking")
//            case .failure(.dataError):
//                print("ERROR: data")
//            case .failure(.parseError):
//                print("ERROR: parsSe")
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 서버에서 데이터 가져오는 작업을 모두 마친 후에 reload 하기
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // NavigationBar 설정
    func setupNavBar() {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .orange
        navigationItem.title = Constant.Menu.menuName1
        
        self.extendedLayoutIncludesOpaqueBars = true
        
    }

    @objc func searchButtonTapped() {
//        let transition = CATransition()
//        transition.duration = Constant.Animation.transitionDuration
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromRight
//        navigationController?.view.layer.add(transition, forKey: nil)
        
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        
        //self.modalPresentationStyle = .automatic
        //self.modalTransitionStyle = .coverVertical
        //self.present(searchVC, animated: true, completion: nil)

    }
    
    func setupUI() {
        self.view.addSubview(tableLabel)
        
        // AutoLayout 설정
        tableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
    
    // TableView를 담고있는 ContainerView 설정
    func setupTableContainerView() {
        self.view.addSubview(tableContainerView)
        
        // AutoLayout 설정
        tableContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            tableContainerView.topAnchor.constraint(equalTo: tableLabel.bottomAnchor, constant: 10),
            tableContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0)
        ])
    }
    
    // TableView 설정
    func setupTableView() {
        // 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        // Cell 높이 설정
        tableView.rowHeight = 80
        // Cell 등록
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
        // Cell 사이의 구분선 설정
        tableView.separatorStyle = .singleLine
        //tableView.separatorStyle = .none
        
        // Table 테두리 설정
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 0
//        tableView.layer.borderColor = CGColor(red: 182/255, green: 226/255, blue: 161/255, alpha: 1)

        // View 위에 TableView 올리기
        view.addSubview(tableView)

        // AutoLayout 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor, constant: -0),
            tableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: -0)
        ])
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension CoinViewController: UITableViewDataSource, UITableViewDelegate {
    // TableViewCell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinTableViewCell
        cell.coinNameLabel.text = "Bitcoin"
        cell.coinSymbolLabel.text = "(" + "BTC" + ")"
        cell.coinPriceLabel.text = "$" + "17,232"
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
