//
//  CalcResultModalView.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/16.
//

import UIKit

final class CalcResultView: UIView {

//    private let navBarTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "계산 결과"
//        label.font = .systemFont(ofSize: 20, weight: .bold)
//        label.textColor = .label
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let modalViewLogoImage: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.image = UIImage(named: "calcResultModalView_main_image.svg")
//        iv.sizeToFit()
//        return iv
//    }()

    //MARK: - 결과를 요약한 문장
    
    // 결과를 요약해서 보여주는 Label
    var summaryLabel = [UILabel]()
    let numberOfLabels = 6

    // 그래프를 담고 있는 View
    let graphContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        //view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 그래프
    
    // 그래프의 바닥 기준선
    private let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    // 원금 막대
    let leftBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.borderColor = Constant.CGColorSetting.black
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        return view
    }()
    
    // 원금 숫자 텍스트
    let leftBarValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 평가금 막대
    let rightBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.borderColor = Constant.CGColorSetting.black
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        return view
    }()

    // 평가금 숫자 텍스트
    let rightBarValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 화살표 그림
    let centerArrow: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.image = UIImage(named: "UpCurvedArrow.png")
        iv.image = UIImage(systemName: "arrow.right")
        iv.tintColor = .black
        iv.sizeToFit()
        return iv
    }()
    
    // 수익금/수익률 텍스트
    let centerArrowValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // 원금 텍스트
    private let leftTickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = "원금"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 평가금 텍스트
    private let rightTickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = "평가금"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    
    //MARK: - 버튼
    
    lazy var resultSaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constant.UIColorSetting.themeColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcSaveButtonName, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        //button.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var resultShareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constant.UIColorSetting.lightModeBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcShareButtonName, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        //button.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [resultSaveButton, resultShareButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 15
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()

    //MARK: - 생성자
    
    // UIView 초기생성자
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSummaryLabel()
        setupGraph()
        setupButton()
    }
        
    // UIView 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    private func setupSummaryLabel() {
        for i in 0..<numberOfLabels {
            summaryLabel.append(UILabel())
            summaryLabel[i].translatesAutoresizingMaskIntoConstraints = false
            summaryLabel[i].font = .systemFont(ofSize: Constant.SizeSetting.summaryLabelSmallFontSize,
                                               weight: Constant.SizeSetting.summaryLabelSmallFontWeight)
            summaryLabel[i].textColor = .label
            summaryLabel[i].numberOfLines = 0
            summaryLabel[i].lineBreakMode = .byWordWrapping
            summaryLabel[i].textAlignment = .center
            summaryLabel[i].addCharacterSpacing()
            
            self.addSubview(summaryLabel[i])
            
            summaryLabel[i].centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
            summaryLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            if i == 0 {
                summaryLabel[i].topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            } else {
                summaryLabel[i].topAnchor.constraint(equalTo: summaryLabel[i-1].bottomAnchor, constant: 3).isActive = true
            }
        }
        
    }
    
    private func setupGraph() {
        _ = [graphContainerView, bottomLine, leftBar, rightBar, leftBarValueLabel, leftTickLabel, rightBarValueLabel, rightTickLabel, centerArrow, centerArrowValueLabel ].map{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            graphContainerView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            graphContainerView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -90),
            graphContainerView.topAnchor.constraint(equalTo: summaryLabel[numberOfLabels-1].bottomAnchor, constant: 30),
            graphContainerView.heightAnchor.constraint(equalToConstant: 200),

            bottomLine.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 20),
            bottomLine.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: -20),
            bottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.graphLineWidthAnchorConstant + 0.2),
            bottomLine.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -30),
            
            //leftBar.heightAnchor.constraint(equalToConstant: 50),
            leftBar.bottomAnchor.constraint(equalTo: bottomLine.topAnchor),
            leftBar.widthAnchor.constraint(equalToConstant: 25),
            leftBar.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor, constant: -90),
            
            //rightBar.heightAnchor.constraint(equalToConstant: 225),
            rightBar.bottomAnchor.constraint(equalTo: bottomLine.topAnchor),
            rightBar.widthAnchor.constraint(equalToConstant: 25),
            rightBar.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor, constant: 90),
            
            leftBarValueLabel.centerXAnchor.constraint(equalTo: leftBar.centerXAnchor),
            leftBarValueLabel.bottomAnchor.constraint(equalTo: leftBar.topAnchor, constant: -5),
            
            leftTickLabel.centerXAnchor.constraint(equalTo: leftBar.centerXAnchor),
            leftTickLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 5),
            
            rightBarValueLabel.centerXAnchor.constraint(equalTo: rightBar.centerXAnchor),
            rightBarValueLabel.bottomAnchor.constraint(equalTo: rightBar.topAnchor, constant: -5),
            
            rightTickLabel.centerXAnchor.constraint(equalTo: rightBar.centerXAnchor),
            rightTickLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 5),
            
            centerArrow.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor),
            centerArrow.centerYAnchor.constraint(equalTo: graphContainerView.centerYAnchor, constant: 10),
            centerArrow.widthAnchor.constraint(equalToConstant: 40),
            centerArrow.heightAnchor.constraint(equalToConstant: 20),
            
            centerArrowValueLabel.centerXAnchor.constraint(equalTo: centerArrow.centerXAnchor),
            centerArrowValueLabel.bottomAnchor.constraint(equalTo: centerArrow.topAnchor, constant: -2),
            
        ])
    }
    
    private func setupButton() {
        self.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}
