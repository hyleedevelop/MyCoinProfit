//
//  SettingViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit
import SafariServices
import MessageUI
import GoogleMobileAds

final class SettingViewController: UIViewController {

    //MARK: - UI
    
    // 구글 애드몹
    lazy var bannerView: GADBannerView = {
        let banner = GADBannerView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        return banner
    }()
    
    // TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect(), style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(named: "BGColor")
        tv.separatorStyle = .singleLine
        tv.separatorInset.left = 50
        tv.sectionFooterHeight = 30
        tv.scrollsToTop = true
        tv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        tv.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        return tv
    }()
    
    //MARK: - 인스턴스 관련 속성
    
    private var dataSource = [SettingCellData]()
    private var feedbackModel = [FeedbackModel]()
    private var aboutTheAppModel = [AboutTheAppModel]()
    
    //MARK: - 일반 속성
    
    // 이 앱의 버전을 문자열로 가져오기
    private var currentAppVersion: String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let currentVersion: String = info["CFBundleShortVersionString"] as? String {
            return currentVersion
        }
        return "nil"
    }
    
    // 이 앱의 빌드 넘버를 문자열로 가져오기
    private var currentBuildNumber: String {
        if let info: [String: Any] = Bundle.main.infoDictionary,
           let buildNumber: String = info["CFBundleVersion"] as? String {
            return buildNumber
        }
        return "nil"
    }
    
    //MARK: - 뷰의 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupView()
        self.setupTableView()
        self.setupTableViewDataSource()
        
        self.setupBannerViewToBottom()
    }
    
    //MARK: - UI 관련 메서드
    
    // NavigationBar 설정
    private func setupNavBar() {
        self.navigationController?.applyDefaultSettings()
        
        self.navigationItem.title = LocalizedStringKey.more.localize
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
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
        ])
    }
    
    // TableViewCell에 표출할 내용을 담은 Model
    private func setupTableViewDataSource() {
        // 앱 버전과 빌드 넘버를 가져와서 모델에 업데이트 하기
        let appVersionString = "\(currentAppVersion) (\(currentBuildNumber))"
        SettingCellManager.shared.updateAboutTheAppData(index: 4, newValue: appVersionString)
        
        self.dataSource = [SettingCellManager.shared.appSettingData,
                           SettingCellManager.shared.feedbackData,
                           SettingCellManager.shared.aboutTheAppData]

        self.tableView.reloadData()
    }
    
    // 추후 업데이트 예정이라는 Alert Message 출력하기
    private func showWillBeUpdatedMessage() {
        let alert = UIAlertController(
            title: LocalizedStringKey.error.localize,
            message: LocalizedStringKey.laterUpdateMessage.localize,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: LocalizedStringKey.ok.localize, style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
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
        case .appSettings(_): return LocalizedStringKey.setting.localize
        case .feedback(_): return LocalizedStringKey.feedback.localize
        case .aboutTheApp(_): return LocalizedStringKey.aboutTheApp.localize
        }
    }

    // Section Header의 스타일 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = .label
        switch self.dataSource[section] {
        case .appSettings(_): title.text = LocalizedStringKey.setting.localize
        case .feedback(_): title.text = LocalizedStringKey.feedback.localize
        case .aboutTheApp(_): title.text = LocalizedStringKey.aboutTheApp.localize
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor(named: "IBColor")
        cell.selectionStyle = .none
        
        switch self.dataSource[indexPath.section] {
        case let .appSettings(appSettingModel):
            let model = appSettingModel[indexPath.row]
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            cell.accessoryType = .disclosureIndicator
            
        case let .feedback(feedbackModel):
            let model = feedbackModel[indexPath.row]
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            cell.accessoryType = .disclosureIndicator
        
        case let .aboutTheApp(aboutTheAppModel):
            let model = aboutTheAppModel[indexPath.row]
            cell.prepare(icon: model.icon, title: model.title, value: model.value)
            if 0...2 ~= indexPath.row {
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.accessoryType = .none
            }
            
        }
        
        return cell
    }
    
    // Cell 선택 시 동작 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch self.dataSource[indexPath.section] {
        case .appSettings(_):
            if indexPath.row == 0 {
                let themeColorVC = ThemeColorViewController()
                navigationController?.pushViewController(themeColorVC, animated: true)
            }
        case .feedback(_):
            if indexPath.row == 0 {
                guard let writeReviewURL = URL(string: Constant.URLSetting.writeReviewURL) else { return }
                UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
            }
            if indexPath.row == 1 { contactMenuTapped() }
        case .aboutTheApp(_):
            if indexPath.row == 0 {
                let websiteURL = NSURL(string: Constant.URLSetting.helpURL)
                let webView = SFSafariViewController(url: websiteURL! as URL)
                self.present(webView, animated: true, completion: nil)
            }
            if indexPath.row == 1 {
                let websiteURL = NSURL(string: Constant.URLSetting.privacyPolicyURL)
                let webView = SFSafariViewController(url: websiteURL! as URL)
                self.present(webView, animated: true, completion: nil)
            }
            if indexPath.row == 2 {
                let websiteURL = NSURL(string: Constant.URLSetting.termsAndConditionsURL)
                let webView = SFSafariViewController(url: websiteURL! as URL)
                self.present(webView, animated: true, completion: nil)
            }
        }
        
    }
    
}

//MARK: - Contact 메뉴를 누르면 개발자 이메일 주소로 메일 보내는 화면 보여주기

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    private func contactMenuTapped() {
        if MFMailComposeViewController.canSendMail() {
            // 앱 이름 저장
            var appName: String? {
                if let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
                    return bundleDisplayName
                } else if let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
                    return bundleName
                }
                return nil
            }
            
            // 앱 버전 저장
            var appVersion: String? {
                if let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    return bundleVersion
                } else {
                    return nil
                }
            }
            
            // 기기 이름 저장
            var device: String? {
                var modelName = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? ""
                let myDevice = UIDevice.current
                let selName = "_\("deviceInfo")ForKey:"
                let selector = NSSelectorFromString(selName)
                
                if myDevice.responds(to: selector) {
                    modelName = String(describing: myDevice.perform(selector, with: "marketing-name").takeRetainedValue())
                    return modelName
                } else {
                    return nil
                }
            }
            
            // 기기 OS 버전 저장
            let iOSVersion = UIDevice.current.systemVersion
            
            let messageBody: String = "* My Info *" + "\n" +
                                      "App name: \(appName ?? "N/A")" + "\n" +
                                      "App version: \(appVersion ?? "N/A")" + "\n" +
                                      "Device name: \(device ?? "N/A")" + "\n" +
                                      "Device OS version: \(iOSVersion)" + "\n"
            
            let compseVC = MFMailComposeViewController()
            compseVC.mailComposeDelegate = self
            compseVC.setToRecipients(["hyleedevelop@gmail.com"])
            compseVC.setSubject("[App Contact Email] ")
            compseVC.setMessageBody(messageBody, isHTML: false)
            
            self.present(compseVC, animated: true, completion: nil)
        }
        else {
            let sendMailErrorAlert = UIAlertController(
                title: LocalizedStringKey.error.localize,
                message: LocalizedStringKey.emailSettingMessage.localize,
                preferredStyle: .alert
            )
            let confirmAction = UIAlertAction(title: LocalizedStringKey.ok.localize, style: .default)
            sendMailErrorAlert.addAction(confirmAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//MARK: - 구글 애드몹 관련 메서드

extension SettingViewController: GADBannerViewDelegate {
    
    func setupBannerViewToBottom(height: CGFloat = 50) {
        let adSize = GADAdSizeFromCGSize(CGSize(width: view.frame.width, height: height))
        self.bannerView = GADBannerView(adSize: adSize)

        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.bannerView)
        NSLayoutConstraint.activate([
            self.bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            self.bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.bannerView.heightAnchor.constraint(equalToConstant: height)
        ])

        self.bannerView.adUnitID = Constant.URLSetting.admobBottomBannerMyID
        self.bannerView.rootViewController = self
        self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
    }
    
    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 1
        }
    }
    
    // Tells the delegate an ad request failed.
    private func adView(_ bannerView: GADBannerView,
                        didFailToReceiveAdWithError error: Error) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
}
