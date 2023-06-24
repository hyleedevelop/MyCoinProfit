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
    
    //MARK: - 코인 정보
    
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
    
    //MARK: - 매수 시작 날짜
    
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
    
    //MARK: - 매수 종료 날짜
    
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
    
    //MARK: - 매수 반복 주기
    
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
    
    //MARK: - 매 회차 매수금액
    
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
    
    //MARK: - 매수 종료 날짜
    
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
    
    //MARK: - spacing을 위한 빈 공간
    
    private let emptySpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "BGColor")
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 제출 버튼

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
    
    //MARK: - 기타
    
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
        let activityIndicator = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 40, height: 40),
            type: .ballPulse,
            color: .white,
            padding: .zero
        )
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.label
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    //MARK: - 생성자
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupSegmentedControl()
        self.setupScrollView()
        self.setupInputStackView()
        self.setupFinalStackView()

        self.setupActivityIndicator()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    private func setupSegmentedControl() {
        self.segmentedControl.delegate = self
        self.addSubview(segmentedControl)
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.segmentedControl.bottomAnchor, constant: 0),
            self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
            self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
        ])
    }
    
    // 각 요소별 StackView 설정
    private func setupInputStackView() {
        let containerViewArray = [
            self.coinTypeContainerView, self.buyStartDateContainerView,
            self.buyEndDateContainerView, self.frequencyContainerView,
            self.amountContainerView, self.sellDateContainerView
        ]
        let textFieldArray = [
            self.coinTypeTextField, self.buyStartDateTextField, self.buyEndDateTextField,
            self.frequencyTextField, self.amountTextField, self.sellDateTextField
        ]
        let stackViewArray = [
            self.coinTypeStackView, self.buyStartDateStackView, self.buyEndDateStackView,
            self.frequencyStackView, self.amountStackView, self.sellDateStackView
        ]
        
        stackViewArray.forEach {
            $0.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        containerViewArray.forEach {
            $0.heightAnchor.constraint(equalToConstant: 45).isActive = true
        }

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
        self.scrollView.addSubview(self.finalStackView)
        
        let stackViewArray = [
            self.coinTypeStackView, self.buyStartDateStackView, self.sellDateStackView,
            self.amountStackView, self.emptySpace, self.calcStartButton
        ]
        let willHideArray = [self.buyEndDateStackView, self.frequencyStackView]
        
        stackViewArray.forEach { self.finalStackView.addArrangedSubview($0) }
        willHideArray.forEach { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            self.finalStackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.finalStackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -40),
            self.finalStackView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor, constant: 5),
            self.finalStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: -60),
            
            self.emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            self.calcStartButton.heightAnchor.constraint(equalToConstant: Constant.ShapeSetting.buttonHeight),
        ])
        
        // 애니메이션을 위해 투명도를 0으로 초기화
        [self.coinTypeLabel, self.coinTypeContainerView,
         self.buyStartDateLabel, self.buyStartDateContainerView,
         self.sellDateLabel, self.sellDateContainerView,
         self.amountLabel, self.amountContainerView,
         self.calcStartButton].forEach { $0.alpha = 0 }
    }
    
    // 첫번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupFirstFinalStackView() {
        [self.coinTypeStackView, self.buyStartDateStackView, self.sellDateStackView,
         self.amountStackView, self.emptySpace, self.calcStartButton]
            .forEach { self.finalStackView.addArrangedSubview($0) }
        [self.buyEndDateStackView, self.frequencyStackView]
            .forEach { $0.removeFromSuperview() }
        
        self.buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName1
        self.buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder1
        self.amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder1
        self.amountLabel.text = Constant.TitleSetting.amountLabelName1
        self.resetTextField()
    }
    
    // 두번째 세그먼트를 선택했을 때의 FinalStackView 설정
    private func setupSecondFianlStackView() {
        [self.coinTypeStackView, self.buyStartDateStackView, self.buyEndDateStackView,
         self.sellDateStackView, self.frequencyStackView, self.amountStackView,
         self.emptySpace, self.calcStartButton]
            .forEach { self.finalStackView.addArrangedSubview($0) }
        
        self.buyStartDateLabel.text = Constant.TitleSetting.buyStartDateLabelName2
        self.buyStartDateTextField.placeholder = Constant.TitleSetting.buyStartDateTextFieldPlaceHolder2
        self.amountTextField.placeholder = Constant.TitleSetting.amountLabelTextFieldPlaceHolder2
        self.amountLabel.text = Constant.TitleSetting.amountLabelName2
        self.resetTextField()
    }
    
    // TextField 입력값 초기화
    private func resetTextField() {
        [self.buyStartDateTextField, self.buyEndDateTextField,
         self.frequencyTextField, self.amountTextField, self.sellDateTextField]
            .forEach { $0.text = "" }
    }
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        self.addSubview(self.activityIndicator)
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    // 로딩중임을 나타내는 Indicator 표시
    func presentLoadingIndicator() {
        if self.activityIndicator.isAnimating {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }
    
    func updateButtonColor(index: Int) {
        self.calcStartButton.setButtonBackgroundGradient(
            color1: Constant.UIColorSetting.themeGradientStartColors[index],
            color2: Constant.UIColorSetting.themeGradientMiddleColors[index],
            color3: Constant.UIColorSetting.themeGradientEndColors[index]
        )
    }

}

//MARK: - Custom Segmented Control의 델리게이트 메서드 구현

extension CalcView: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        _ = index == 0 ? self.setupFirstFinalStackView() : self.setupSecondFianlStackView()
        self.endEditing(true)
    }
    
}
