//
//  CalcTypeView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcTypeView: UIView {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.showsVerticalScrollIndicator = true
        return view
    }()
    
    private let contentView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // View 생성자 셋팅 (1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollView()
        setupContentView()
    }
        
    // View 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView1)
        
        NSLayoutConstraint.activate([
            contentView1.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            contentView1.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            contentView1.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentView1.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
        ])
    }

}
