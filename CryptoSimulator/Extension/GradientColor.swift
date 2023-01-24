//
//  UIView.swift
//  CryptoSimulator
//
//  Created by Eric on 2023/01/20.
//

import UIKit

enum AddOrRemove {
    case add
    case remove
}

extension UIView {
    
    func setViewBackgroundGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func setViewBorderGradient(color1: UIColor, color2: UIColor, mode: AddOrRemove) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        switch mode {
        case .add:
            gradient.mask = shape
            self.layer.insertSublayer(gradient, at: 0)
        case .remove:
            self.layer.sublayers?.remove(at: 0)
        }
    }
    
}

extension UIButton {
    
    func setButtonBackgroundGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
}
