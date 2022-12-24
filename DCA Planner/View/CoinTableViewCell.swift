//
//  PriceTableViewCell.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/15.
//

import UIKit

final class CoinTableViewCell: UITableViewCell {
    
    // 코인 이미지
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 코인 이름
    let coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    // 코인 심볼
    let coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    // Vertical SV (코인 이름 + 코인 심볼)
    lazy var nameLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinNameLabel, coinSymbolLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
    
    // 코인 가격
    let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    // 24시간 전 대비 코인 가격 변화율
    let coinPriceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .right
        return label
    }()
    
    // Vertical SV (코인 가격 + 코인 가격 변화율)
    lazy var priceLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinPriceLabel, coinPriceChangeLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        return sv
    }()
    
    // Horizontal SV (코인 이미지 + Vertical SV + Vertical SV)
    lazy var cellSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinImageView, nameLabelSV, priceLabelSV])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 15
        return sv
    }()
    
    // TableViewCell 생성자 셋팅 (1)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(cellSV)
        updateConstraints()
    }
    
    // TableViewCell 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // AutoLayout 결정하는 시점
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    // AutoLayout 설정
    func setupConstraints() {
        coinImageView.translatesAutoresizingMaskIntoConstraints = false
        coinNameLabel.translatesAutoresizingMaskIntoConstraints = false
        coinSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabelSV.translatesAutoresizingMaskIntoConstraints = false
        coinPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        coinPriceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabelSV.translatesAutoresizingMaskIntoConstraints = false
        cellSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            coinImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            coinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameLabelSV.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            priceLabelSV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            priceLabelSV.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            cellSV.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        
    }

}
