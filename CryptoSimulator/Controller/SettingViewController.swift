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
        tv.backgroundColor = UIColor(named: "BGColor")
        tv.separatorStyle = .singleLine
        tv.separatorInset.left = 50
        //tv.separatorInset.right = 20
        tv.allowsSelection = false
        tv.clipsToBounds = true
        tv.layer.cornerRadius = 0
        tv.layer.borderWidth = 0
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        return tv
    }()
    
    // Switch
    private let darkModeSwitch = UISwitch(frame: .zero)
    
    private var dataSource = [SettingTableViewModel]()
    private var appSettingsModel = [AppSettingsModel]()
    private var aboutTheAppModel = [AboutTheAppModel]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.darkModeSwitch.isOn = userDefaults.bool(forKey: "appearanceSwitchState")
//        updateInterfaceStyle()
        
        setupNavBar()
        setupView()
        setupTableView()
        setupTableViewDataSource()
    }
    
    // NavigationBar 설정
    func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = UIColor(named: "BGColor")
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
        navigationItem.title = Constant.TitleSetting.menuName3
        
//        let image = UIImage(named: "app_icon_gradient.jpeg")
//        navigationItem.titleView = UIImageView(image: image)
        
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = UIColor(named: "BGColor")
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
    }
    
    // TableViewCell에 표출할 내용을 담은 Model
    private func setupTableViewDataSource() {
        let aboutTheAppModel = [
            AboutTheAppModel(icon: UIImage(systemName: "giftcard"), title: "Tips for App Developer", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "star"), title: "Rate The App", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "envelope"), title: "Contact", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "doc.text"), title: "Privacy & Terms", value: nil),
            AboutTheAppModel(icon: UIImage(systemName: "number.circle"), title: "App Version", value: "1.0.0")
        ]
        
        let aboutTheAppSection = SettingTableViewModel.aboutTheApp(aboutTheAppModel)
        
        self.dataSource = [aboutTheAppSection]
        tableView.reloadData()
    }
    
//    // 스위치 상태 저장하기 위해 UserDefaults에 상태 저장
//    func updateInterfaceStyle() {
//        if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//            let windows = window.windows.first
//            windows?.overrideUserInterfaceStyle = self.darkModeSwitch.isOn == true ? .dark : .light
//            userDefaults.set(self.darkModeSwitch.isOn, forKey: "appearanceSwitchState")
//        }
//    }
        
//    @objc func handleAppearanceChange(_ sender: UISwitch) {
//        UIView.animate(withDuration: 0.4) {
//            self.updateInterfaceStyle()
//        }
//    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Section의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    // Section 내의 Cell 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .appSettings(appSettingsModel):
            return appSettingsModel.count
        case let .aboutTheApp(aboutTheAppModel):
            return aboutTheAppModel.count
        }
    }
    
    // Section Header의 제목 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "About The App"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.text = "About The App"
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        title.textColor = .label

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.font = title.font
        header.textLabel?.textColor = title.textColor
        header.textLabel?.text = title.text?.localizedCapitalized
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
            
        // Section - App Settings
        case let .appSettings(appSettingsModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            _ = appSettingsModel[indexPath.row]

            //self.darkModeSwitch.setOn(false, animated: true)
            //self.darkModeSwitch.tag = indexPath.row
            //self.darkModeSwitch.addTarget(self, action: #selector(handleAppearanceChange(_:)), for: .valueChanged)
            //cell.accessoryView = self.darkModeSwitch
            
            return cell
                
        // Section - About The App
        case let .aboutTheApp(aboutTheAppModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            let model = aboutTheAppModel[indexPath.row]
            
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            if 0...3 ~= indexPath.row {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
            return cell
                
        }
    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
        
    }
    
}
