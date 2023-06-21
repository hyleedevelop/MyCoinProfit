//
//  PriceTableViewCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/15.
//

import UIKit
import Kingfisher

final class CoinListCell: UITableViewCell {
    
    //MARK: - 속성
    
    // 순번
    private let coinRank: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 코인 이미지
    private let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.backgroundColor = UIColor(named: "IconColor")
        return imageView
    }()
    
    // 코인 심볼
    private let coinSymbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    // 코인 이름
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
        
    // Vertical SV (코인 이름 + 코인 심볼)
    private lazy var nameLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinSymbolLabel, coinNameLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()
    
    // 코인 가격
    private let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    // 코인 가격 24시간 변화율
    private let coinPriceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    // Vertical SV (코인 가격 + 코인 가격 변화율)
    private lazy var priceLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinPriceLabel, coinPriceChangeLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 7
        return sv
    }()
    
    // Horizontal SV (코인 이미지 + Vertical SV + Vertical SV)
    private lazy var cellSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinRank, coinImageView, nameLabelSV, priceLabelSV])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 15
        return sv
    }()
    
    //MARK: - 생성자
    
    // TableViewCell 생성자 셋팅 (1)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        registerUI()
        updateConstraints()
    }
    
    // TableViewCell 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // 하위 뷰로 등록
    private func registerUI() {
        contentView.addSubview(cellSV)
        self.backgroundColor = UIColor(named: "BGColor")
    }
    
    // AutoLayout 결정하는 시점
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    // AutoLayout 설정
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            coinRank.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            coinRank.widthAnchor.constraint(equalToConstant: 30),
            coinRank.heightAnchor.constraint(equalToConstant: 40),
        
            coinImageView.heightAnchor.constraint(equalToConstant: 40),
            coinImageView.widthAnchor.constraint(equalToConstant: 40),
            //coinImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            coinImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        
            nameLabelSV.heightAnchor.constraint(equalToConstant: 40),
        
            priceLabelSV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -18),
            priceLabelSV.heightAnchor.constraint(equalToConstant: 40),
        
            cellSV.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    
    // VC에서 처리한 결과값을 텍스트나 이미지의 값으로 넣기
    func configure(with coin: CurrentPriceData, arrayIndex index: Int, currency isUSD: Bool) {
        // 코인 랭크 넣기
        coinRank.text = String(index + 1)
        
        // 코인 이미지 넣기 (KingFisher 사용)
        let imageURL = URL(string: coin.image)
        coinImageView.kf.setImage(with: imageURL)
        coinImageView.kf.indicatorType = .activity
        
        // 코인 이름 넣기
        coinNameLabel.text = coin.name
        
        // 코인 심볼 넣기 (대문자로)
        coinSymbolLabel.text = coin.symbol.uppercased()
        
        // 코인 가격 넣기
        coinPriceLabel.text = coin.currentPrice.toUSD()
        
        // 코인 가격 24시간 변화율 넣기
        coinPriceChangeLabel.text = (coin.priceChangePercentage24H/100.0).toPercentage()
        coinPriceChangeLabel.textColor = coin.priceChangePercentage24H >= 0
                                       ? Constant.UIColorSetting.positiveColor
                                       : Constant.UIColorSetting.negativeColor
    }
    
}
