//
//  SearchViewController.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/15.
//

import UIKit

class SearchViewController: UIViewController {

    private let tableView = UITableView()
    private let searchController = UISearchController()
    private let searchView = SearchView()

//    var navigationBarHeight: CGFloat {
//        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
//        (self.navigationController?.navigationBar.frame.height ?? 0.0)
//    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = true
    }
    
    // NavigationBar 설정
    func setupNavBar() {
//        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    // SearchBar 설정
    func setupSearchBar() {
        //navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "투자할 상품의 이름을 입력하세요"
        searchController.searchBar.setValue("닫기", forKey: "cancelButtonText")
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        searchController.searchBar.setImage(UIImage(named: "x.circle"), for: .clear, state: .normal)
    }

}

extension SearchViewController: UISearchBarDelegate {

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text?.lowercased() else {
            return
        }
        print(text)
//        musicManager.fetchDatasFromAPI(withATerm: text) {
//            DispatchQueue.main.async {
//                self.musicTableView.reloadData()
//            }
//        }
    }
    
    // 닫기 버튼 클릭 시 이전 화면으로 되돌아가기
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
}
