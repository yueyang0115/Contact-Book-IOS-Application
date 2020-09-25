//
//  Rocket.swift
//  ECE564_HW
//
//  Created by 杨越 on 9/25/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class Rocket: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let scale = CGAffineTransform(scaleX: 20, y: 20)
        
        let path = createPath()
        path.apply(scale)
        
        let fillColor = UIColor.systemRed
        fillColor.setFill()
        path.lineWidth = 1
        let strokeColor = UIColor.systemRed
        strokeColor.setStroke()
        path.fill()
        path.stroke()
        
        let path2 = createPath2()
        path2.apply(scale)
        
        let fillColor2 = UIColor.white
        fillColor2.setFill()
        path2.lineWidth = 1
        let strokeColor2 = UIColor.white
        strokeColor2.setStroke()
        path2.fill()
        path2.stroke()
        
        let path3 = createPath3()
        path3.apply(scale)
        
        let fillColor3 = UIColor.red
        fillColor3.setFill()
        path3.lineWidth = 1
        let strokeColor3 = UIColor.red
        strokeColor3.setStroke()
        path3.fill()
        path3.stroke()
        
        let path4 = createPath4()
        path4.apply(scale)
        
        let fillColor4 = UIColor.red
        fillColor4.setFill()
        path4.lineWidth = 1
        let strokeColor4 = UIColor.red
        strokeColor4.setStroke()
        path4.fill()
        path4.stroke()
        
        let path5 = createPath5()
        path5.apply(scale)
        
        let fillColor5 = UIColor.red
        fillColor5.setFill()
        path5.lineWidth = 4
        let strokeColor5 = UIColor.red
        strokeColor5.setStroke()
        path5.fill()
        path5.stroke()
        
        let path6 = createPath6()
        path6.apply(scale)
        
        let fillColor6 = UIColor.red
        fillColor6.setFill()
        path6.lineWidth = 4
        let strokeColor6 = UIColor.red
        strokeColor6.setStroke()
        path6.fill()
        path6.stroke()
    }
        
    func createPath()  -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 3, y: 0.5))
        path.addCurve(to: CGPoint(x: 4.5, y: 3),
                      controlPoint1: CGPoint(x: 3, y: 0.8),
                      controlPoint2: CGPoint(x: 4.5, y: 0.8))
        path.addLine(to: CGPoint(x: 1.5, y: 3))
        path.addCurve(to: CGPoint(x: 3, y: 0.5),
                      controlPoint1: CGPoint(x: 1.5, y: 0.8),
                      controlPoint2: CGPoint(x: 3, y: 0.8))
        path.close()
        return path
    }
    
    func createPath2() -> UIBezierPath{
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 1.5, y: 3))
        path2.addLine(to: CGPoint(x: 4.5, y: 3))
        path2.addCurve(to: CGPoint(x: 4.2, y: 7),
                       controlPoint1: CGPoint(x: 4.6, y: 4.6),
                       controlPoint2: CGPoint(x: 4.8, y: 4.6))
        path2.addLine(to: CGPoint(x: 1.8, y: 7))
        path2.addCurve(to: CGPoint(x: 1.5, y: 3),
                       controlPoint1: CGPoint(x: 1.2, y: 4.6),
                       controlPoint2: CGPoint(x: 1.4, y: 4.6))
        path2.close()
        return path2
    }
    
    func createPath3() -> UIBezierPath{
        let path3 = UIBezierPath()
        path3.move(to: CGPoint(x: 4.6, y: 4.6))
        path3.addCurve(to: CGPoint(x: 5.7, y: 6.5),
                       controlPoint1: CGPoint(x: 5, y: 5),
                       controlPoint2: CGPoint(x: 6, y: 5))
        path3.addLine(to: CGPoint(x: 4.2, y: 4.8))
        path3.close()
        return path3
    }
    
    func createPath4() -> UIBezierPath{
        let path4 = UIBezierPath()
        path4.move(to: CGPoint(x: 1.4, y: 4.6))
        path4.addCurve(to: CGPoint(x: 0.3, y: 6.5),
                       controlPoint1: CGPoint(x: 1, y: 5),
                       controlPoint2: CGPoint(x: 0, y: 5))
        path4.addLine(to: CGPoint(x: 1.8, y: 4.8))
        path4.close()
        return path4
    }
    
    func createPath5() -> UIBezierPath{
        let path5 = UIBezierPath()
        path5.move(to: CGPoint(x: 2.5, y: 7.5))
        path5.addLine(to: CGPoint(x: 2, y: 9))
        path5.close()
        return path5
    }
    
    func createPath6() -> UIBezierPath{
        let path6 = UIBezierPath()
        path6.move(to: CGPoint(x: 3.5, y: 7.5))
        path6.addLine(to: CGPoint(x: 4, y: 9))
        path6.close()
        return path6
    }
}
