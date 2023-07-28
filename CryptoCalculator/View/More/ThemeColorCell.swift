//
//  ThemeColorCell.swift
//  CryptoCalculator
//
//  Created by Eric on 2023/02/07.
//

import UIKit

final class ThemeColorCell: UITableViewCell {

    // theme color를 보여줄 버튼
    let sampleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.lightModeInbox
        button.layer.cornerRadius = Constant.ShapeSetting.buttonCornerRadius
        button.clipsToBounds = true
        button.setTitle(LocalizedStringKey.currentThemeColor.localize, for: .normal)
        return button
    }()
    
    // TableViewCell 생성자 셋팅 (1)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        self.setupUI()
    }
    
    // TableViewCell 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(self.sampleButton)
        
        NSLayoutConstraint.activate([
            self.sampleButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.sampleButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.sampleButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.sampleButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
    }
    
}
