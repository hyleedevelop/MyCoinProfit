//
//  SettingViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class SettingViewController: UIViewController {

    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = Constant.UIColorSetting.lightModeBackground
        tv.separatorStyle = .singleLine
        tv.separatorInset.left = 20
        tv.separatorInset.right = 20
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 0
        tv.layer.borderWidth = 0
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(AppSettingsCell.self, forCellReuseIdentifier: "AppSettings")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        setupTableView()
    }
    
    // NavigationBar 설정
    func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = Constant.UIColorSetting.lightModeBackground
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance

        navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.backgroundColor = .white
        navigationItem.title = Constant.TitleSetting.menuName3
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
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
        
        let appSettingsModel = AppSettingsModel(title: "test", iconImage: UIImage(systemName: "chevron.right"))
        let appSettingSection = SettingSection.appSettings([appSettingsModel])
        
        tableView.reloadData()
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Section Header의 제목 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "App Settings".localizedCapitalized
        case 1:
            return "???"
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 40
        //if indexPath.row == 3 { height = 0.0 }  // 셀 숨기기
        return height
    }
    
    // Section 내의 Cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        default:
            fatalError()
        }
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettings", for: indexPath) as! AppSettingsCell
        cell.backgroundColor = Constant.UIColorSetting.lightModeInbox
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.menuLabel.text = "Section0 - cell0"
                cell.coinImageView.image = UIImage(systemName: "chevron.right")
            }
            if indexPath.row == 1 { cell.menuLabel.text = "Section0 - cell1" }
        case 1:
            if indexPath.row == 0 { cell.menuLabel.text = "Section1 - cell0" }
            if indexPath.row == 1 { cell.menuLabel.text = "Section1 - cell1" }
            if indexPath.row == 2 { cell.menuLabel.text = "Section1 - cell2" }
        default:
            fatalError()
        }
        
        return cell
    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
