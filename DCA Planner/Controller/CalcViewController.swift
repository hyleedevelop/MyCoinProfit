//
//  CalcTypeViewController.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import UIKit

final class CalcViewController: UIViewController {

    private let calcView = CalcView()
    
    var startDateString: String = ""
    var endDateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // NavigationBar 설정
    private func setupNavBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Constant.UIColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.UIColorSetting.themeColor
        navigationItem.title = Constant.MenuSetting.menuName2
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
  
    override func loadView() {
        view = calcView
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupDatePicker() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        let toolBarFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarDoneButton = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: #selector(doneButtonTapped))
        toolBar.sizeToFit()
        toolBar.setItems([toolBarFlexibleSpace, toolBarDoneButton], animated: true)
        
        calcView.startDateTextField.inputAccessoryView = toolBar
        calcView.endDateTextField.inputAccessoryView = toolBar
        calcView.amountTextField.inputAccessoryView = toolBar
        calcView.frequencyTextField.inputAccessoryView = toolBar
        
        calcView.startDatePicker.addTarget(self, action: #selector(datePickerSelected(_:)), for: .valueChanged)
        calcView.endDatePicker.addTarget(self, action: #selector(datePickerSelected(_:)), for: .valueChanged)
    }
    
    @objc private func datePickerSelected(_ sender: UIDatePicker) {
        let pickedDate = sender.date
        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy년 MM월 dd일 (E)"
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        
        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        
        if sender == calcView.startDatePicker {
            calcView.startDateTextField.textColor = .label
            calcView.startDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
            self.startDateString = pickedDateFormatter2.string(from: pickedDate)
            print("startDateString: \(startDateString)")
        }
        
        if sender == calcView.endDatePicker {
            calcView.endDateTextField.textColor = .label
            calcView.endDateTextField.text = pickedDateFormatter1.string(from: pickedDate)
            self.endDateString = pickedDateFormatter2.string(from: pickedDate)
            print("endDateString: \(endDateString)")
        }
    }
    
    @objc private func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc private func addButtonTapped() {
        let bookmarkVC = BookmarkViewController()
        navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    
    @objc private func helpButtonTapped() {
        // 도움말 VC 인스턴스 생성
        let coinHelpModalVC = CoinHelpModalViewController()
        // 도움말 VC에 Navigation VC 넣기
        let nav = UINavigationController(rootViewController: coinHelpModalVC)
        
        // Bottom Sheet 관련 설정
        nav.modalPresentationStyle = .pageSheet
        nav.isModalInPresentation = false  // true이면 dismiss 할 수 없음
        
        // sheetPresentationController는 iOS 15 이상부터 사용 가능
        if let sheet = nav.sheetPresentationController {
            // Bottom Sheet를 확장/축소 했을 때 화면 꼭대기가 걸리는 높이 지정
            //sheet.largestUndimmedDetentIdentifier = .medium
            //sheet.detents = [.medium(), .large()]
            if #available(iOS 16.0, *) {
                // iOS 16 이상부터 커스텀으로 높이를 결정할 수 있음
                // iOS 15는 .medium()과 .large() 둘 중 하나만 가능
                sheet.detents = [.custom(resolver: { context in
                    return context.maximumDetentValue * 0.7
                })]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = true
        }
        self.present(nav, animated: true, completion: nil)
    }
    
}

//extension CalcViewController: UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//    }
//}
