//
//  CalcTypeViewController.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcTypeViewController: UIViewController {

    private let calcTypeView = CalcTypeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.ColorSetting.themeColor
        navigationItem.title = Constant.MenuSetting.menuName2
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
  
    override func loadView() {
        view = calcTypeView
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    @objc private func addButtonTapped() {
        let bookmarkVC = BookmarkViewController()
        navigationController?.pushViewController(bookmarkVC, animated: true)
    }

}
