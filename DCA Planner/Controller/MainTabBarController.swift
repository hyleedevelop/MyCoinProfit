//
//  ViewController.swift
//  DCA Reminder
//
//  Created by Eric on 2022/12/14.
//

import UIKit

protocol TabBarReselectHandling {
    func handleReselect()
}

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
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
        
        tabBar.tintColor = Constant.ColorSetting.themeColor
        
        // 홈 탭
        let vc1 = UINavigationController(rootViewController: CoinViewController())
        vc1.tabBarItem.selectedImage = UIImage(systemName: "dollarsign.circle.fill")
        vc1.tabBarItem.title = Constant.MenuSetting.menuName1
        vc1.tabBarItem.image = UIImage(systemName: "dollarsign.circle")
        
        // 투자계획 탭
        let vc2 = UINavigationController(rootViewController: PlanViewController())
        vc2.tabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")
        vc2.tabBarItem.title = Constant.MenuSetting.menuName2
        vc2.tabBarItem.image = UIImage(systemName: "plus.circle")

        // 설정 탭
        let vc3 = UINavigationController(rootViewController: SettingViewController())
        vc3.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        vc3.tabBarItem.title = Constant.MenuSetting.menuName3
        vc3.tabBarItem.image = UIImage(systemName: "gearshape")
        
        viewControllers = [vc1, vc2, vc3]
    }

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedViewController === viewController,
           let handler = viewController as? TabBarReselectHandling {
            handler.handleReselect()
        }
        return true
    }
}
