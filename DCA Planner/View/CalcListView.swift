//
//  CalcListView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/14.
//

import UIKit

final class CalcListView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.ColorSetting.themeColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private let indicatorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var calcStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.blue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.setTitle("계산하기", for: .normal)
        button.addTarget(self, action: #selector(onClickButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    // 매수 시작 날짜에 대한 Label
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "매수 시작: "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // 투자 시작 날짜를 입력하는 TextField
    private let startDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.frame.size.height = 20
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        return tf
    }()
    
    // 투자 시작 날짜에 대한 horizontal StackView
    private lazy var startDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [startDateLabel, startDateTextField])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    // 레이블
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "매수 시작일: "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // View 생성자 셋팅 (1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
        self.addSubview(calcStartButton)
        self.addSubview(startDateStackView)
    }
        
    // View 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // AutoLayout 결정하는 시점
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    // AutoLayout 설정
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            startDateStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startDateStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startDateStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            startDateLabel.leadingAnchor.constraint(equalTo: startDateStackView.leadingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            calcStartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            calcStartButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            calcStartButton.widthAnchor.constraint(equalToConstant: 120),
            calcStartButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            indicatorContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicatorContainer.widthAnchor.constraint(equalToConstant: 80),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
        

        
    }
    
    // VC에서 처리한 결과값을 텍스트나 이미지의 값으로 넣기

    
    // 계산 버튼을 눌렀을 때
    @objc private func onClickButton(sender: UIButton){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            calcStartButton.backgroundColor = UIColor.blue
            calcStartButton.setTitle("계산하기", for: .normal)
            indicatorContainer.backgroundColor = .clear
        }
        else {
            self.activityIndicator.startAnimating()
            calcStartButton.backgroundColor = UIColor.red
            calcStartButton.setTitle("중단", for: .normal)
            //indicatorContainer.backgroundColor = Constant.ColorSetting.themeColor
            //indicatorContainer.alpha = 0.3
            //indicatorContainer.backgroundColor?.withAlphaComponent(0.3)
            //activityIndicator.alpha = 1.0
        }
    }
    
}
