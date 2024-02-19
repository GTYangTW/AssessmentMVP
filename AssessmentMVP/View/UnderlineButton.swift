//
//  UnderlineButton.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/17.
//

import Foundation
import UIKit

// 正常，但沒啟用
class UnderlinedButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let titleLabel = titleLabel {
            let textRect = titleLabel.frame
            
            // 設置底線的位置
            let lineY = textRect.origin.y + textRect.size.height
            let lineWidth = textRect.size.width
            
            // 繪製底線
            let context = UIGraphicsGetCurrentContext()
            context?.setStrokeColor(UIColor.white.cgColor)
            context?.setLineWidth(1.0)
            context?.move(to: CGPoint(x: textRect.origin.x, y: lineY))
            context?.addLine(to: CGPoint(x: textRect.origin.x + lineWidth, y: lineY))
            context?.strokePath()
        }
    }
}
