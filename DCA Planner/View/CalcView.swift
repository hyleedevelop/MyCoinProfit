//
//  CalcTypeView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcView: UIView {
    
    //MARK: - 스위치 속성
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["일괄매수","분할매수"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = Constant.UIColorSetting.themeColor
        control.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    //MARK: - 코인 속성
    
    let coinTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "코인 종류"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "코인 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()

    let coinTypePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let coinTypeBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var coinTypeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [coinTypeLabel, coinTypeTextField, coinTypeBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매수 시작 날짜 관련 속성
    
    let buyStartDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매수 날짜"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "날짜 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let buyStartDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        // 최소날짜: 2013-04-28 00:00:00
        picker.minimumDate = Date(timeIntervalSince1970: 1367107200)
        // 최대날짜: 오늘날짜 - 1일
        picker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return picker
    }()
    
    private let buyStartDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
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
    
    let buyEndDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매수 종료 날짜"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "날짜 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let buyEndDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.maximumDate = Date()  // current date
        return picker
    }()
    
    private let buyEndDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
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
    
    //MARK: - 매수 종료 날짜 관련 속성
    
    let sellDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매도 날짜"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "날짜 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let sellDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.maximumDate = Date()  // current date
        return picker
    }()
    
    private let sellDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
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
    
    //MARK: - 매 회차 매수금액 관련 속성
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "총 매수 금액(달러)"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "금액 입력"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()

    private let amountBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
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
     
    //MARK: - 매수 반복 주기 관련 속성
    
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매수 반복 주기"
        label.textAlignment = .left
        label.numberOfLines = 1
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
        tf.placeholder = "주기 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let frequencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let frequencyBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
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
        button.backgroundColor = .systemGray5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle(Constant.TitleSetting.calcStartButtonName, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constant.UIColorSetting.themeColor
        //button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
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
        let sv = UIStackView(arrangedSubviews: [calcStartButton, calcResetButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 20
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
        sv.spacing = 35
        sv.alignment = .leading
        sv.distribution = .equalSpacing
        return sv
    }()
    
    // TextField에 실수(숫자+소수점)만 입력할 수 있는 Set
    private let charSet: CharacterSet = {
        var cs = CharacterSet.lowercaseLetters
        cs.insert(charactersIn: "0123456789")
        cs.insert(charactersIn: ".")
        return cs.inverted
    }()
    
    // 로딩 아이콘
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = Constant.UIColorSetting.themeColor
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // 로딩 아이콘
    private let indicatorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.opacity = 1.0
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    //MARK: - 생성자
    
    // UIView 초기생성자
    override init(frame: CGRect) {
        super.init(frame: frame)

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
    
    private func setupSegmentedControl() {
        self.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 70),
            segmentedControl.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -70),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30),
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
    
    // 최종 StackView 초기 설정
    private func setupFinalStackView() {
        _ = [coinTypeStackView, buyStartDateStackView, sellDateStackView, amountStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(finalStackView)
        
        NSLayoutConstraint.activate([
            finalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 40),
            finalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -40),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 30),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -30),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -80).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth).isActive = true }
    }
    
    private func setupFirstFinalStackView() {
        _ = [buyEndDateStackView, frequencyStackView].map { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -80).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, sellDateBottomLine, amountBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth).isActive = true }
        
        buyStartDateLabel.text = "매수 날짜"
        amountLabel.text = "총 매수 금액(달러)"
        resetTextField()
    }
    
    private func setupSecondFianlStackView() {
        _ = [coinTypeStackView, buyStartDateStackView, buyEndDateStackView, sellDateStackView, amountStackView, frequencyStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            emptySpace.heightAnchor.constraint(equalToConstant: 0),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
        _ = [coinTypeBottomLine, buyStartDateBottomLine, buyEndDateBottomLine, sellDateBottomLine, amountBottomLine, frequencyBottomLine].map { $0.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -80).isActive = true }
        _ = [coinTypeBottomLine, buyStartDateBottomLine, buyEndDateBottomLine, sellDateBottomLine, amountBottomLine, frequencyBottomLine].map { $0.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth).isActive = true }
        
        buyStartDateLabel.text = "매수 시작 날짜"
        amountLabel.text = "매 회차 매수 금액(달러)"
        resetTextField()

    }
    
    private func resetTextField() {
        amountTextField.text = ""
        frequencyTextField.text = ""
    }
    
    // 로딩중임을 나타내는 Indicator 설정
    private func setupActivityIndicator() {
        self.addSubview(indicatorContainer)
        indicatorContainer.addSubview(activityIndicator)
        self.bringSubviewToFront(indicatorContainer)
        
        NSLayoutConstraint.activate([
            indicatorContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            indicatorContainer.widthAnchor.constraint(equalToConstant: 80),
            indicatorContainer.heightAnchor.constraint(equalToConstant: 80),

            activityIndicator.centerXAnchor.constraint(equalTo: indicatorContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorContainer.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // 로딩중임을 나타내는 Indicator 표시
    func presentLoadingIndicator() {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
            calcStartButton.backgroundColor = Constant.UIColorSetting.themeColor
            indicatorContainer.backgroundColor = .clear
        }
        else {
            self.activityIndicator.startAnimating()
            calcStartButton.backgroundColor = .red
            indicatorContainer.backgroundColor = .clear
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
    
    // 텍스트필드 편집을 시작했을 때 해당 TextField와 BottomLine을 테마 컬러값으로 설정
    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        if textField == coinTypeTextField {
            coinTypeLabel.textColor = Constant.UIColorSetting.themeColor
            coinTypeBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        } else if textField == buyStartDateTextField {
            buyStartDateLabel.textColor = Constant.UIColorSetting.themeColor
            buyStartDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        } else if textField == buyEndDateTextField {
            buyEndDateLabel.textColor = Constant.UIColorSetting.themeColor
            buyEndDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        } else if textField == sellDateTextField {
            sellDateLabel.textColor = Constant.UIColorSetting.themeColor
            sellDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        } else if textField == amountTextField {
            amountLabel.textColor = Constant.UIColorSetting.themeColor
            amountBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        } else if textField == frequencyTextField {
            frequencyLabel.textColor = Constant.UIColorSetting.themeColor
            frequencyBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        }
    }
    
    // 텍스트필드 편집을 끝냈을 때 강조되었던 TextField와 BottomLine을 기본 값으로 설정
    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        if textField == coinTypeTextField {
            coinTypeLabel.textColor = .label
            coinTypeBottomLine.backgroundColor = .label
        } else if textField == buyStartDateTextField {
            buyStartDateLabel.textColor = .label
            buyStartDateBottomLine.backgroundColor = .label
        } else if textField == buyEndDateTextField {
            buyEndDateLabel.textColor = .label
            buyEndDateBottomLine.backgroundColor = .label
        } else if textField == sellDateTextField {
            sellDateLabel.textColor = .label
            sellDateBottomLine.backgroundColor = .label
        } else if textField == amountTextField {
            amountLabel.textColor = .label
            amountBottomLine.backgroundColor = .label
        } else if textField == frequencyTextField {
            frequencyLabel.textColor = .label
            frequencyBottomLine.backgroundColor = .label
        }
    }
    
}

//MARK: - UITextFieldDelegate
// ViewController에서 Delegate 프로토콜을 채택하는 경우 xxx.delegate = self를 꼭 써줘야 함
// View에서는 프로토콜 채택만 하면 됨

extension CalcView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // return 버튼을 눌렀을 때 구현할 내용
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            if string.count > 0 {
                guard string.rangeOfCharacter(from: charSet) == nil else { return false }
            }
        }
        
        return true
    }
    
}
