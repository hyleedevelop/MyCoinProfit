//
//  CalcTypeView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcView: UIView {

    // 수직 ScrollView
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = true
        view.scrollsToTop = true
        return view
    }()
    
    // ScrollView에서 컨텐츠를 담을 View
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
//    // 각 View의 제목
//    private let calcLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.text = "1. 투자 유형 선택"
//        label.textColor = .black
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        return label
//    }()
    
//    // 계산 영역 View
//    private let calcView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = false
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowOffset = CGSize(width: 0, height: 3)
//        return view
//    }()
    
    // 집중식 투자 (Button)
    private lazy var calcTypeButton1: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("집중식 투자", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constant.ColorSetting.color1
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 1
        //button.addTarget(self, action: #selector(sortPriceChangeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var calcTypeButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("적립식 투자", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constant.ColorSetting.color2
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.tag = 1
        //button.addTarget(self, action: #selector(sortPriceChangeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 투자 시작 날짜 (StackView)
    private lazy var calcTypeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [calcTypeButton1, calcTypeButton2])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 10
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    // 투자 시작 날짜 (Label)
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "투자 시작 날짜: "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // 투자 시작 날짜 (TextField)
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
        tf.inputView = UIPickerView()
        return tf
    }()
    
    // 투자 시작 날짜 (DatePicker)
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.contentHorizontalAlignment = .leading
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .automatic
        picker.minimumDate = Date(timeIntervalSince1970: 1262271600)
        return picker
    }()
    
    // 투자 시작 날짜 (StackView)
    private lazy var startDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [startDateLabel, startDatePicker])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 10
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    // 투자 종료 날짜 (Label)
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "투자 종료 날짜: "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
  
    // 투자 시작 날짜 (DatePicker)
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.contentHorizontalAlignment = .leading
        picker.datePickerMode = .date
        return picker
    }()
    
//    // 투자 종료 날짜 (TextField)
//    private let endDateTextField: UITextField = {
//        let tf = UITextField()
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.frame.size.height = 20
//        tf.textColor = .black
//        tf.borderStyle = .roundedRect
//        tf.autocapitalizationType = .none
//        tf.autocorrectionType = .no
//        tf.spellCheckingType = .no
//        tf.clearsOnBeginEditing = false
//        tf.inputView = UIPickerView()
//        return tf
//    }()
    
    // 투자 종료 날짜 (StackView)
    private lazy var endDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [endDateLabel, endDatePicker])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 5
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    // 매 회 투자금액(USD)
    
    // 투자 반복 주기(1회 / 일, 주, 월, 연)
    
    //
    
    // 로딩 아이콘 (ActivityIndicatorView)
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.ColorSetting.themeColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // 로딩 아이콘 (View)
    private let indicatorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // 계산 시작 (Button)
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
    
    // calcLabel
    private lazy var finalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [calcTypeStackView, startDateStackView, endDateStackView, calcStartButton, indicatorContainer])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    // View 생성자 셋팅 (1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //setupConstraints()
        
        setupScrollView()
        setupContentView()
        setupFinalStackView()
        
        self.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            indicatorContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicatorContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indicatorContainer.widthAnchor.constraint(equalToConstant: 80),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
        
    // View 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -0),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 100),
        ])
    }
    
    private func setupFinalStackView() {
        contentView.addSubview(finalStackView)
//        contentView.addSubview(selectionView2)

        NSLayoutConstraint.activate([
            finalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            finalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            finalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            //finalStackView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
//        NSLayoutConstraint.activate([
//            selectionView2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            selectionView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            selectionView2.topAnchor.constraint(equalTo: calcView.bottomAnchor, constant: 20),
//            selectionView2.heightAnchor.constraint(equalToConstant: 200),
//        ])
        

        
    }

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
