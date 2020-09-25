//
//  Star.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/24/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class Star: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        let path = createPath()
        let scale = CGAffineTransform(scaleX: 4, y: 4)
        path.apply(scale)
        
        // fill
        let fillColor = UIColor.yellow
        fillColor.setFill()

        // stroke
        path.lineWidth = 0.9
        let strokeColor = UIColor.blue
        strokeColor.setStroke()
        
        // Move the path to a new location
        //path.apply(CGAffineTransform(translationX: 4, y: 4))

        // fill and stroke the path (always do these last)
        path.fill()
        path.stroke()
    }
    
    func createPath()  -> UIBezierPath{
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 3, y: 6))
        path.addLine(to: CGPoint(x: 3, y: 6))
        path.addLine(to: CGPoint(x: 3.3, y: 4))
        path.addLine(to: CGPoint(x: 5.5, y: 4))
        path.addLine(to: CGPoint(x: 4, y: 3))
        path.addLine(to: CGPoint(x: 4.5, y: 1))
        path.addLine(to: CGPoint(x: 3, y: 2.2))
        path.addLine(to: CGPoint(x: 1.5, y: 1))
        path.addLine(to: CGPoint(x: 2, y: 3))
        path.addLine(to: CGPoint(x: 0, y: 4))
        path.addLine(to: CGPoint(x: 2.2, y: 4))
        path.close()
        
        return path
    }

}
