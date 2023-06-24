//
//  StatsCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit

final class StatsCell: UITableViewCell {

    //MARK: - UI
    
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
    
    //MARK: - 생성자
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 오토레이아웃
    
    private func setupUI() {
        [itemIcon, itemLabel, valueLabel].forEach {
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            self.itemIcon.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.itemIcon.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
            self.itemIcon.heightAnchor.constraint(equalToConstant: 20),
            self.itemIcon.widthAnchor.constraint(equalTo: self.itemIcon.heightAnchor),
            
            self.itemLabel.leadingAnchor.constraint(equalTo: self.itemIcon.trailingAnchor, constant: 15),
            self.itemLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.itemLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.itemLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            
            self.valueLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.valueLabel.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    //MARK: - 셀 내용 업데이트
    
    func prepareStats(segment: Int, mode: Int, icon: UIImage?, title: String?, value: String?) {
        self.itemIcon.image = icon
        self.itemLabel.text = title ?? "N/A"
        self.valueLabel.text = value ?? "N/A"
    }
    
}
