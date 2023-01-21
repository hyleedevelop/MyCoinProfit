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

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate = self
        setupTabBar()
    }
    
    func setupTabBar() {
        // iOS 15 업데이트 이후 TabBar, NavigationBar가 보이지 않는 문제 해결
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = Constant.UIColorSetting.lightModeBackground
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = Constant.UIColorSetting.lightModeBackground
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        
        tabBar.tintColor = .black
        
        // 수익계산 탭 (홈)
        let vc1 = UINavigationController(rootViewController: CalcViewController())
        vc1.tabBarItem.selectedImage = UIImage(systemName: "list.clipboard.fill")
        vc1.tabBarItem.title = Constant.TitleSetting.menuName2
        vc1.tabBarItem.image = UIImage(systemName: "list.clipboard")
        
        // 설정 탭
        let vc2 = UINavigationController(rootViewController: SettingViewController())
        vc2.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        vc2.tabBarItem.title = Constant.TitleSetting.menuName3
        vc2.tabBarItem.image = UIImage(systemName: "gearshape")
        
        viewControllers = [vc1, vc2]
        
        // 앱을 처음 실행했을 때 화면에 보여줄 탭 설정 (Index = 0, 1)
        self.selectedIndex = 0
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
