//
//  Date.swift
//  DCA Planner
//
//  Created by Eric on 2022/12/29.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: self)
    }
        
}
