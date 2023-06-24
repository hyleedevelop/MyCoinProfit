//
//  GraphCell.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit
import Charts

final class GraphCell: UITableViewCell {

    //MARK: - UI
    
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
        
    //MARK: - 생성자
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
 
        self.setupUI()
        self.setupChart()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 하위 뷰 등록 및 오토레이아웃
    
    // 레이블
    private func setupUI() {
        self.addSubview(self.itemLabel)
        
        NSLayoutConstraint.activate([
            self.itemLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            self.itemLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.itemLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    // 차트
    func setupChart() {
        self.addSubview(self.lineChartView)
        
        NSLayoutConstraint.activate([
            self.lineChartView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.lineChartView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            self.lineChartView.topAnchor.constraint(equalTo: self.itemLabel.bottomAnchor, constant: 0),
            self.lineChartView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
    
    //MARK: - 차트 그리기
    
    func drawLineChart(segment: Int, mode: Int, values: [Double]) {
        self.lineChartView.noDataText = "No Data"
        self.lineChartView.noDataFont = .systemFont(ofSize: 20)
        self.lineChartView.noDataTextColor = .systemGray2
        
        // 데이터 생성
        var dataEntries = [ChartDataEntry]()
        var dataPoints = [String]()
        for (index, value) in values.enumerated() {
            let dataEntry = BarChartDataEntry(x: Double(index), y: value)
            dataEntries.append(dataEntry)
            dataPoints.append("")
        }
        
        var myColor: UIColor {
            // 앱의 테마 컬러 설정 가져오기
            let themeIndex = UserDefaults.standard.integer(
                forKey: Constant.UserDefaults.themeColorNumber
            )
            
            var color: UIColor!
            switch mode {
            case 0: color = Constant.UIColorSetting.themeGradientStartColors[themeIndex]
            case 1: color = Constant.UIColorSetting.themeGradientMiddleColors[themeIndex]
            case 2: color = Constant.UIColorSetting.themeGradientEndColors[themeIndex]
            default: break
            }
            
            return color
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "chart")
        chartDataSet.mode = .linear
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 1.5
        chartDataSet.colors = [myColor]
        chartDataSet.fill = ColorFill(color: myColor)
        chartDataSet.fillAlpha = 0.5
        chartDataSet.drawFilledEnabled = true
        chartDataSet.highlightEnabled = true
        chartDataSet.highlightColor = .systemGray2
        chartDataSet.highlightLineWidth = 1.0
        chartDataSet.highlightLineDashLengths = [2, 1]
        
        // 데이터 삽입
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        lineChartView.data = chartData
        
        // 탭, 드래그, 줌 가능 여부 설정
        lineChartView.highlightPerTapEnabled = true
        lineChartView.highlightPerDragEnabled = true
        lineChartView.doubleTapToZoomEnabled = true
        
        // X축 레이블 위치 및 포맷 설정
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // 왼쪽 축의 범위 설정
        if mode == 0 { lineChartView.leftAxis.axisMinimum = 0.0 }
        
        let xAxis = lineChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.granularity = 0
        xAxis.axisLineColor = .label
        
        let yAxisLeft = lineChartView.leftAxis
        yAxisLeft.enabled = true
        yAxisLeft.drawGridLinesEnabled = false
        yAxisLeft.drawLabelsEnabled = true
        yAxisLeft.labelFont = .systemFont(ofSize: 12, weight: .light)
        yAxisLeft.granularity = 0
        yAxisLeft.axisLineColor = .label
        if mode == 2 {
            yAxisLeft.drawZeroLineEnabled = true
            yAxisLeft.zeroLineDashLengths = [2, 3]
            yAxisLeft.zeroLineColor = .label
        } else {
            yAxisLeft.drawZeroLineEnabled = false
        }
        
        let yAxisRight = lineChartView.rightAxis
        yAxisRight.enabled = false
        yAxisRight.drawGridLinesEnabled = false
        yAxisRight.drawLabelsEnabled = false
        
        let legend = lineChartView.legend
        legend.enabled = false
        legend.horizontalAlignment = .center
        legend.yOffset = 30
    }
    
    //MARK: - 셀 내용 업데이트
    
    func prepareGraph(segment: Int, mode: Int, title: String?, data: [Double]) {
        self.itemLabel.text = title
        self.drawLineChart(segment: segment, mode: mode, values: data)
    }
    
}
