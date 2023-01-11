//
//  DelegateProtocol.swift
//  DCA Planner
//
//  Created by Eric on 2023/01/11.
//

import Foundation

protocol CalcResultDelegate {
    func receiveData(with data: (Double, Double, Double, Double))
}
