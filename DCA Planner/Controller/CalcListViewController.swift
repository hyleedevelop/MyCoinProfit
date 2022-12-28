//
//  CalcListViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

class CalcListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupData()
        setupNavBar()
        setupView()
        
    }
    
    // REST API를 이용해 서버에서 특정 코인의 가격 히스토리 데이터 가져오기
    private func setupData() {
        NetworkManager.shared.fetchPriceHistory(with: "bitcoin", from: 1609459200, to: 1672237280) { [weak self] result in
            switch result {
            case .success(let historyData):
                for i in 0..<historyData.count {
                    print("UnixDateStamp: \(historyData[i][0]), BTC Price: \(historyData[i][1])")
                }

                //self?.priceHistoryArray = historyData
                //DispatchQueue.main.async {
                //    self?.tableView.reloadData()
                //}
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.ColorSetting.themeColor
        navigationItem.title = Constant.MenuSetting.menuName1
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc private func addButtonTapped() {
        
    }
    

    
}
