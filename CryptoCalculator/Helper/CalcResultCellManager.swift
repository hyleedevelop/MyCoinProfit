//
//  CalcResultCellDataManager.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/25.
//

import UIKit

final class CalcResultCellManager {
    
    // 싱글톤으로 만들기
    static let shared = CalcResultCellManager()
    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}

    //MARK: - data 정의
    
    private var statsModelLSI = [
        StatsModel(icon: UIImage(systemName: "bitcoinsign.circle"), title: LocalizedStringKey.coin.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: LocalizedStringKey.purchaseDate.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: LocalizedStringKey.sellDate.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: LocalizedStringKey.holdTime.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: LocalizedStringKey.totalInvested.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: LocalizedStringKey.totalExit.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "plus.forwardslash.minus"), title: LocalizedStringKey.profitROI.localize, value: nil),
    ]
    
    private var statsModelDCA = [
        StatsModel(icon: UIImage(systemName: "bitcoinsign.circle"), title: LocalizedStringKey.coin.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: LocalizedStringKey.firstPurchaseDate.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: LocalizedStringKey.lastPurchaseDate.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "calendar"), title: LocalizedStringKey.sellDate.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "arrow.clockwise"), title: LocalizedStringKey.repeatPurchase.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: LocalizedStringKey.purchaseTime.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "timer"), title: LocalizedStringKey.holdTime.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: LocalizedStringKey.totalInvested.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "dollarsign.circle"), title: LocalizedStringKey.totalExit.localize, value: nil),
        StatsModel(icon: UIImage(systemName: "plus.forwardslash.minus"), title: LocalizedStringKey.profitROI.localize, value: nil),
    ]
    
    private var graphModel = [
        GraphModel(title: LocalizedStringKey.graphTotalInvested.localize),
        GraphModel(title: LocalizedStringKey.graphCoinPrice.localize),
        GraphModel(title: LocalizedStringKey.graphROI.localize),
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
