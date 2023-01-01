//
//  CalcTypeView.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcView: UIView {
    
    //MARK: - 스위치 속성 관련
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["분할매수","일괄매수"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 15, weight: .medium)
        control.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        control.selectedSegmentTintColor = Constant.UIColorSetting.themeColor
        control.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    //MARK: - 매수 시작 날짜 관련 속성 선언
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매수 시작 날짜"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var startDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = startDatePicker
        tf.placeholder = "날짜 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.minimumDate = Date(timeIntervalSince1970: 1367107200)  // 2013-04-28 00:00:00
        return picker
    }()
    
    private let startDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var startDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [startDateLabel, startDateTextField, startDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매도 날짜 관련 속성 선언
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매수 종료 날짜"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    lazy var endDateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.inputView = endDatePicker
        tf.placeholder = "날짜 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
    }()
    
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.contentHorizontalAlignment = .center
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko_KR")
        picker.maximumDate = Date()  // current date
        return picker
    }()
    
    private let endDateBottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        return view
    }()
    
    private lazy var endDateStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [endDateLabel, endDateTextField, endDateBottomLine])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 매 회차 매수금액 관련 속성 선언
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.text = "매 회차 매수 금액(달러)"
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
     
    //MARK: - 매수 반복 주기 관련 속성 선언
    
    private let frequencyLabel: UILabel = {
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
        tf.keyboardType = .decimalPad
        tf.placeholder = "주기 선택"
        tf.textColor = .label
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        tf.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        return tf
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
    
    //MARK: - 빈 공간 속성 선언
    
    private let emptySpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .label
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 버튼 관련 속성 선언

    private lazy var calcStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("계산", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var calcSaveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray5
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("결과 저장", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(onClickButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [calcStartButton, calcSaveButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 20
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    //MARK: - 기타
    
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
        _ = [startDateStackView, endDateStackView, amountStackView,
             frequencyStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(finalStackView)
        
        NSLayoutConstraint.activate([
            finalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 30),
            finalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -30),
            finalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            finalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -30),
            
            startDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            startDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            endDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            endDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            amountBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            amountBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            frequencyBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            frequencyBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 10),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
        
    }

    // 분할매수 수익계산에 관련된 StackView만 표출하기
    private func displayFirstFinalStackView() {
        _ = [startDateStackView, endDateStackView, amountStackView, frequencyStackView, emptySpace, buttonStackView].map { finalStackView.removeArrangedSubview($0) }
        _ = [startDateStackView, endDateStackView, amountStackView, frequencyStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            startDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            startDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            endDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            endDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            amountBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            amountBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            frequencyBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            frequencyBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 10),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
    }
    
    // 집중매수 수익계산에 관련된 StackView만 표출하기
    private func displaySecondFinalStackView() {
        _ = [startDateStackView, endDateStackView, emptySpace, buttonStackView].map { finalStackView.addArrangedSubview($0) }
        _ = [amountStackView, frequencyStackView].map { $0.removeFromSuperview() }
        
        NSLayoutConstraint.activate([
            startDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            startDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            endDateBottomLine.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -60),
            endDateBottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.bottomLineWidth),
            
            emptySpace.heightAnchor.constraint(equalToConstant: 10),
            
            buttonStackView.widthAnchor.constraint(equalTo: finalStackView.widthAnchor, constant: 0),
        ])
    }
    
    // 로딩중임을 나타내는 Indicator 설정
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
    
    //MARK: - 액션
    
    @objc private func segmentedValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            displayFirstFinalStackView()
        case 1:
            displaySecondFinalStackView()
        default:
            print(#function)
        }        
    }
    
    // 텍스트필드 편집을 시작했을 때
    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        switch textField {
        case startDateTextField:
            startDateLabel.textColor = Constant.UIColorSetting.themeColor
            startDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        case endDateTextField:
            endDateLabel.textColor = Constant.UIColorSetting.themeColor
            endDateBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        case amountTextField:
            amountLabel.textColor = Constant.UIColorSetting.themeColor
            amountBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        case frequencyTextField:
            frequencyLabel.textColor = Constant.UIColorSetting.themeColor
            frequencyBottomLine.backgroundColor = Constant.UIColorSetting.themeColor
        default:
            print(#function)
        }
    }
    
    // 텍스트필드 편집을 끝냈을 때
    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        switch textField {
        case startDateTextField:
            startDateLabel.textColor = .label
            startDateBottomLine.backgroundColor = .label
        case endDateTextField:
            endDateLabel.textColor = .label
            endDateBottomLine.backgroundColor = .label
        case amountTextField:
            amountLabel.textColor = .label
            amountBottomLine.backgroundColor = .label
        case frequencyTextField:
            frequencyLabel.textColor = .label
            frequencyBottomLine.backgroundColor = .label
        default:
            print(#function)
        }
    }
    
    // 버튼을 눌렀을 때
    @objc private func onClickButton(_ button: UIButton) {
        if button == calcStartButton {
            if activityIndicator.isAnimating {
                activityIndicator.stopAnimating()
                calcStartButton.backgroundColor = .systemGray5
                calcStartButton.setTitle("계산하기", for: .normal)
                indicatorContainer.backgroundColor = .clear
            }
            else {
                self.activityIndicator.startAnimating()
                calcStartButton.backgroundColor = .red
                calcStartButton.setTitle("중단", for: .normal)
                //indicatorContainer.backgroundColor = Constant.ColorSetting.themeColor
                //indicatorContainer.alpha = 0.3
                //indicatorContainer.backgroundColor?.withAlphaComponent(0.3)
                //activityIndicator.alpha = 1.0
            }
        }
        
        if button == calcSaveButton {
            
        }
        
    }
    
}
