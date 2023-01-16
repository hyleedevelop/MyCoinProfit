//
//  CalcResultModalViewController.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/10.
//

import UIKit

final class CalcResultViewController: UIViewController {
    
    let calcVC = CalcViewController()
    let calcResultView = CalcResultView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CalcViewController로부터 데이터를 전달받
        calcVC.dataDelegate = self
    
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
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        
        // scrollEdge: 스크롤 하기 전의 NavigationBar
        // standard: 스크롤을 하고 있을 때의 NavigationBar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .gray
    }
    
    // View 설정
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        
    }

    // 화면 하단의 Button 설정
    private func setupButton() {
        calcResultView.resultSaveButton.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
        calcResultView.resultShareButton.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
     
    @objc private func resultButtonTapped(_ button: UIButton) {
        if button == calcResultView.resultSaveButton {
            
        }
        
        if button == calcResultView.resultShareButton {
            
        }
    }
    
}

// CalcViewController로부터 데이터를 전달받기 위해 커스텀 프로토콜 채택
extension CalcResultViewController: CalcResultDelegate {
    
    // 이전 화면에서 데이터를 전달받아 작업할 내용
    func receiveData(segmentIndex index: Int, with data: Any) {
        if index == 0 {  // 한번에 매수하기
            guard let data = data as? CalcResultType1 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")
            
            let amountTotal = data.0.toUSD()
            let roi = data.1.toPercentage()
            let lossOrGain = data.1 >= 0 ? "수익" : "손실"
            let lossOrGainColor: UIColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor : Constant.UIColorSetting.negativeColor
            let profit = data.2.toUSD()
            let balance = data.3.toUSD()
            let coinType = data.4.localizedCapitalized
            let buyStartDate = data.5[...data.5.index(data.5.startIndex, offsetBy: 12)]  // 문자열에서 요일 제거
            let sellDate = data.6[...data.6.index(data.6.startIndex, offsetBy: 12)]  // 문자열에서 요일 제거
            
            // 결과 요약 문구 1번째 줄 설정
            calcResultView.summaryLabel[0].text = "\(coinType)을"
            let targetText0 = calcResultView.summaryLabel[0].text!
            let attString0 = NSMutableAttributedString(string: targetText0)
            attString0.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText0 as NSString).range(of: "\(coinType)"))
            calcResultView.summaryLabel[0].attributedText = attString0
            
            // 결과 요약 문구 2번째 줄 설정
            calcResultView.summaryLabel[1].text = "\(buyStartDate)에 매수하고"
            let targetText1 = calcResultView.summaryLabel[1].text!
            let attString1 = NSMutableAttributedString(string: targetText1)
            attString1.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText1 as NSString).range(of: "\(buyStartDate)"))
            calcResultView.summaryLabel[1].attributedText = attString1
            
            // 결과 요약 문구 3번째 줄 설정
            calcResultView.summaryLabel[2].text = "\(sellDate)에 매도하면"
            let targetText2 = calcResultView.summaryLabel[2].text!
            let attString2 = NSMutableAttributedString(string: targetText2)
            attString2.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText2 as NSString).range(of: "\(sellDate)"))
            calcResultView.summaryLabel[2].attributedText = attString2
            
            // 결과 요약 문구 4번째 줄 설정
            calcResultView.summaryLabel[3].text = "\(roi)의 \(lossOrGain)이 발생합니다."
            let targetText3 = calcResultView.summaryLabel[3].text!
            let attString3 = NSMutableAttributedString(string: targetText3)
            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(roi)"))
            attString3.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText3 as NSString).range(of: "\(lossOrGain)"))
            attString3.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText3 as NSString).range(of: "\(lossOrGain)"))
            calcResultView.summaryLabel[3].attributedText = attString3
            
            // 결과 요약 문구 5~6번째 줄은 필요 없으므로 상위 뷰에서 제거
            calcResultView.summaryLabel[4].removeFromSuperview()
            calcResultView.summaryLabel[5].removeFromSuperview()
            
            // 그래프가 들어갈 영역이 마지막 summaryLabel과 떨어져 있는 거리 설정
            calcResultView.graphContainerView.topAnchor.constraint(equalTo: calcResultView.summaryLabel[3].bottomAnchor, constant: 40).isActive = true
            
//            calcResultView.leftBar.heightAnchor
        }
    
        if index == 1 {  // 나눠서 매수하기
            guard let data = data as? CalcResultType2 else { return }
            print("계산화면에서 결과화면으로 전달되는 데이터: \(data)")
            
            let amountTotal = data.0.toUSD()
            let roi = abs(data.1).toPercentage()
            let lossOrGain = data.1 >= 0 ? "수익" : "손실"
            let lossOrGainColor: UIColor = (data.1 >= 0) ? Constant.UIColorSetting.positiveColor : Constant.UIColorSetting.negativeColor
            let profit = data.2.toUSD()
            let balance = data.3.toUSD()
            let coinType = data.4.localizedCapitalized
            let buyStartDate = data.5[...data.5.index(data.5.startIndex, offsetBy: 12)]  // 문자열에서 요일 제거
            let buyEndDate = data.6[...data.6.index(data.6.startIndex, offsetBy: 12)]  // 문자열에서 요일 제거
            let sellDate = data.7[...data.7.index(data.7.startIndex, offsetBy: 12)]  // 문자열에서 요일 제거
            let frequency = data.8
            let amountEach = "\(data.9)달러"
            
            // 결과 요약 문구 1번째 줄 설정
            calcResultView.summaryLabel[0].text = "\(coinType)을"
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
            attString5.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.SizeSetting.summaryLabelBigFontSize, weight: Constant.SizeSetting.summaryLabelBigFontWeight), range: (targetText5 as NSString).range(of: "\(lossOrGain)"))
            attString5.addAttribute(.foregroundColor, value: lossOrGainColor, range: (targetText5 as NSString).range(of: "\(lossOrGain)"))
            calcResultView.summaryLabel[5].attributedText = attString5
        }
    }
    
}
