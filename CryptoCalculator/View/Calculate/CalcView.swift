//
//  CalcTypeView.swift
//  CryptoSimulator
//
//  Created by Eric on 2022/12/29.
//

import UIKit
import NVActivityIndicatorView

final class CalcView: UIView {
    
    //MARK: - 커스텀 메뉴바
    
    // 투자방법 선택
    let segmentedControl: CustomSegmentedControl = {
        // status bar의 높이 구하기
        // (windows was deprecated in iOS 15.0에 대응)
        var topSafeAreaHeight: CGFloat {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        // segmented control의 꼭대기를 status bar의 바닥에서 30만큼 아래에 배치
        let control = CustomSegmentedControl(
            frame: CGRect(x: 0, y: topSafeAreaHeight + 30,
                          width: UIScreen.main.bounds.width, height: 80))
        control.setButtonTitles(buttonTitles: [Constant.TitleSetting.segmentItemName1,
                                               Constant.TitleSetting.segmentItemName2])
        control.setIndex(index: 0)
        return control
    }()
    
    //MARK: - 코인 속성
    
    lazy var coinTypeContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemBackground
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(coinTypeTextField)
        return view
    }()
    
    let coinTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.clearButtonMode = .whileEditing
        tf.inputView = UIView()
        tf.inputAccessoryView = UIView()
        tf.placeholder = Constant.TitleSetting.coinTypeTextFieldPlaceHolder
        tf.textColor = .label
        tf.tintColor = .clear
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
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
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(buyStartDateTextField)
        return view
    }()
    
    let buyStartDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyStartDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Constant.DateSetting.standardLocale
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
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(buyEndDateTextField)
        return view
    }()
    
    let buyEndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let buyEndDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Constant.DateSetting.standardLocale
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
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(frequencyTextField)
        return view
    }()
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
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
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(amountTextField)
        return view
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
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
        view.layer.masksToBounds = false
        view.layer.cornerRadius = Constant.ShapeSetting.containerCornerRadius
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.addSubview(sellDateTextField)
        return view
    }()
    
    let sellDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.labelFontSize,
                                       weight: Constant.ShapeSetting.labelFontWeight)
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
        tf.font = UIFont.systemFont(ofSize: Constant.ShapeSetting.textfieldFontSize,
                                    weight: Constant.ShapeSetting.textfieldFontWeight)
        return tf
    }()
    
    let sellDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Constant.DateSetting.standardLocale
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.lightModeInbox
        button.layer.cornerRadius = Constant.ShapeSetting.buttonCornerRadius
        button.clipsToBounds = true
        return button
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

        setupActivityIndicator()
    }
        
    // UIView 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    private func setupSegmentedControl() {
        segmentedControl.delegate = self
        self.addSubview(segmentedControl)
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
        let containerViewArray = [coinTypeContainerView, buyStartDateContainerView,
                                  buyEndDateContainerView, frequencyContainerView,
                                  amountContainerView, sellDateContainerView]
        let textFieldArray = [coinTypeTextField, buyStartDateTextField, buyEndDateTextField,
                              frequencyTextField, amountTextField, sellDateTextField]
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView,
                              frequencyStackView, amountStackView, sellDateStackView]
        
        stackViewArray.forEach { $0.heightAnchor.constraint(equalToConstant: 80).isActive = true }
        containerViewArray.forEach { $0.heightAnchor.constraint(equalToConstant: 45).isActive = true }

        for i in 0..<containerViewArray.count {
            NSLayoutConstraint.activate([
                containerViewArray[i].leadingAnchor.constraint(
                    equalTo: stackViewArray[i].leadingAnchor),
                containerViewArray[i].trailingAnchor.constraint(
                    equalTo: stackViewArray[i].trailingAnchor),
                
                textFieldArray[i].leadingAnchor.constraint(
                    equalTo: containerViewArray[i].leadingAnchor, constant: 10),
                textFieldArray[i].trailingAnchor.constraint(
                    equalTo: containerViewArray[i].trailingAnchor, constant: -10),
                textFieldArray[i].topAnchor.constraint(
                    equalTo: containerViewArray[i].topAnchor),
                textFieldArray[i].bottomAnchor.constraint(
                    equalTo: containerViewArray[i].bottomAnchor),
            ])
        }
    }
    
    // FinalStackView(inputStackView + emptySpace + calcStartButton) 설정
    private func setupFinalStackView() {
        scrollView.addSubview(finalStackView)
        
        let stackViewArray = [coinTypeStackView, buyStartDateStackView, sellDateStackView, amountStackView,
                              emptySpace, calcStartButton]
        let willHideArray = [buyEndDateStackView, frequencyStackView]
        
        stackViewArray.forEach { finalStackView.addArrangedSubview($0) }
        willHideArray.forEach { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            finalStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            finalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -60),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            calcStartButton.heightAnchor.constraint(equalToConstant: Constant.ShapeSetting.buttonHeight),
        ])
        
        // 애니메이션을 위해 투명도를 0으로 초기화
        [coinTypeLabel, coinTypeContainerView,
         buyStartDateLabel, buyStartDateContainerView,
         sellDateLabel, sellDateContainerView,
         amountLabel, amountContainerView,
         calcStartButton].forEach { $0.alpha = 0 }
    }
    
    // 첫번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupFirstFinalStackView() {
        [coinTypeStackView, buyStartDateStackView, sellDateStackView,
         amountStackView, emptySpace, calcStartButton]
            .forEach { finalStackView.addArrangedSubview($0) }
        [buyEndDateStackView, frequencyStackView]
            .forEach { $0.removeFromSuperview() }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName1
        buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder1
        amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder1
        amountLabel.text = Constant.TitleSetting.amountLabelName1
        resetTextField()
    }
    
    // 두번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupSecondFianlStackView() {
        [coinTypeStackView, buyStartDateStackView, buyEndDateStackView,
         sellDateStackView, frequencyStackView, amountStackView, emptySpace, calcStartButton]
            .forEach { finalStackView.addArrangedSubview($0) }
        
        buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName2
        buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder2
        amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder2
        amountLabel.text = Constant.TitleSetting.amountLabelName2
        resetTextField()
    }
    
    // TextField 입력값 초기화
    private func resetTextField() {
        [buyStartDateTextField, buyEndDateTextField, frequencyTextField, amountTextField, sellDateTextField]
            .forEach { $0.text = "" }
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
    
    func updateButtonColor(index: Int) {
        DispatchQueue.main.async {
            self.calcStartButton.setButtonBackgroundGradient(
                color1: Constant.UIColorSetting.themeGradientStartColors[index],
                color2: Constant.UIColorSetting.themeGradientMiddleColors[index],
                color3: Constant.UIColorSetting.themeGradientEndColors[index])
        }
        layoutIfNeeded()
    }

}

//MARK: - Custom Segmented Control

extension CalcView: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        if index == 0 {
            setupFirstFinalStackView()
            endEditing(true)
        }
        if index == 1 {
            setupSecondFianlStackView()
            endEditing(true)
        }
    }
    
}
