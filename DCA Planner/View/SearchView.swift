//
//  SearchView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/15.
//

import UIKit

final class SearchView: UIView {
    
//    let searchBar: UISearchBar = {
//        let bar = UISearchBar()
//        bar.showsCancelButton = true
//        bar.searchBarStyle = .default
//        bar.layer.borderWidth = 0
//        return bar
//    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = .init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setupConstraint()
        super.updateConstraints()  // 상위메서드 호출은 맨 마지막에 수행
    }
    
    func setupUI() {
        self.backgroundColor = .systemBackground
        
//        self.addSubview(searchBar)
        //self.addSubview(closeButton)
    }
    
    func setupConstraint() {
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
//            searchBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            searchBar.heightAnchor.constraint(equalToConstant: 50)
//        ])
        
//        NSLayoutConstraint.activate([
//            closeButton.widthAnchor.constraint(equalToConstant: 70),
//            closeButton.heightAnchor.constraint(equalToConstant: 30),
//            closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        ])

    }

}
