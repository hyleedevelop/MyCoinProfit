//
//  GraphCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit
import Charts

final class GraphCell: UITableViewCell {

    // 메뉴 제목 Label
    var itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    // 선 그래프
    let lineChartView: LineChartView = {
        let view = LineChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderColor = Constant.CGColorSetting.themeColor
        view.layer.borderWidth = Constant.ShapeSetting.graphLineWidthAnchorConstant
        view.layer.borderWidth = 0
        return view
    }()
        
    // TableViewCell 생성자 셋팅 (1)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        setupUI()
        setupChart()
    }
    
    // TableViewCell 생성자 셋팅 (2)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 설정
    private func setupUI() {
        _ = [itemLabel].map{ self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            itemLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            itemLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -0),
            itemLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            itemLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    func setupChart() {
        self.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            lineChartView.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 10),
            lineChartView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    // Line Chart 그리기
    func drawLineChart(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText = "No Data"
        lineChartView.noDataFont = .systemFont(ofSize: 20)
        lineChartView.noDataTextColor = .systemGray2
        
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
        lineChartView.data = chartData
        
        // 탭, 드래그, 줌 가능 여부 설정
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
        
        // X축 레이블 위치 및 포맷 설정
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // X축 레이블 갯수 최대로 설정 (이 코드 안쓸 시 Jan Mar May 이런식으로 띄엄띄엄 조금만 나옴)
        //balanceChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        
        // 옵션 애니메이션
        //lineChartView.animate(xAxisDuration: 0, yAxisDuration: 1.5, easingOption: .linear)
        
        // 왼쪽 축의 범위 설정
        lineChartView.leftAxis.axisMaximum = 30
        lineChartView.leftAxis.axisMinimum = 0
        
        let xAxis = lineChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.granularity = 1
        xAxis.axisLineColor = .label
        
        let yAxisLeft = lineChartView.leftAxis
        yAxisLeft.enabled = true
        yAxisLeft.drawGridLinesEnabled = false
        yAxisLeft.labelFont = .systemFont(ofSize: 12, weight: .light)
        yAxisLeft.granularity = 10
        yAxisLeft.axisLineColor = .label
        
        let yAxisRight = lineChartView.rightAxis
        yAxisRight.enabled = false
        yAxisRight.drawGridLinesEnabled = false
        yAxisRight.drawLabelsEnabled = false
        
        let legend = lineChartView.legend
        legend.enabled = false
        legend.horizontalAlignment = .center
        legend.yOffset = 30
    }
    
    // Cell 업데이트
    func prepareGraph(title: String?) {
        self.itemLabel.text = title
        //self.graphImage.image = graph
        
        let months = ["Buy\n(Start)", "", "Buy\n(End)", "", "", "", "", "Sell"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0]
        
        drawLineChart(dataPoints: months, values: unitsSold)  // CalcResultViewController에서 실행
    }
}
