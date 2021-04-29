//
//  GraphicCharts.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-29.
//

import UIKit

class SpendAppCustomGraphics: UIView {

    static func buildPieChart(with inData:[Float], on inView:UIView, arcCenter: CGPoint){
        if inData.isEmpty{
            return
        }
        
        var pieLayers: [CAShapeLayer] = []

        
        let total = inData.reduce(0, +)
        
        var startAnglePie = CGFloat(0)
        var endAnglePie = CGFloat(0)
        

        for i in (0..<inData.count) {
            let pieChartLayer = CAShapeLayer()
            
            let newAngle = (2 * CGFloat.pi) * CGFloat(inData[i]/total)
            
            endAnglePie = startAnglePie + newAngle
            
            
            print("Start: \(startAnglePie) | End: \(endAnglePie)"  )

            let pieChartPath = UIBezierPath(arcCenter: arcCenter, radius: 175, startAngle: startAnglePie, endAngle: endAnglePie, clockwise: true)
            
            pieChartLayer.path = pieChartPath.cgPath
            
            pieChartLayer.fillColor = nil
            
            let colArray = [UIColor.systemTeal.cgColor,UIColor.systemBlue.cgColor,UIColor.systemGreen.cgColor, UIColor.systemRed.cgColor]
            pieChartLayer.strokeColor = colArray[i % colArray.count]
            pieChartLayer.lineWidth = 35
            
            pieChartLayer.lineCap = .round
            pieChartLayer.shadowRadius = 10.0
            pieChartLayer.shadowColor = UIColor.gray.cgColor
            pieChartLayer.shadowOpacity = 1.0
            
            pieChartLayer.strokeEnd = 0
            
            inView.layer.addSublayer(pieChartLayer)
            
            pieLayers.append(pieChartLayer)

            startAnglePie = endAnglePie

        }
        for pieLayer in pieLayers {
            let animationPie = CABasicAnimation(keyPath: "strokeEnd")
            animationPie.toValue = 1
            animationPie.duration = 1.5
            animationPie.fillMode = .forwards
            animationPie.isRemovedOnCompletion = false
            
            pieLayer.add(animationPie, forKey: nil)
        }
        
    }
    
    static func buildBarChart(with inData:[Float], on inView:UIView, origin: CGPoint, colour: UIColor) {
        if(inData.count != 2){
            return
        }
        
        let animationBar = CABasicAnimation(keyPath: "path")
        
        // Background Bar
        let barChartLayerBack = CAShapeLayer()

        let barChartPathBack = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * 0.01, height: inView.frame.height/2)), cornerRadius: 10)
        
        barChartLayerBack.path = barChartPathBack.cgPath
        
        barChartLayerBack.fillColor = UIColor.systemGray4.cgColor
        barChartLayerBack.shadowRadius = 5.0
        barChartLayerBack.shadowColor = UIColor.systemGray.cgColor
        barChartLayerBack.shadowOpacity = 1.0

        inView.layer.addSublayer(barChartLayerBack)
        
        
        animationBar.toValue = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width, height: inView.frame.height/2)), cornerRadius: 10).cgPath
        animationBar.duration = 1.5
        animationBar.fillMode = .forwards
        animationBar.isRemovedOnCompletion = false
        barChartLayerBack.add(animationBar, forKey: nil)
        
        
        // Filling Bar
        let barChartLayer = CAShapeLayer()

        let barChartPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * 0.01, height: inView.frame.height/2)), cornerRadius: 10)
        
        barChartLayer.path = barChartPath.cgPath
        
        barChartLayer.fillColor = colour.cgColor
        barChartLayer.shadowRadius = 5.0
        barChartLayer.shadowColor = UIColor.gray.cgColor
        barChartLayer.shadowOpacity = 1.0

        inView.layer.addSublayer(barChartLayer)
        
        animationBar.toValue = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * CGFloat((inData[0]/inData[1])), height: inView.frame.height/2)), cornerRadius: 10).cgPath
        animationBar.duration = 1.5
        animationBar.fillMode = .forwards
        animationBar.isRemovedOnCompletion = false

        barChartLayer.add(animationBar, forKey: nil)
    }


}
