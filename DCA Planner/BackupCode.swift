//
//  BackupCode.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/26.
//

//import Foundation


//MARK: - CoinViewController.swift


// 통화 변경 버튼
//    private lazy var currencySwitchButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("달러", for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.4)
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 10
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
//        button.tag = 0
//        button.addTarget(self, action: #selector(currencySwitchButtonTapped), for: .touchUpInside)
//        //if #available(iOS 14.0, *) {
//        //    button.menu = UIMenu(title: "통화 선택하기", image: nil, identifier: nil, options: .displayInline, children: [selectUSD, selectKRW, cancelCurrency])
//        //}
//        return button
//    }()

//    var currencyDict: [String:Rate] = [:]
//    var btcPriceKRW: Double = 0.0

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // 서버에서 데이터 가져오는 작업을 모두 마친 후에 reload 하기
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }


// 통화 변경 버튼 액션
//    private let selectUSD = UIAction(title: "달러", image: UIImage(systemName: "dollarsign")) { _ in }
//    private let selectKRW = UIAction(title: "원화", image: UIImage(systemName: "wonsign")) { _ in }
//    private let cancelCurrency = UIAction(title: "선택 취소", image: nil, attributes: .destructive) { _ in }


// REST API를 이용해 서버에서 데이터 가져오기
//private func setupData() {
//    NetworkManager.shared.fetchCurrencyData { [weak self] result in
//        switch result {
//        case .success(let currencyInfo):
//            self?.currencyDict = currencyInfo
//            self?.btcPriceKRW = (self?.currencyDict["krw"]?.value)!
//            //print(self?.btcPriceKRW)  // ***
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        case .failure(.networkingError):
//            print("ERROR: networking")
//        case .failure(.dataError):
//            print("ERROR: data")
//        case .failure(.parseError):
//            print("ERROR: parse")
//        }
//    }
//}
