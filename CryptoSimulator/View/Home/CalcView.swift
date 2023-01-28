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
    
    // 투자방법 메뉴
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [Constant.TitleSetting.segmentItemName1,
                                                 Constant.TitleSetting.segmentItemName2])
        let font = UIFont.systemFont(ofSize: Constant.ShapeSetting.segmentFontSize,
                                     weight: Constant.ShapeSetting.segmentFontWeight)
        let image = UIImage()
        let size = CGSize(width: 1, height: control.intrinsicContentSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.label], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemGray2], for: .normal)
        control.selectedSegmentIndex = 0
        control.setBackgroundImage(scaledImage, for: .normal, barMetrics: .default)
        control.setBackgroundImage(scaledImage, for: .selected, barMetrics: .default)
        control.setBackgroundImage(scaledImage, for: .highlighted, barMetrics: .default)
        control.setDividerImage(scaledImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        control.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    // 투자방법 메뉴가 선택되었을 때 메뉴 아래에 나타나는 선을 꾸미기 위한 View
    // Autolayout이 아닌 Frame을 이용하므로 layoutSubViews에서 호출해줘야함
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(segmentedControl.numberOfSegments)// - 10
        let height = 2.0
        let xPosition = CGFloat(segmentedControl.selectedSegmentIndex * Int(width))
        let yPosition = segmentedControl.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        //view.layer.cornerRadius = 0
        //view.layer.masksToBounds = true

        return view
    }()
    
    //MARK: - 코인 속성
    
    lazy var coinTypeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(coinTypeTextField)
        return view
    }()
    
    let coinTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.textColor = .label
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
        //tf.inputView = coinTypePicker
        tf.inputView = UIView()
        tf.inputAccessoryView = UIView()
        tf.clearButtonMode = .whileEditing
        tf.placeholder = Constant.TitleSetting.coinTypeTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()

    let coinTypePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var coinTypeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinTypeLabel, coinTypeContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 시작 날짜 관련 속성
    
    lazy var buyStartDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(buyStartDateTextField)
        return view
    }()
    
    let buyStartDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyStartDateLabelName1
        label.textColor = .label
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
        tf.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder1
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyStartDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: Locale.current.identifier)
        picker.minimumDate = Constant.DateSetting.buyStartMinimumDate
        picker.maximumDate = Constant.DateSetting.buyStartMaximumDate
        return picker
    }()
    
    private lazy var buyStartDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyStartDateLabel, buyStartDateContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    lazy var buyEndDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(buyEndDateTextField)
        return view
    }()
    
    let buyEndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.buyEndDateLabelName
        label.textColor = .label
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyEndDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: Locale.current.identifier)
        picker.minimumDate = Constant.DateSetting.buyEndMinimumDate
        picker.maximumDate = Constant.DateSetting.buyEndMaximumDate
        return picker
    }()
    
    private lazy var buyEndDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [buyEndDateLabel, buyEndDateContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 반복 주기 관련 속성
    
    lazy var frequencyContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(frequencyTextField)
        return view
    }()
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.frequencyLabelName
        label.textColor = .label
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let frequencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var frequencyStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [frequencyLabel, frequencyContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매 회차 매수금액 관련 속성
    
    lazy var amountContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(amountTextField)
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.amountLabelName1
        label.textColor = .label
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
        tf.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder1
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    private lazy var amountStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [amountLabel, amountContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    lazy var sellDateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.addSubview(sellDateTextField)
        return view
    }()
    
    let sellDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize, weight: Constant.ShapeSetting.labelFontWeight)
        label.text = Constant.TitleSetting.sellDateLabelName
        label.textColor = .label
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize, weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let sellDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: Locale.current.identifier)
        picker.minimumDate = Constant.DateSetting.sellMinimumDate
        picker.maximumDate = Constant.DateSetting.sellMaximumDate
        return picker
    }()
        
    private lazy var sellDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sellDateLabel, sellDateContainerView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - spacing을 위한 빈 공간 속성
    
    private let emptySpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BGColor")
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 버튼 관련 속성

    let calcStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constant.TitleSetting.calcStartButtonName, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.lightModeInbox
        button.layer.cornerRadius = Constant.ShapeSetting.buttonCornerRadius
        button.clipsToBounds = true
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
    
    //MARK: - 기타 속성
    
    // 스크롤 뷰 (내용이 추가되거나 기기에 따라 세로 화면이 부족해질 수 있으므로 일반 뷰가 아닌 스크롤 뷰를 사용하였음)
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BGColor")
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
                                                        type: .audioEqualizer,
                                                        color: .white,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.label
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    //MARK: - 생성자
    
    // UIView 초기생성자
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupSegmentedControl()
        setupScrollView()
        setupInputStackView()
        setupFinalStackView()
        //setupButton()
        setupActivityIndicator()
    }
        
    // UIView 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        segmentedControl.addSubview(underlineView)
        
        let underlineFinalXPosition = (segmentedControl.bounds.width /
                                       CGFloat(segmentedControl.numberOfSegments)) *
                                       CGFloat(segmentedControl.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    private func setupSegmentedControl() {
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: -5),
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 5),
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
        ])
    }
    
    // 각 요소별 StackView 설정
    private func setupInputStackView() {
//        let labelArray = [coinTypeLabel, buyStartDateLabel, buyEndDateLabel,
//                          frequencyLabel, amountLabel, sellDateLabel]
        let containerViewArray = [coinTypeContainerView, buyStartDateContainerView, buyEndDateContainerView,
                                  frequencyContainerView, amountContainerView, sellDateContainerView]
        let textFieldArray = [coinTypeTextField, buyStartDateTextField, buyEndDateTextField,
                              frequencyTextField, amountTextField, sellDateTextField]
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView,
                              frequencyStackView, amountStackView, sellDateStackView]
        
        _ = stackViewArray.map { $0.heightAnchor.constraint(equalToConstant: 80).isActive = true }
        _ = containerViewArray.map { $0.heightAnchor.constraint(equalToConstant: 45).isActive = true }

        for i in 0..<containerViewArray.count {
            NSLayoutConstraint.activate([
                containerViewArray[i].leadingAnchor.constraint(equalTo: stackViewArray[i].leadingAnchor),
                containerViewArray[i].trailingAnchor.constraint(equalTo: stackViewArray[i].trailingAnchor),

                //labelArray[i].leadingAnchor.constraint(equalTo: stackViewArray[i].leadingAnchor, constant: 10),
                //labelArray[i].trailingAnchor.constraint(equalTo: stackViewArray[i].trailingAnchor, constant: -0),
                
                textFieldArray[i].leadingAnchor.constraint(equalTo: containerViewArray[i].leadingAnchor, constant: 10),
                textFieldArray[i].trailingAnchor.constraint(equalTo: containerViewArray[i].trailingAnchor, constant: -10),
                textFieldArray[i].topAnchor.constraint(equalTo: containerViewArray[i].topAnchor),
                textFieldArray[i].bottomAnchor.constraint(equalTo: containerViewArray[i].bottomAnchor),
            ])
        }
    }
    
    // FinalStackView(inputStackView + emptySpace + calcStartButton) 설정
    private func setupFinalStackView() {
        scrollView.addSubview(finalStackView)
        
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, sellDateStackView, amountStackView,
                              emptySpace, calcStartButton]
        let willHideArray = [buyEndDateStackView, frequencyStackView]
        
        _ = stackViewArray.map { finalStackView.addArrangedSubview($0) }
        _ = willHideArray.map { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            finalStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            finalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -40),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            calcStartButton.heightAnchor.constraint(equalToConstant: Constant.ShapeSetting.buttonHeight),
        ])
    }
    
    // 반짝이는 효과를 나타내는 ShimmerView를 calcStartButton에 씌우기
    private func setupButton() {
        //self.addSubview(shimmerButton)
        //shimmerButton.contentView = calcStartButton
        //self.addSubview(calcStartButton)
    }
    
    // 첫번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupFirstFinalStackView() {
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, sellDateStackView, amountStackView,
                              emptySpace, calcStartButton]
        let willHideArray = [buyEndDateStackView, frequencyStackView]
        
        _ = stackViewArray.map { finalStackView.addArrangedSubview($0) }
        _ = willHideArray.map { $0.removeFromSuperview() }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName1
        buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder1
        amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder1
        amountLabel.text = Constant.TitleSetting.amountLabelName1
        resetTextField()
    }
    
    // 두번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupSecondFianlStackView() {
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView,
                              sellDateStackView, frequencyStackView, amountStackView,
                              emptySpace, calcStartButton]
        
        _ = stackViewArray.map { finalStackView.addArrangedSubview($0) }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName2
        buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder2
        amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder2
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
        } else {
            self.activityIndicator.startAnimating()
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
    
}
