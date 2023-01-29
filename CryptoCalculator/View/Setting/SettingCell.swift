//
//  SettingTableViewCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class SettingCell: UITableViewCell {
    
    // 메뉴 제목 Label
    var menuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    // 메뉴 값 Label
    var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray2
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    // 아이콘 ImageView
    var menuIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
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
        _ = [menuIcon, menuLabel, valueLabel].map{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            menuIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            menuIcon.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            //menuIcon.heightAnchor.constraint(equalToConstant: 20),
            menuIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 13),
            menuIcon.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -13),
            menuIcon.widthAnchor.constraint(equalTo: menuIcon.heightAnchor),
            
            menuLabel.leadingAnchor.constraint(equalTo: menuIcon.trailingAnchor, constant: 15),
            menuLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            menuLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            menuLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            
            valueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    // Cell 업데이트
    func prepare(icon: UIImage?, title: String?, value: String?) {
        self.menuIcon.image = icon
        self.menuLabel.text = title
        self.valueLabel.text = value
    }

}
