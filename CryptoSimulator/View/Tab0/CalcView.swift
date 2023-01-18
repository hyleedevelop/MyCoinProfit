//
//  CalcTypeView.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/29.
//

import UIKit
import ShimmerSwift
import NVActivityIndicatorView

final class CalcView: UIView {
    
    //MARK: - 스위치 속성
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["한번에 매수하기","나눠서 매수하기"])
        let backgroundImage = UIImage()
        let deviderImage = UIImage()
        let font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: .medium)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
//        control.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
//        control.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
//        control.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
//        control.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = Constant.UIColorSetting.themeColor
        control.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    //MARK: - 코인 속성
    
    var coinTypeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let coinTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.textColor = .black
        label.text = Constant.TitleSetting.coinTypeLabelName
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var coinTypeTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = coinTypePicker
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.coinTypeTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        //tf.addTarget(self, action: #selector(beforeTextFieldEditing(_:)), for: .editingDidBegin)
        //tf.addTarget(self, action: #selector(afterTextFieldEditing(_:)), for: .editingDidEnd)
        return tf
    }()

    let coinTypePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let coinTypeBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var coinTypeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinTypeLabel, coinTypeTextField, coinTypeBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 7
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 시작 날짜 관련 속성
    
    var buyStartDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let buyStartDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyStartDateLabelName1
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var buyStartDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = buyStartDatePicker
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyStartDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.minimumDate = Constant.DateSetting.buyStartMinimumDate
        picker.maximumDate = Constant.DateSetting.buyStartMaximumDate
        return picker
    }()
    
    let buyStartDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var buyStartDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyStartDateLabel, buyStartDateTextField, buyStartDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    let buyEndDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let buyEndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyEndDateLabelName
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var buyEndDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = buyEndDatePicker
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.buyEndDateTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyEndDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.minimumDate = Constant.DateSetting.buyEndMinimumDate
        picker.maximumDate = Constant.DateSetting.buyEndMaximumDate
        return picker
    }()
    
    let buyEndDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var buyEndDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyEndDateLabel, buyEndDateTextField, buyEndDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 반복 주기 관련 속성
    
    let frequencyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.frequencyLabelName
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var frequencyTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = frequencyPicker
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.frequencyTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        return tf
    }()
    
    let frequencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let frequencyBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var frequencyStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [frequencyLabel, frequencyTextField, frequencyBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매 회차 매수금액 관련 속성
    
    let amountContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.amountLabelName1
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
        
    lazy var amountTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.keyboardType = .decimalPad
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        return tf
    }()

    let amountBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var amountStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [amountLabel, amountTextField, amountBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    let sellDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeInbox
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = 0
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let sellDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.sellDateLabelName
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var sellDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = sellDatePicker
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.sellDateTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: Constant.SizeSetting.textfieldFontWeight)
        return tf
    }()
    
    let sellDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.minimumDate = Constant.DateSetting.sellMinimumDate
        picker.maximumDate = Constant.DateSetting.sellMaximumDate
        return picker
    }()
    
    let sellDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        return view
    }()
    
    private lazy var sellDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sellDateLabel, sellDateTextField, sellDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 빈 공간 속성
    
    private let emptySpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 버튼 관련 속성

    let calcStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.TitleSetting.calcStartButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor(red: 165/255, green: 85/255, blue: 236/255, alpha: 1)
        button.layer.cornerRadius = 10
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let shimmerButton: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.isShimmering = true
        shimmer.shimmerSpeed = 150
        shimmer.shimmerPauseDuration = 4
        shimmer.shimmerHighlightLength = 0.8
        shimmer.shimmerAnimationOpacity = 0.7
        shimmer.shimmerDirection = .left
        return shimmer
    }()
    
    let calcResetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.TitleSetting.calcResetButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.lightModeInbox
        button.layer.cornerRadius = 10
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [shimmerButton, calcResetButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 20
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 기타 속성
    
    // 스크롤 뷰 (내용이 추가되거나 기기에 따라 세로 화면이 부족해질 수 있으므로 일반 뷰가 아닌 스크롤 뷰를 사용하였음)
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constant.UIColorSetting.lightModeBackground
        view.showsVerticalScrollIndicator = true
        view.scrollsToTop = true
        return view
    }()
    
    // 최종 수직 StackView
    // StackView의 하위뷰는 아래의 메서드에서 주어진 조건에 따라 다르게 넣을 예정
    private lazy var finalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    // 로딩 아이콘
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                                        type: .ballSpinFadeLoader,
                                                        color: .white,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.UIColorSetting.themeColor
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    //MARK: - 생성자
    
    // UIView 초기생성자
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupShimmerView()
        setupSegmentedControl()
        setupScrollView()
        setupContainerView()
        setupFinalStackView()
        setupActivityIndicator()
        
        
    }
        
    // UIView 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    // 반짝이는 효과를 나타내는 ShimmerView를 calcStartButton에 씌우기
    private func setupShimmerView() {
        self.addSubview(shimmerButton)
        shimmerButton.contentView = calcStartButton
    }
    
    private func setupSegmentedControl() {
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -60),
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }
    
    // 각 요소의 ContainerView와 StackView 설정
    private func setupContainerView() {
        let containerViewArray = [coinTypeContainerView, buyStartDateContainerView, buyEndDateContainerView, frequencyContainerView, amountContainerView, sellDateContainerView]
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView, frequencyStackView, amountStackView, sellDateStackView]
        
        for i in 0..<containerViewArray.count {
            self.addSubview(containerViewArray[i])
            containerViewArray[i].addSubview(stackViewArray[i])
            NSLayoutConstraint.activate([
                stackViewArray[i].leadingAnchor.constraint(equalTo: containerViewArray[i].leadingAnchor, constant: 15),
                stackViewArray[i].trailingAnchor.constraint(equalTo: containerViewArray[i].trailingAnchor, constant: -15),
                stackViewArray[i].topAnchor.constraint(equalTo: containerViewArray[i].topAnchor, constant: 15),
                stackViewArray[i].bottomAnchor.constraint(equalTo: containerViewArray[i].bottomAnchor, constant: -15),
            ])
        }
        
        _ = containerViewArray.map{ $0.heightAnchor.constraint(equalToConstant: 90).isActive = true }
    }
    
    // FinalStackView 설정
    private func setupFinalStackView() {
        _ = [coinTypeContainerView, buyStartDateContainerView, amountContainerView, sellDateContainerView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        _ = [buyEndDateContainerView, frequencyContainerView].map { $0.removeFromSuperview() }
        
        scrollView.addSubview(finalStackView)
        
        NSLayoutConstraint.activate([
            finalStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            finalStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -40),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
            buttonStackView.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
    }
    
    // 첫번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupFirstFinalStackView() {
        _ = [buyEndDateContainerView, frequencyContainerView].map { $0.removeFromSuperview() }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName1
        amountLabel.text = Constant.TitleSetting.amountLabelName1
        resetTextField()
    }
    
    // 두번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupSecondFianlStackView() {
        _ = [coinTypeContainerView, buyStartDateContainerView, buyEndDateContainerView, frequencyContainerView, amountContainerView, sellDateContainerView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, buyEndDateBottomLine, sellDateBottomLine, frequencyBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName2
        amountLabel.text = Constant.TitleSetting.amountLabelName2
        resetTextField()

    }
    
    // TextField 입력값 초기화
    private func resetTextField() {
        _ = [buyStartDateTextField, buyEndDateTextField, frequencyTextField, amountTextField, sellDateTextField].map{ $0.text = "" }
    }
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    // 로딩중임을 나타내는 Indicator 표시
    func presentLoadingIndicator() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            //calcStartButton.backgroundColor = Constant.UIColorSetting.themeColor
        }
        else {
            self.activityIndicator.startAnimating()
            //calcStartButton.backgroundColor = .red
        }
    }
    
    //MARK: - 액션
    
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:  // 한번에 매수하기 선택 시
            setupFirstFinalStackView()
        case 1:  // 나눠서 매수하기 선택 시
            setupSecondFianlStackView()
        default:
            break
        }
    }
    
//    // 텍스트필드 편집을 시작했을 때 실행할 내용
//    @objc private func beforeTextFieldEditing(_ textField: UITextField) {
//
//    }
//
//    // 텍스트필드 편집을 끝냈을 때 실행할 내용
//    @objc private func afterTextFieldEditing(_ textField: UITextField) {
//
//    }
//
//    // 텍스트필드 편집 도중 내용이 바뀔 때마다 실행할 내용
//    @objc private func whileTextFieldEditing() {
//
//    }
    
}
