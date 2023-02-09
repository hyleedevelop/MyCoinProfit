//
//  SummaryCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit

final class StatsCell: UITableViewCell {

    // 메뉴 제목 Label
    var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    // 메뉴 값 Label
    var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .right
        label.numberOfLines = 2
        return label
    }()
    
    // 아이콘 ImageView
    var itemIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor.label
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
        _ = [itemIcon, itemLabel, valueLabel].map{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            itemIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            itemIcon.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            itemIcon.heightAnchor.constraint(equalToConstant: 20),
            itemIcon.widthAnchor.constraint(equalTo: itemIcon.heightAnchor),
            //itemIcon.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            //itemIcon.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            
            itemLabel.leadingAnchor.constraint(equalTo: itemIcon.trailingAnchor, constant: 15),
            itemLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            itemLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            itemLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            
            valueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    // Cell 업데이트
    func prepareStats(segment: Int, mode: Int, icon: UIImage?, title: String?, value: String?) {
        var myColor = UIColor.clear
        if segment == 0 {
            for i in 0..<7 where mode == i {
                myColor = Constant.UIColorSetting.themeGradientSevenColorSet[i]
            }
        } else {
            for i in 0..<10 where mode == i {
                myColor = Constant.UIColorSetting.themeGradientTenColorSet[i]
            }
        }
        
        //self.itemIcon.tintColor = myColor
        self.itemIcon.image = icon
        self.itemLabel.text = title ?? "N/A"
        self.valueLabel.text = value  ?? "N/A"
    }
}
