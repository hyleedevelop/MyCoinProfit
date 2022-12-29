//
//  CalcListViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

class CalcListViewController: UIViewController {

    private let calcListView = CalcListView()
    
    // 데이터를 담을 그릇
    var dateArray = [Double]()
    var priceArray = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupData()
        setupNavBar()
        setupView()
        setupPickerView()
        
        //sleep(3)
        //DispatchQueue.main.async {
        //    print(self.dateArray)
        //    print(self.priceArray)
        //}
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // 사용자가 입력한 값
    var coinType = "bitcoin"
    var startDate = 1609459200
    var endDate = 1672237280
    var numberOfDays = 30
    
    // REST API를 이용해 서버에서 특정 코인의 가격 히스토리 데이터 가져오기
    private func setupData() {
        NetworkManager.shared.fetchPriceHistory(with: coinType, howManyDays: numberOfDays) { [weak self] result in
            switch result {
            case .success(let historyData):
                for i in 0..<historyData.count {
                    let dateValue = historyData[i][0]
                    let priceValue = historyData[i][1]
                    self?.dateArray.append(dateValue)
                    self?.priceArray.append(priceValue)
                }
                
                print((self?.dateArray)!)
                print((self?.priceArray)!)
                
                //let unixToDate = Date(timeIntervalSince1970: 1609459200)
                //print("the given unix time is \(unixToDate)")
                
                //let today = Date().timeIntervalSince1970
                //print("today's unix time is \(today)")
                
                //DispatchQueue.main.async {
                //
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
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.ColorSetting.themeColor
        navigationItem.title = Constant.MenuSetting.menuName2
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    override func loadView() {
        view = calcListView
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    // PickerView 설정
    private func setupPickerView() {
        
    }
    
    // 화면을 터치하면 키보드 편집 끝내기(내리기)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        calcListView.endEditing(true)
    }
    
}
