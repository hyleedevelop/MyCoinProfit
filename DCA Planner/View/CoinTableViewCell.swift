//
//  PriceTableViewCell.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/15.
//

import UIKit

final class CoinTableViewCell: UITableViewCell {

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        //view.backgroundColor = Constant.UISetting.color2
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        return label
    }()

    let coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    // coinNameLabel + coinSymbolLabel + coinPriceLabel (Horizontal)
    let horizontalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
//        sv.distribution = .fill
//        sv.alignment = .fill
//        sv.spacing = 5
        return sv
    }()
    
    // TableViewCell 생성자 셋팅
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupSubview()
        setupHorizontalSV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // TableView 위에 하나식 올려놓기
    func setupSubview() {
        self.addSubview(containerView)
        self.addSubview(horizontalSV)
    }
    
    // coinNameLabel + coinSymbolLabel + coinPriceLabel (Horizontal)
    func setupHorizontalSV() {
        horizontalSV.addArrangedSubview(coinNameLabel)
        horizontalSV.addArrangedSubview(coinSymbolLabel)
        horizontalSV.addArrangedSubview(coinPriceLabel)
        horizontalSV.alignment = .firstBaseline
        horizontalSV.distribution = .fill
    }
    
    // AutoLayout 결정하는 시점
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    // AutoLayout 설정 (기준점이 되어야 하는 바깥쪽 요소부터)
    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        horizontalSV.translatesAutoresizingMaskIntoConstraints = false
        coinNameLabel.translatesAutoresizingMaskIntoConstraints = false
        coinSymbolLabel.translatesAutoresizingMaskIntoConstraints = false
        coinPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            horizontalSV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            horizontalSV.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            horizontalSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            horizontalSV.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            coinNameLabel.leadingAnchor.constraint(equalTo: horizontalSV.leadingAnchor, constant: 0),
            coinNameLabel.topAnchor.constraint(equalTo: horizontalSV.topAnchor, constant: 5),
            coinNameLabel.bottomAnchor.constraint(equalTo: horizontalSV.bottomAnchor, constant: -5),
            coinNameLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        NSLayoutConstraint.activate([
            coinSymbolLabel.leadingAnchor.constraint(equalTo: coinNameLabel.trailingAnchor, constant: 5),
            coinSymbolLabel.topAnchor.constraint(equalTo: horizontalSV.topAnchor, constant: 5),
            coinSymbolLabel.bottomAnchor.constraint(equalTo: horizontalSV.bottomAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            coinPriceLabel.trailingAnchor.constraint(equalTo: horizontalSV.trailingAnchor, constant: -0),
            coinPriceLabel.topAnchor.constraint(equalTo: horizontalSV.topAnchor, constant: 5),
            coinPriceLabel.bottomAnchor.constraint(equalTo: horizontalSV.bottomAnchor, constant: -5),
        ])
        
    }

}
