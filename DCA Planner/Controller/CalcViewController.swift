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
        navigationController?.navigationBar.tintColor = Constant.ColorSetting.themeColor
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false

        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Constant.ColorSetting.themeColor
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
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        let toolBarFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBarDoneButton = UIBarButtonItem(title: "닫기", style: .done, target: nil, action: #selector(doneButtonTapped))
        toolBar.sizeToFit()
        toolBar.setItems([toolBarFlexibleSpace, toolBarDoneButton], animated: true)
        
        calcView.startDateTextField.inputAccessoryView = toolBar
        calcView.startDatePicker.addTarget(self, action: #selector(startDatePickerSelected(_:)), for: .valueChanged)
        
        calcView.endDateTextField.inputAccessoryView = toolBar
        calcView.endDatePicker.addTarget(self, action: #selector(endDatePickerSelected(_:)), for: .valueChanged)
    }
    
    @objc private func startDatePickerSelected(_ sender: UIDatePicker) {
        let pickedDate = sender.date
        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy년 MM월 dd일 (E)"
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        calcView.startDateTextField.text = pickedDateFormatter1.string(from: pickedDate)

        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        self.startDateString = pickedDateFormatter2.string(from: pickedDate)
        print(startDateString)
    }
    
    @objc private func endDatePickerSelected(_ sender: UIDatePicker) {
        let pickedDate = sender.date
        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy년 MM월 dd일 (E)"
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        calcView.endDateTextField.text = pickedDateFormatter1.string(from: pickedDate)

        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        self.endDateString = pickedDateFormatter2.string(from: pickedDate)
        print(endDateString)
    }
    
    @objc private func doneButtonTapped() {
        self.view.endEditing(true)
    }
    
    @objc private func addButtonTapped() {
        let bookmarkVC = BookmarkViewController()
        navigationController?.pushViewController(bookmarkVC, animated: true)
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
