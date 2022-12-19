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
    private let searchBar = UISearchBar()
    
//    override func loadView() {
//        view = searchView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 화면 배경색 설정
        view.backgroundColor = .systemBackground
        
        // NavigationBar 설정
        setupNavBar()
        
        // SearchBar 설정
        setupSearchBar()
        
        // TableView 설정
        setupTableView()
        
        // 손가락으로 화면을 좌에서 우로 스와이프 하면 이전 화면으로 돌아가는 제스쳐 설정
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.hidesBackButton = true
        tableView.reloadData()
//        searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.isActive = true
    }
    
    // 검색 화면으로 넘어갈 때 TabBar 숨기기
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    // 검색 화면으로 넘어갈 때 TabBar 숨기기
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.view.setNeedsLayout() // force update layout
//        navigationController?.view.layoutIfNeeded() // to fix height of the navigation bar
//    }
    
    // NavigationBar 설정
    func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    // SearchBar 설정
    func setupSearchBar() {
        searchBar.sizeToFit()
        searchBar.becomeFirstResponder()
        
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "코인이름"
        searchController.searchBar.setValue("닫기", forKey: "cancelButtonText")
        searchController.searchBar.setShowsCancelButton(true, animated: true)
        searchController.searchBar.setImage(UIImage(named: "x.circle"), for: .clear, state: .normal)
    }

    // TableView 설정
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
        
        // View 위에 TableView 올리기
        view.addSubview(tableView)

        // AutoLayout 설정
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
}

//MARK: - SearchBar 관련 프로토콜

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(#function)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
    }
    
    // 닫기 버튼 클릭 시 이전 화면으로 되돌아가기
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        let transition = CATransition()
//        transition.duration = Constant.Animation.transitionDuration
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromLeft
//        navigationController?.view.layer.add(transition, forKey: nil)
        
        navigationController?.popViewController(animated: true)
        
        //dismiss(animated: true, completion: nil)
    }

    // 검색 버튼을 눌렀을때 호출되는 메서드
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

}

extension SearchViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

//MARK: - TableView 관련 프로토콜

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // TableViewCell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    // TableViewCell에 표출할 내용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.movieNameLabel.text = ""
        cell.descriptionLabel.text = ""
        cell.selectionStyle = .none
        return cell
    }
    
//    // 셀의 높이 자동 설정
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // 다음화면으로 이동
//        let detailVC = DetailViewController()
//        detailVC.movieData = moviesArray[indexPath.row]
//        //show(detailVC, sender: nil)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

//MARK: - Gesture 관련 프로토콜

extension SearchViewController: UIGestureRecognizerDelegate {
    
}
