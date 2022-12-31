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
    
//    // 계산 영역 View
//    private let calcView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .green
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = false
//        view.layer.shadowRadius = 3
//        view.layer.shadowOpacity = 0.3
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        return view
//    }()
//
//    private let firstTypeView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
//        return view
//    }()
//
//    private let secondTypeView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .blue
//        return view
//    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["적립 매수","일괄 매수"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.tintColor = Constant.ColorSetting.themeColor
        control.addTarget(self, action: #selector(segmentedValueChanged(index:)), for: .valueChanged)
        return control
    }()
    
    // 투자 시작 날짜 (Label)
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "1. 투자 시작일 선택: "
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // 투자 시작 날짜 (TextField)
    lazy var startDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = startDatePicker
        
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        todayDateFormatter.locale = Locale(identifier: "ko_KR")
        tf.text = todayDateFormatter.string(from: Date())
        
        return tf
    }()
    
    // 투자 시작 날짜 (DatePicker)
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.minimumDate = Date(timeIntervalSince1970: 1262271600)  // 2010-01-01 00:00:00
        return picker
    }()
    
    // 투자 시작 날짜 (StackView)
    private lazy var startDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [startDateLabel, startDateTextField])
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
        label.text = "2. 투자 종료일 선택:"
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // 투자 종료 날짜 (TextField)
    lazy var endDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = endDatePicker
        
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        todayDateFormatter.locale = Locale(identifier: "ko_KR")
        tf.text = todayDateFormatter.string(from: Date())
        
        return tf
    }()
    
    // 투자 종료 날짜 (DatePicker)
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Date()  // current date
        return picker
    }()
    
    // 투자 종료 날짜 (StackView)
    private lazy var endDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [endDateLabel, endDateTextField])
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
    
    // ScrollView 내 모든 요소들에 대한 수직 StackView
    private lazy var firstFinalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [startDateStackView, endDateStackView, calcStartButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 15
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        return sv
    }()
    
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
    
    // View 생성자 셋팅 (1)
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSegmentedControl()
        setupScrollView()
        setupFinalStackView()
        setupActivityIndicator()
    }
        
    // View 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // SegmentedControl 셋팅
    private func setupSegmentedControl() {
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            segmentedControl.heightAnchor.constraint(equalToConstant: 25),
        ])

    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }

    private func setupFinalStackView() {
        scrollView.addSubview(firstFinalStackView)

        NSLayoutConstraint.activate([
            firstFinalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            firstFinalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            firstFinalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            firstFinalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            //finalStackView.heightAnchor.constraint(equalToConstant: 1000),
        ])

    }
    
    private func setupActivityIndicator() {
        self.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            indicatorContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicatorContainer.widthAnchor.constraint(equalToConstant: 80),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorContainer.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])

    }
    
    @objc private func segmentedValueChanged(index: UISegmentedControl) {
        //print(#function)
    }
    
    // 계산 버튼을 눌렀을 때
    @objc private func onClickButton(sender: UIButton) {
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
