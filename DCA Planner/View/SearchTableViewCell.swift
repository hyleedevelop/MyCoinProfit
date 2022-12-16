//
//  SearchTableViewCell.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/16.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution  = .fill
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        // 뷰컨트롤러의 기본뷰 위에 스택뷰 올리기
        self.addSubview(stackView)
        
        // 스택뷰 위에 뷰들 올리기
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    // 오토레이아웃 정하는 정확한 시점
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    func setupConstraints() {
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieNameLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5)
        ])
    }

}
