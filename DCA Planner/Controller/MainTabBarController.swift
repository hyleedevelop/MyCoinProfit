//
//  ViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    func setupTabBar() {
        // iOS 15 업데이트 이후 TabBar, NavigationBar가 보이지 않는 문제 해결
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .blue
        
        // 홈 탭
        let vc1 = UINavigationController(rootViewController: AssetViewController())
        vc1.tabBarItem.selectedImage = UIImage(systemName: "list.clipboard.fill")
        vc1.tabBarItem.title = Constant.menuName1
        vc1.tabBarItem.image = UIImage(systemName: "list.clipboard")
        
        // 투자계획 탭
        let vc2 = UINavigationController(rootViewController: PlanViewController())
        vc2.tabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")
        vc2.tabBarItem.title = Constant.menuName2
        vc2.tabBarItem.image = UIImage(systemName: "plus.circle")

        // 설정 탭
        let vc3 = UINavigationController(rootViewController: SettingViewController())
        vc3.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        vc3.tabBarItem.title = Constant.menuName3
        vc3.tabBarItem.image = UIImage(systemName: "gearshape")
        
        viewControllers = [vc1, vc2, vc3]
    }

}

