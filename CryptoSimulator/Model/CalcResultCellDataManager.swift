//
//  CalcResultCellDataManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit

final class CalcResultCellDataManager {
    
    // 싱글톤으로 만들기
    static let shared = CalcResultCellDataManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}

    //MARK: - data 정의
    
    private var statsModelLSI = [
        StatsModel(icon: UIImage(systemName: "bitcoinsign.circle"), title: "Coin", value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: "Purchase Date", value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: "Sell Date", value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: "Hold Time", value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: "Total Invested", value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: "Total Exit", value: nil),
        StatsModel(icon: UIImage(systemName: "plus.forwardslash.minus"), title: "Profit\n(ROI)", value: nil),
    ]
    
    private var statsModelDCA = [
        StatsModel(icon: UIImage(systemName: "bitcoinsign.circle"), title: "Coin", value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: "First Purchase Date", value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: "Last Purchase Date", value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: "Sell Date", value: nil),
        StatsModel(icon: UIImage(systemName: "arrow.clockwise"), title: "Repeat Purchase", value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: "Purchase Time", value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: "Hold Time", value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: "Total Invested", value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: "Total Exit", value: nil),
        StatsModel(icon: UIImage(systemName: "plus.forwardslash.minus"), title: "Profit\n(ROI)", value: nil),
    ]
    
    private var graphModel = [
        GraphModel(title: "Coin Price ($)"),
        GraphModel(title: "Total Invested ($)"),
        GraphModel(title: "ROI (%)"),
    ]

    //MARK: - 메서드 정의
    
    func getStatsDataLSI() -> CalcResultCellData {
        return CalcResultCellData.stats(statsModelLSI)
    }
    
    func getStatsDataDCA() -> CalcResultCellData {
        return CalcResultCellData.stats(statsModelDCA)
    }
    
    func updateStatsDataLSI(index: Int, newValue: String?) {
        guard let newValue = newValue else { return }
        statsModelLSI[index].value = newValue
    }
    
    func updateStatsDataDCA(index: Int, newValue: String?) {
        guard let newValue = newValue else { return }
        statsModelDCA[index].value = newValue
    }
    
    func getGraphData() -> CalcResultCellData {
        return CalcResultCellData.graph(graphModel)
    }
    
}
