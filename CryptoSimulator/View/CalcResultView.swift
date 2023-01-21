//
//  CalcResultModalView.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/16.
//

import UIKit
import Charts

final class CalcResultView: UIView {

//    private let navBarTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "계산 결과"
//        label.font = .systemFont(ofSize: 20, weight: .bold)
//        label.textColor = .label
//        label.numberOfLines = 0
//        return label
//    }()
//
//    private let modalViewLogoImage: UIImageView = {
//        let iv = UIImageView()
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        iv.image = UIImage(named: "calcResultModalView_main_image.svg")
//        iv.sizeToFit()
//        return iv
//    }()
    //MARK: - 프레임

    // ScrollView (내용이 추가되거나 기기에 따라 세로 화면이 부족해질 수 있으므로 일반 뷰가 아닌 스크롤 뷰를 사용하였음)
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.showsVerticalScrollIndicator = true
        view.scrollsToTop = true
        return view
    }()
    
    // 그래프를 담고 있는 View
    let graphContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        //view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - Chart
    
    // 코인 가격 추이 Chart
    let coinPriceChartView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        view.layer.borderWidth = 0
        return view
    }()
    
    // 평가금 추이 Chart
    let balanceChartView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        view.layer.borderWidth = 0
        return view
    }()
    
    //MARK: - 결과를 요약한 문장
    
    // 결과를 요약해서 보여주는 Label
    var summaryLabel = [UILabel]()
    let numberOfLabels = 6
    
    //MARK: - 그래프
    
    // 그래프의 바닥 기준선
    private let bottomLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    // 원금 막대
    let leftBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.borderColor = Constant.CGColorSetting.black
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        return view
    }()
    
    // 원금 숫자 텍스트
    let leftBarValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 평가금 막대
    let rightBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.layer.borderColor = Constant.CGColorSetting.black
        view.layer.borderWidth = Constant.SizeSetting.graphLineWidthAnchorConstant
        return view
    }()

    // 평가금 숫자 텍스트
    let rightBarValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 화살표 그림
    let centerArrow: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.image = UIImage(named: "UpCurvedArrow.png")
        iv.image = UIImage(systemName: "arrow.forward")
        iv.tintColor = .black
        iv.sizeToFit()
        return iv
    }()
    
    // 수익금/수익률 텍스트
    let centerArrowValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.graphLabelSmallFontSize, weight: Constant.SizeSetting.graphLabelSmallFontWeight)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // 원금 텍스트
    private let leftTickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = "원금"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // 평가금 텍스트
    private let rightTickLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constant.SizeSetting.labelFontSize, weight: Constant.SizeSetting.labelFontWeight)
        label.text = "평가금"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    
    //MARK: - 버튼
    
//    lazy var showChartButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = Constant.UIColorSetting.themeColor
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitle(Constant.TitleSetting.showChartButtonName, for: .normal)
//        button.setTitleColor(.systemBackground, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        button.setImage(UIImage(systemName: "chevron.down")?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal), for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft
//        //button.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
//    lazy var resultShareButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = Constant.UIColorSetting.lightModeBackground
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.setTitle(Constant.TitleSetting.calcShareButtonName, for: .normal)
//        button.setTitleColor(.label, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        //button.addTarget(self, action: #selector(resultButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var buttonStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [resultSaveButton, resultShareButton])
//        sv.translatesAutoresizingMaskIntoConstraints = false
//        sv.spacing = 15
//        sv.axis = .vertical
//        sv.distribution = .fillEqually
//        sv.alignment = .fill
//        return sv
//    }()

    //MARK: - 생성자
    
    // UIView 초기생성자
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupFrame()
        setupSummaryLabel()
        setupSummaryGraph()
        //setupButton()
        //setupChart()
    }
        
    // UIView 필수생성자
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - 하위 뷰 등록 및 제약조건 설정
    
    private func setupFrame() {
        self.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -0),
        ])
    }
    
    private func setupSummaryLabel() {
        for i in 0..<numberOfLabels {
            summaryLabel.append(UILabel())
            summaryLabel[i].translatesAutoresizingMaskIntoConstraints = false
            summaryLabel[i].font = .systemFont(ofSize: Constant.SizeSetting.summaryLabelSmallFontSize,
                                               weight: Constant.SizeSetting.summaryLabelSmallFontWeight)
            summaryLabel[i].textColor = .label
            summaryLabel[i].numberOfLines = 0
            summaryLabel[i].lineBreakMode = .byWordWrapping
            summaryLabel[i].textAlignment = .center
            summaryLabel[i].addCharacterSpacing()
            
            scrollView.addSubview(summaryLabel[i])
            
            summaryLabel[i].centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
            summaryLabel[i].heightAnchor.constraint(equalToConstant: 25).isActive = true
            if i == 0 {
                summaryLabel[i].topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10).isActive = true
            } else {
                summaryLabel[i].topAnchor.constraint(equalTo: summaryLabel[i-1].bottomAnchor, constant: 5).isActive = true
            }
        }
    }
    
    private func setupSummaryGraph() {
        _ = [graphContainerView, bottomLine, leftBar, rightBar, leftBarValueLabel, leftTickLabel, rightBarValueLabel, rightTickLabel, centerArrow, centerArrowValueLabel, balanceChartView].map{ scrollView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            graphContainerView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            graphContainerView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, constant: -90),
            graphContainerView.topAnchor.constraint(equalTo: summaryLabel[numberOfLabels-1].bottomAnchor, constant: 50),
            graphContainerView.heightAnchor.constraint(equalToConstant: 200),

            bottomLine.leadingAnchor.constraint(equalTo: graphContainerView.leadingAnchor, constant: 10),
            bottomLine.trailingAnchor.constraint(equalTo: graphContainerView.trailingAnchor, constant: -10),
            bottomLine.heightAnchor.constraint(equalToConstant: Constant.SizeSetting.graphLineWidthAnchorConstant + 0.2),
            bottomLine.bottomAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: -30),
            
            //leftBar.heightAnchor.constraint(equalToConstant: 50),
            leftBar.bottomAnchor.constraint(equalTo: bottomLine.bottomAnchor),
            leftBar.widthAnchor.constraint(equalToConstant: 25),
            leftBar.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor, constant: -100),
            
            //rightBar.heightAnchor.constraint(equalToConstant: 225),
            rightBar.bottomAnchor.constraint(equalTo: bottomLine.bottomAnchor),
            rightBar.widthAnchor.constraint(equalToConstant: 25),
            rightBar.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor, constant: 100),
            
            leftBarValueLabel.centerXAnchor.constraint(equalTo: leftBar.centerXAnchor),
            leftBarValueLabel.bottomAnchor.constraint(equalTo: leftBar.topAnchor, constant: -5),
            
            leftTickLabel.centerXAnchor.constraint(equalTo: leftBar.centerXAnchor),
            leftTickLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 5),
            
            rightBarValueLabel.centerXAnchor.constraint(equalTo: rightBar.centerXAnchor),
            rightBarValueLabel.bottomAnchor.constraint(equalTo: rightBar.topAnchor, constant: -5),
            
            rightTickLabel.centerXAnchor.constraint(equalTo: rightBar.centerXAnchor),
            rightTickLabel.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 5),
            
            centerArrow.centerXAnchor.constraint(equalTo: bottomLine.centerXAnchor),
            centerArrow.centerYAnchor.constraint(equalTo: graphContainerView.centerYAnchor, constant: 0),
            centerArrow.widthAnchor.constraint(equalToConstant: 40),
            centerArrow.heightAnchor.constraint(equalToConstant: 20),
            
            centerArrowValueLabel.centerXAnchor.constraint(equalTo: centerArrow.centerXAnchor),
            centerArrowValueLabel.bottomAnchor.constraint(equalTo: centerArrow.topAnchor, constant: -2),
        ])
    }
    
//    private func setupButton() {
//        self.addSubview(showChartButton)
//
//        NSLayoutConstraint.activate([
//            showChartButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            showChartButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            showChartButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            showChartButton.heightAnchor.constraint(equalToConstant: 40),
//        ])
//    }
    
    func setupChart() {
        scrollView.addSubview(balanceChartView)
        
        NSLayoutConstraint.activate([
            balanceChartView.topAnchor.constraint(equalTo: graphContainerView.bottomAnchor, constant: 30),
            balanceChartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            balanceChartView.heightAnchor.constraint(equalToConstant: 200),
            balanceChartView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            balanceChartView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            balanceChartView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        let months = ["1", "2", "3", "4", "5", "6", "7", "8"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0]
        drawLineChart(dataPoints: months, values: unitsSold)
    }
    
    // Line Chart 그리기
    func drawLineChart(dataPoints: [String], values: [Double]) {
        balanceChartView.noDataText = "데이터가 없습니다."
        balanceChartView.noDataFont = .systemFont(ofSize: 20)
        balanceChartView.noDataTextColor = .lightGray
        
        // 데이터 생성
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "수익률")
        chartDataSet.mode = .cubicBezier
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 2
        chartDataSet.setColor(Constant.UIColorSetting.themeColor)
        chartDataSet.fill = ColorFill(color: Constant.UIColorSetting.themeColor)
        chartDataSet.fillAlpha = 0.8
        chartDataSet.drawFilledEnabled = true
        
        // 차트 컬러
        chartDataSet.colors = [Constant.UIColorSetting.themeColor]
        
        // 데이터 삽입
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        balanceChartView.data = chartData
        
        // 탭, 드래그, 줌 가능 여부 설정
        balanceChartView.highlightPerTapEnabled = false
        balanceChartView.highlightPerDragEnabled = false
        balanceChartView.doubleTapToZoomEnabled = false
        
        // X축 레이블 위치 및 포맷 설정
        balanceChartView.xAxis.labelPosition = .bottom
        balanceChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        //balanceChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 옵션 애니메이션
        balanceChartView.animate(xAxisDuration: 0, yAxisDuration: 1.5, easingOption: .linear)
        
        // 왼쪽 축의 범위 설정
        balanceChartView.leftAxis.axisMaximum = 30
        balanceChartView.leftAxis.axisMinimum = 0
        
        let xAxis = balanceChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.granularity = 1
        xAxis.axisLineColor = .black
        
        let yAxisLeft = balanceChartView.leftAxis
        yAxisLeft.enabled = true
        yAxisLeft.drawGridLinesEnabled = false
        yAxisLeft.labelFont = .systemFont(ofSize: 12, weight: .light)
        yAxisLeft.granularity = 10
        yAxisLeft.axisLineColor = .black
        
        let yAxisRight = balanceChartView.rightAxis
        yAxisRight.enabled = false
        yAxisRight.drawGridLinesEnabled = false
        yAxisRight.drawLabelsEnabled = false
        
        let legend = balanceChartView.legend
        legend.enabled = false
        legend.horizontalAlignment = .center
        legend.yOffset = 30
    }
    
}
