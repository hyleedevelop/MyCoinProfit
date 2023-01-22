//
//  CalcResultModalViewController.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/10.
//

import UIKit

final class CalcResultViewController: UIViewController {
    
    let calcVC = CalcViewController()
    let calcResultView = CalcResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcVC.calcResultDataDelegate = self
    
        setupNavBar()
        setupView()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func loadView() {
        view = calcResultView
    }
    
    private func setupNavBar() {
        //navigationItem.title = "도움말"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.label]
        
        // scrollEdge: 스크롤 하기 전의 NavigationBar
        // standard: 스크롤을 하고 있을 때의 NavigationBar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        
//        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
//        let saveButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
//        _ = [shareButton, saveButton].map{ $0.tintColor = Constant.UIColorSetting.themeColor }
//        navigationItem.leftBarButtonItems = [shareButton, saveButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(buttonTapped(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
        navigationItem.title = "Summary"
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
        
    }

    // 화면 하단의 Button 설정
    private func setupButton() {
        //calcResultView.showChartButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    // 스크린샷을 사진 앱에 저장 (1)
    private func takeScreenshot(of view: UIView) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.bounds.width, height: view.bounds.height), false, 2)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // photo library 접근 권한을 허용해줘야 함(Info.plist)
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
    
    // 스크린샷을 사진 앱에 저장 (2)
    @objc private func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    // 버튼을 눌렀을 때 실행할 내용
    @objc private func buttonTapped(_ button: UIButton) {
        if button == navigationItem.leftBarButtonItem {
            // AlertController, AlertAction 생성
            let alert = UIAlertController(title: "Confirm", message: "Do you want to save the result\nas image?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.takeScreenshot(of: self.view)
            }
            
            // 액션 추가 및 팝업메세지 출력
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        if button == navigationItem.rightBarButtonItem {
            self.dismiss(animated: true)
        }
        
//        if button == calcResultView.showChartButton {
//            // 시간 그래프 보기 버튼을 누르면 ModalView의 높이가 늘어나고,
//            // 보기 버튼이 사라지면서 시간 그래프가 ScrollView에 추가되어야 함
//            DispatchQueue.main.async {
//                self.modalPresentationStyle = .fullScreen
//                self.sheetPresentationController?.detents = [.custom(resolver: { context in
//                    return UIScreen.main.bounds.height
//                })]
//                self.calcResultView.setupChart()
//                self.calcResultView.showChartButton.removeFromSuperview()
//                self.calcResultView.layoutIfNeeded()
//            }
//        }
    }
    
}

// CalcViewController로부터 데이터를 전달받기 위해 커스텀 프로토콜 채택
extension CalcResultViewController: CalcResultDelegate {
    
    // 이전 화면에서 데이터를 전달받아 작업할 내용
    func receiveCalcResultData(segmentIndex index: Int, with data: Any) {
        if index == 0 {  // 한번에 매수하기
            guard let data = data as? CalcResultType1 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")
            
            let amountTotal: String = data.0.toUSD()
            
            let roi: String = data.1.toPercentage()
            let isROIPositive: Bool = data.1 >= 0 ? true : false
            let lossOrGain = data.1 >= 0 ? "PROFIT" : "LOSS"
            let emoticon = data.1 >= 0 ? "😁" : "😭"
            let lossOrGainColor: UIColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                                         : Constant.UIColorSetting.negativeColor
            
            let profit: String = data.2.toUSDPlusSigned()
            let balance: String = data.3.toUSD()
            let coinType: String = data.4.uppercased()
            
            // 문자열에서 요일 제거한 나머지 부분
            let buyStartDate: String = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            let sellDate: String = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            
            // Label 값 설정
            calcResultView.leftBarValueLabel.text = amountTotal
            calcResultView.rightBarValueLabel.text = balance
            calcResultView.centerArrowValueLabel.text = "\(profit)\n(\(roi))"
            
            // 화살표 위의 숫자 색상 설정
            let targetText = calcResultView.centerArrowValueLabel.text!
            let attString = NSMutableAttributedString(string: targetText)
            attString.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText as NSString).range(of: "\(profit)"))
            attString.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText as NSString).range(of: "(\(roi))"))
            calcResultView.centerArrowValueLabel.attributedText = attString
            
            // 원금과 평가금의 막대 높이 설정
            if isROIPositive {  // 수익률 > 0
                let heightRatio: CGFloat = data.0 / data.3
                //calcResultView.rightBar.heightAnchor.constraint(equalToConstant: 175).isActive = true
                calcResultView.rightBar.topAnchor.constraint(equalTo: calcResultView.graphContainerView.topAnchor, constant: 25).isActive = true
                calcResultView.leftBar.heightAnchor.constraint(equalTo: calcResultView.rightBar.heightAnchor, multiplier: heightRatio).isActive = true
            } else {  // 수익률 < 0
                let heightRatio: CGFloat = data.3 / data.0
                //calcResultView.leftBar.heightAnchor.constraint(equalToConstant: 175).isActive = true
                calcResultView.leftBar.topAnchor.constraint(equalTo: calcResultView.graphContainerView.topAnchor, constant: 25).isActive = true
                calcResultView.rightBar.heightAnchor.constraint(equalTo: calcResultView.leftBar.heightAnchor, multiplier: heightRatio).isActive = true
            }
            
            // 결과 요약 문구 1번째 줄 설정
            calcResultView.summaryLabel[0].text = "This is the result of \(coinType) investment"
            let targetText0 = calcResultView.summaryLabel[0].text!
            let attString0 = NSMutableAttributedString(string: targetText0)
            attString0.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText0 as NSString).range(of: "\(coinType)"))
            calcResultView.summaryLabel[0].attributedText = attString0
            
            // 결과 요약 문구 2번째 줄 설정
            calcResultView.summaryLabel[1].text = "when you bought it on \(buyStartDate)"
            let targetText1 = calcResultView.summaryLabel[1].text!
            let attString1 = NSMutableAttributedString(string: targetText1)
            attString1.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText1 as NSString).range(of: "\(buyStartDate)"))
            calcResultView.summaryLabel[1].attributedText = attString1
            
            // 결과 요약 문구 3번째 줄 설정
            calcResultView.summaryLabel[2].text = "and sold it on \(sellDate)."
            let targetText2 = calcResultView.summaryLabel[2].text!
            let attString2 = NSMutableAttributedString(string: targetText2)
            attString2.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText2 as NSString).range(of: "\(sellDate)"))
            calcResultView.summaryLabel[2].attributedText = attString2
            
            // 결과 요약 문구 4번째 줄 설정
//            calcResultView.summaryLabel[3].text = "You will get a \(lossOrGain) of \(roi) \(emoticon)"
//            let targetText3 = calcResultView.summaryLabel[3].text!
//            let attString3 = NSMutableAttributedString(string: targetText3)
//            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(roi)"))
//            attString3.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText3 as NSString).range(of: "\(roi)"))
//            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(lossOrGain)"))
//            attString3.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText3 as NSString).range(of: "\(lossOrGain)"))
//            calcResultView.summaryLabel[3].attributedText = attString3
            
            // 결과 요약 문구 5~6번째 줄은 필요 없으므로 상위 뷰에서 제거
            calcResultView.summaryLabel[3].removeFromSuperview()
            calcResultView.summaryLabel[4].removeFromSuperview()
            calcResultView.summaryLabel[5].removeFromSuperview()
            
            // 그래프가 들어갈 영역이 마지막 summaryLabel과 떨어져 있는 거리 설정
            calcResultView.graphContainerView.topAnchor.constraint(equalTo: calcResultView.summaryLabel[2].bottomAnchor, constant: 40).isActive = true
        }
    
        if index == 1 {  // 나눠서 매수하기
            guard let data = data as? CalcResultType2 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")
            
            let amountTotal: String = data.0.toUSD()
            
            let roi: String = data.1.toPercentage()
            let isROIPositive: Bool = data.1 >= 0 ? true : false
            let lossOrGain = data.1 >= 0 ? "PROFIT" : "LOSS"
            let emoticon = data.1 >= 0 ? "😁" : "😭"
            let lossOrGainColor: UIColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor
                                                         : Constant.UIColorSetting.negativeColor
            
            let profit: String = data.2.toUSDPlusSigned()
            let balance: String = data.3.toUSD()
            let coinType: String = data.4.uppercased()
            
            let buyStartDate: String = String(data.5[...data.5.index(data.5.startIndex, offsetBy: 11)]).uppercased()
            let buyEndDate: String = String(data.6[...data.6.index(data.6.startIndex, offsetBy: 11)]).uppercased()
            let sellDate: String = String(data.7[...data.7.index(data.7.startIndex, offsetBy: 11)]).uppercased()
            
            let frequency: String = data.8
            let amountEach: String = "\(data.9)달러"
            
            // Label 값 설정
            calcResultView.leftBarValueLabel.text = amountTotal
            calcResultView.rightBarValueLabel.text = balance
            calcResultView.centerArrowValueLabel.text = "\(profit)\n\(roi)"
            
            // 화살표 위의 숫자 색상 설정
            let targetText = calcResultView.centerArrowValueLabel.text!
            let attString = NSMutableAttributedString(string: targetText)
            attString.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText as NSString).range(of: "\(profit)"))
            attString.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText as NSString).range(of: "\(roi)"))
            calcResultView.centerArrowValueLabel.attributedText = attString
            
            // 원금과 평가금의 막대 높이를 수익률이 양수인지 음수인지에 따라 다르게 설정
            if isROIPositive {  // 수익률 > 0
                let heightRatio: CGFloat = data.0 / data.3
                //calcResultView.rightBar.heightAnchor.constraint(equalToConstant: 175).isActive = true
                calcResultView.rightBar.topAnchor.constraint(equalTo: calcResultView.graphContainerView.topAnchor, constant: 25).isActive = true
                calcResultView.leftBar.heightAnchor.constraint(equalTo: calcResultView.rightBar.heightAnchor, multiplier: heightRatio).isActive = true
            } else {  // 수익률 < 0
                let heightRatio: CGFloat = data.3 / data.0
                //calcResultView.leftBar.heightAnchor.constraint(equalToConstant: 175).isActive = true
                calcResultView.leftBar.topAnchor.constraint(equalTo: calcResultView.graphContainerView.topAnchor, constant: 25).isActive = true
                calcResultView.rightBar.heightAnchor.constraint(equalTo: calcResultView.leftBar.heightAnchor, multiplier: heightRatio).isActive = true
            }
            
            // 결과 요약 문구 1번째 줄 설정
            calcResultView.summaryLabel[0].text = "\(coinType)의 경우"
            let targetText0 = calcResultView.summaryLabel[0].text!
            let attString0 = NSMutableAttributedString(string: targetText0)
            attString0.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText0 as NSString).range(of: "\(coinType)"))
            calcResultView.summaryLabel[0].attributedText = attString0
            
            // 결과 요약 문구 2번째 줄 설정
            calcResultView.summaryLabel[1].text = "\(buyStartDate)부터"
            let targetText1 = calcResultView.summaryLabel[1].text!
            let attString1 = NSMutableAttributedString(string: targetText1)
            attString1.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText1 as NSString).range(of: "\(buyStartDate)"))
            calcResultView.summaryLabel[1].attributedText = attString1
            
            // 결과 요약 문구 3번째 줄 설정
            calcResultView.summaryLabel[2].text = "\(buyEndDate)까지"
            let targetText2 = calcResultView.summaryLabel[2].text!
            let attString2 = NSMutableAttributedString(string: targetText2)
            attString2.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText2 as NSString).range(of: "\(buyEndDate)"))
            calcResultView.summaryLabel[2].attributedText = attString2
            
            // 결과 요약 문구 4번째 줄 설정
            calcResultView.summaryLabel[3].text = "\(frequency) \(amountEach)씩 매수하고"
            let targetText3 = calcResultView.summaryLabel[3].text!
            let attString3 = NSMutableAttributedString(string: targetText3)
            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(frequency)"))
            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(amountEach)"))
            calcResultView.summaryLabel[3].attributedText = attString3
            
            // 결과 요약 문구 5번째 줄 설정
            calcResultView.summaryLabel[4].text = "\(sellDate)에 매도하면"
            let targetText4 = calcResultView.summaryLabel[4].text!
            let attString4 = NSMutableAttributedString(string: targetText4)
            attString4.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText4 as NSString).range(of: "\(sellDate)"))
            calcResultView.summaryLabel[4].attributedText = attString4
            
            // 결과 요약 문구 6번째 줄 설정
            calcResultView.summaryLabel[5].text = "\(roi)의 \(lossOrGain)이 발생합니다."
            let targetText5 = calcResultView.summaryLabel[5].text!
            let attString5 = NSMutableAttributedString(string: targetText5)
            attString5.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText5 as NSString).range(of: "\(roi)"))
            attString5.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText5 as NSString).range(of: "\(roi)"))
            attString5.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText5 as NSString).range(of: "\(lossOrGain)"))
            attString5.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText5 as NSString).range(of: "\(lossOrGain)"))
            calcResultView.summaryLabel[5].attributedText = attString5
        }
    }
    
}
