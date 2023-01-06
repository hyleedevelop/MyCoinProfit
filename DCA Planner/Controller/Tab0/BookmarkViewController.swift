//
//  BookmarkViewController.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

class BookmarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupNavBar()
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.title = "저장목록"
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

}
