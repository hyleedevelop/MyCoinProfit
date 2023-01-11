//
//  CalcTypeView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit
import ShimmerSwift

final class CalcView: UIView {
    
    //MARK: - 스위치 속성
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["한번에 매수하기","나눠서 매수하기"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: Constant.SizeSetting.textfieldFontSize, weight: .medium)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = Constant.UIColorSetting.themeColor
        control.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    //MARK: - 코인 속성
    
    let coinTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.coinTypeLabelName
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let coinTypeCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var coinTypeHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinTypeLabel, coinTypeCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var coinTypeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinTypeHorizontalStackView, coinTypeTextField, coinTypeBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 7
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 시작 날짜 관련 속성
    
    let buyStartDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyStartDateLabelName1
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let buyStartDateCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var buyStartDateHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyStartDateLabel, buyStartDateCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var buyStartDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyStartDateHorizontalStackView, buyStartDateTextField, buyStartDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    let buyEndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyEndDateLabelName
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let buyEndDateCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var buyEndDateHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyEndDateLabel, buyEndDateCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var buyEndDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyEndDateHorizontalStackView, buyEndDateTextField, buyEndDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    let sellDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.sellDateLabelName
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let sellDateCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var sellDateHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sellDateLabel, sellDateCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var sellDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sellDateHorizontalStackView, sellDateTextField, sellDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 반복 주기 관련 속성
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.frequencyLabelName
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let frequencyCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var frequencyHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [frequencyLabel, frequencyCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var frequencyStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [frequencyHorizontalStackView, frequencyTextField, frequencyBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매 회차 매수금액 관련 속성
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.amountLabelName1
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let amountCheckMark: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constant.ImageSetting.checkMarkNo
        imageView.tintColor = .clear
        return imageView
    }()
    
    private lazy var amountHorizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [amountLabel, amountCheckMark])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 3
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        return sv
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
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var amountStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [amountHorizontalStackView, amountTextField, amountBottomLine])
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
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcStartButtonName, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.themeColor
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let shimmerButton: ShimmeringView = {
        let shimmer = ShimmeringView()
        shimmer.isShimmering = true
        shimmer.shimmerSpeed = 150
        shimmer.shimmerPauseDuration = 5
        shimmer.shimmerHighlightLength = 0.8
        shimmer.shimmerAnimationOpacity = 0.7
        shimmer.shimmerDirection = .left
        return shimmer
    }()
    
    let calcResetButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcResetButtonName, for: .normal)
        button.setTitleColor(.label, for: .normal)
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [shimmerButton, calcResetButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 35
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 기타 속성
    
    // 스크롤 뷰 (추후 내용이 추가되어 화면이 세로로 길어질 것을 대비하여 뷰가 아닌 스크롤 뷰로 선언하였음)
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
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
        sv.spacing = 30
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // 로딩 아이콘
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.UIColorSetting.themeColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
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
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }
    
    // 최종 StackView 초기 설정
    private func setupFinalStackView() {
        _ = [coinTypeStackView, buyStartDateStackView, amountStackView, sellDateStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(finalStackView)
        
        NSLayoutConstraint.activate([
            finalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 40),
            finalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -40),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -40),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Constant.SizeSetting.bottomLineWidthAnchorConstant).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
    }
    
    private func setupFirstFinalStackView() {
        _ = [buyEndDateStackView, frequencyStackView].map { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Constant.SizeSetting.bottomLineWidthAnchorConstant).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName1
        amountLabel.text = Constant.TitleSetting.amountLabelName1
        resetTextField()
    }
    
    private func setupSecondFianlStackView() {
        _ = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView, frequencyStackView, amountStackView, sellDateStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, buyEndDateBottomLine, sellDateBottomLine, frequencyBottomLine, amountBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: Constant.SizeSetting.bottomLineWidthAnchorConstant).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, buyEndDateBottomLine, sellDateBottomLine, frequencyBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineHeightAnchorConstant).isActive = true }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName2
        amountLabel.text = Constant.TitleSetting.amountLabelName2
        resetTextField()

    }
    
    private func resetTextField() {
        frequencyTextField.text = ""
        amountTextField.text = ""
    }
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        self.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
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
        // 일괄매수를 선택한 경우
        if sender.selectedSegmentIndex == 0 {
            setupFirstFinalStackView()
        }
        
        // 분할매수를 선택한 경우
        if sender.selectedSegmentIndex == 1 {
            setupSecondFianlStackView()
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
