//
//  SettingTableViewCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class AppSettingsCell: UITableViewCell {
    
    // 메뉴 제목 Label
    let menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    // 아이콘 ImageView
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    // Horizontal StackView (menuLabel + coinImageView)
    lazy var cellSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [menuLabel, coinImageView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    // TableViewCell 생성자 셋팅 (1)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        setupUI()
    }
    
    // TableViewCell 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 설정
    private func setupUI() {
        self.addSubview(cellSV)
        
        NSLayoutConstraint.activate([
            cellSV.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cellSV.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cellSV.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            cellSV.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            
            coinImageView.centerYAnchor.constraint(equalTo: cellSV.centerYAnchor),
            coinImageView.heightAnchor.constraint(equalTo: cellSV.heightAnchor, multiplier: 0.4),
            //coinImageView.widthAnchor.constraint(equalTo: coinImageView.heightAnchor),
        ])
    }

}
