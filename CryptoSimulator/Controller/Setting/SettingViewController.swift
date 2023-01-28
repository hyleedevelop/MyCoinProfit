//
//  SettingViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit
import AcknowList
import MessageUI

final class SettingViewController: UIViewController {

    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(named: "BGColor")
        tv.separatorStyle = .singleLine
        tv.separatorInset.left = 50
//        tv.separatorInset.right = 20
//        tv.allowsSelection = false
//        tv.isUserInteractionEnabled = true
//        tv.clipsToBounds = true
//        tv.layer.cornerRadius = 0
//        tv.layer.borderWidth = 0
        tv.sectionFooterHeight = 30
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        return tv
    }()
    
    // Switch
//    private let darkModeSwitch = UISwitch(frame: .zero)
    
    private var dataSource = [SettingCellData]()
    private var feedbackModel = [FeedbackModel]()
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
        navigationItem.title = Constant.TitleSetting.tabName3
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
        self.dataSource = [SettingCellDataManager.shared.appSettingData(),
                           SettingCellDataManager.shared.feedbackData(),
                           SettingCellDataManager.shared.aboutTheAppData()]
        tableView.reloadData()
    }
    
    // 이 앱의 버전을 문자열로 가져오기
    private func currentAppVersion() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "nil"
    }
    
    // 이 앱의 빌드 넘버를 문자열로 가져오기
    private func currentBuildNumber() -> String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let buildNumber: String = info["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "nil"
    }
    
    // 추후 업데이트 예정이라는 Alert Message 출력하기
    private func showWillBeUpdatedMessage() {
        let alert = UIAlertController(title: Constant.MessageSetting.sorryTitle,
                                      message: Constant.MessageSetting.notifyLaterUpdate,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
        case let .feedback(feedbackModel):
            return feedbackModel.count
        case let .aboutTheApp(aboutTheAppModel):
            return aboutTheAppModel.count
        }
    }
    
    // Section Header의 제목 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.dataSource[section] {
        case .appSettings(_):
            return Constant.TitleSetting.settingSectionName1
        case .feedback(_):
            return Constant.TitleSetting.settingSectionName2
        case .aboutTheApp(_):
            return Constant.TitleSetting.settingSectionName3
        }
    }

    // Section Header의 스타일 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = .label
        switch self.dataSource[section] {
        case .appSettings(_):
            title.text = Constant.TitleSetting.settingSectionName1
        case .feedback(_):
            title.text = Constant.TitleSetting.settingSectionName2
        case .aboutTheApp(_):
            title.text = Constant.TitleSetting.settingSectionName3
        }

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.font = title.font
        header.textLabel?.textColor = title.textColor
        header.textLabel?.text = title.text?.localizedCapitalized
    }
    
    // TableViewCell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.dataSource[indexPath.section] {
            
        case let .appSettings(appSettingModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            let model = appSettingModel[indexPath.row]
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "IBColor")
            return cell
            
        case let .feedback(feedbackModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            let model = feedbackModel[indexPath.row]
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "IBColor")
            return cell
        
        case let .aboutTheApp(aboutTheAppModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            let model = aboutTheAppModel[indexPath.row]
            
            // 앱 버전과 빌드 넘버를 가져와서 모델에 업데이트 하기
            //let appVersionString = "\(currentAppVersion()) (\(currentBuildNumber())))"
            //SettingCellDataManager.shared.updateAboutTheAppData(index: 3, newValue: appVersionString)
            
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            if 0...0 ~= indexPath.row {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor(named: "IBColor")
            return cell
        }
        
    }
    
    // Cell 선택 시 동작 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch self.dataSource[indexPath.section] {
        case .appSettings(_):
            if indexPath.row == 0 { showWillBeUpdatedMessage() }
        case .feedback(_):
            if indexPath.row == 0 { showWillBeUpdatedMessage() }
            if indexPath.row == 1 { contactMenuTapped() }
        case .aboutTheApp(_):
            if indexPath.row == 0 {
                let acknowListVC = AcknowListViewController(fileNamed: "Pods-CryptoSimulator-acknowledgements")
                navigationController?.pushViewController(acknowListVC, animated: true)
            }
        }
        
    }
    
}



//self.darkModeSwitch.setOn(false, animated: true)
//self.darkModeSwitch.tag = indexPath.row
//self.darkModeSwitch.addTarget(self, action: #selector(handleAppearanceChange(_:)), for: .valueChanged)
//cell.accessoryView = self.darkModeSwitch

//MARK: - Contact 메뉴를 누르면 개발자 이메일 주솔 메일 보내는 화면 보여주기

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    private func contactMenuTapped() {
        if MFMailComposeViewController.canSendMail() {
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            
            compseVC.setToRecipients(["hyleedevelop@gmail.com"])
            compseVC.setSubject("")
            compseVC.setMessageBody("", isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: Constant.MessageSetting.errorTitle,
                                                   message: Constant.MessageSetting.sendEmailErrorMessage,
                                                   preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default)
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
