//
//  SettingViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class SettingViewController: UIViewController {

    // 레퍼런스 문구
    let referenceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Powered by CoinGecko"
        label.numberOfLines = 1
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    
    // NavigationBar 설정
    func setupNavBar() {
        view.backgroundColor = .systemBackground
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .orange
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

//    private func setupReferenceLabel() {
//        view.addSubview(referenceLabel)
//
//        referenceLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            referenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            referenceLabel.topAnchor.constraint(equalTo: tableContainerView.bottomAnchor, constant: 5),
//            //referenceLabel.widthAnchor.constraint(equalToConstant: 150),
//            referenceLabel.heightAnchor.constraint(equalToConstant: 15),
//        ])
//    }
    
}
