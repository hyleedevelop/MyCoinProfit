//
//  ThemeColorViewController.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/02/07.
//

import UIKit

final class ThemeColorViewController: UIViewController {
    
    private let calcView = CalcView()
    private let themeColorCell = ThemeColorCell()
    
    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(named: "BGColor")
        tv.separatorStyle = .none
        tv.separatorInset.left = 0
        tv.allowsSelection = true
        tv.isUserInteractionEnabled = true
        tv.allowsMultipleSelection = false
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(ThemeColorCell.self, forCellReuseIdentifier: "ThemeColorCell")
        return tv
    }()
    
    var selectedRows = [IndexPath]()
    var selectedRowNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        setupTableView()
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor(named: "BGColor")
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance

        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Theme Color"
    }

    // View 설정
    private func setupView() {
        self.view.backgroundColor = UIColor(named: "BGColor")
    }
    
    // TableView 설정
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        // 대리자 설정
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // AutoLayout 설정
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
        
        let themeIndex = UserDefaults.standard.integer(forKey: Constant.UserDefaults.themeColorNumber)
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: themeIndex, section: 0)) {
            print("test")
            cell.accessoryType = .checkmark
            cell.isSelected = true
            self.tableView.reloadData()
        }
    }
    
    // 팝업 메세지 보여주기
    private func showPopupMessage() {
        let alert = UIAlertController(title: nil,
                                      message: Constant.MessageSetting.themeColorMessage,
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false,
                             block: { _ in alert.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }})
    }
    
    // Button 설정
    @objc private func buttonSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ThemeColorViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Section 내의 Cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.UIColorSetting.themeGradientStartColors.count
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeColorCell", for: indexPath) as! ThemeColorCell
        
        //let defaults = UserDefaults.standard
        //let themeIndex = defaults.integer(forKey: Constant.UIColorSetting.themeColorNumberKey)
        
        //cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "BGColor")
        cell.tintColor = UIColor.label
        
        DispatchQueue.main.async {
            cell.sampleButton.setButtonBackgroundGradient(
                color1: Constant.UIColorSetting.themeGradientStartColors[indexPath.row],
                color2: Constant.UIColorSetting.themeGradientMiddleColors[indexPath.row],
                color3: Constant.UIColorSetting.themeGradientEndColors[indexPath.row])
        }
        
//        if themeIndex == indexPath.row {
//            cell.accessoryType = .checkmark
//            cell.isSelected = true
//        }
        
        return cell
    }
    
    // Cell 선택 시 동작 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .checkmark
//            cell.isSelected = true
//        }
        
        // NotificationCenter를 이용해서 사용자가 선택한 indexPath.row 값을 UserDefaults에 저장
        //let themeIndex = defaults.integer(forKey: Constant.UIColorSetting.themeColorNumberKey)
        UserDefaults.standard.set(indexPath.row, forKey: Constant.UserDefaults.themeColorNumber)
        UserDefaults.standard.synchronize()
        
        // 테마 컬러 정보가 바뀌었음을 NotificationCenter를 통해 알리기
        NotificationCenter.default.post(name: Notification.Name("colorChanged"), object: nil)
        showPopupMessage()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            cell.accessoryType = .none
//            cell.isSelected = false
//        }
    }
    
}

