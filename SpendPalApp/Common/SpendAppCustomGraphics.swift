//
//  GraphicCharts.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-29.
//

import UIKit

class SpendAppCustomGraphics: UIView {
    static let colArray = [UIColor.systemTeal.cgColor,UIColor.systemBlue.cgColor,UIColor.systemGreen.cgColor, UIColor.systemRed.cgColor,UIColor.systemPurple.cgColor]
    
    static func buildPieChartReduced(reduction:Int, with inData:[Float], on inView:UIView, arcCenter: CGPoint){
        let inDataSorted = Array(inData.sorted().reversed())
        
        var processedData: [Float] = []
        
        if inDataSorted.count > reduction {
            processedData = Array(inDataSorted[0 ..< reduction])
            let sumLast = Array(inDataSorted[reduction ..< inDataSorted.count]).reduce(0, +)
            processedData.append(sumLast)

        }else{
            processedData = inDataSorted
        }
        
        print(processedData)
        
        buildPieChart(with: processedData, on: inView, arcCenter: arcCenter)
    }
    

    static func buildPieChart(with inData:[Float], on inView:UIView, arcCenter: CGPoint){
        if inData.isEmpty{
            return
        }
                
        let pieChartLayerBack = CAShapeLayer()

        let pieChartPathBack = UIBezierPath(arcCenter: arcCenter, radius: 175, startAngle: 0, endAngle: (2 * CGFloat.pi), clockwise: true)
        
        pieChartLayerBack.path = pieChartPathBack.cgPath
        
        pieChartLayerBack.fillColor = nil
        
        pieChartLayerBack.strokeColor = UIColor.systemGray4.cgColor
        pieChartLayerBack.lineWidth = 35
        
        pieChartLayerBack.lineCap = .round
        pieChartLayerBack.shadowRadius = 5.0
        pieChartLayerBack.shadowColor = UIColor.systemGray.cgColor
        pieChartLayerBack.shadowOpacity = 1.0
        
        
        inView.layer.addSublayer(pieChartLayerBack)
        
        
        
        var pieLayers: [CAShapeLayer] = []

        
        let total = inData.reduce(0, +)
        
        var startAnglePie = CGFloat(0)
        var endAnglePie = CGFloat(0)
        

        for i in (0..<inData.count) {
            let pieChartLayer = CAShapeLayer()
            
            let newAngle = (2 * CGFloat.pi) * CGFloat(inData[i]/total)
            
            endAnglePie = startAnglePie + newAngle

            let pieChartPath = UIBezierPath(arcCenter: arcCenter, radius: 175, startAngle: startAnglePie, endAngle: endAnglePie, clockwise: true)
            
            pieChartLayer.path = pieChartPath.cgPath
            
            pieChartLayer.fillColor = nil
            

            pieChartLayer.strokeColor = getChartColour(index: i)
            pieChartLayer.lineWidth = 35
            
            pieChartLayer.lineCap = .round
            pieChartLayer.shadowRadius = 10.0
            pieChartLayer.shadowColor = UIColor.systemGray.cgColor
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
        
        
        // Background Bar
        let barChartLayerBack = CAShapeLayer()

        let barChartPathBack = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width, height: inView.frame.height/2)), cornerRadius: 10)
        
        barChartLayerBack.path = barChartPathBack.cgPath
        
        barChartLayerBack.fillColor = UIColor.systemGray4.cgColor
        barChartLayerBack.shadowRadius = 5.0
        barChartLayerBack.shadowColor = UIColor.systemGray.cgColor
        barChartLayerBack.shadowOpacity = 1.0

        inView.layer.addSublayer(barChartLayerBack)
    
        
        
        // Filling Bar
        let barChartLayer = CAShapeLayer()

        let barChartPath = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * 0.01, height: inView.frame.height/2)), cornerRadius: 10)
        
        barChartLayer.path = barChartPath.cgPath
        
        barChartLayer.fillColor = colour.cgColor
        barChartLayer.shadowRadius = 5.0
        barChartLayer.shadowColor = UIColor.gray.cgColor
        barChartLayer.shadowOpacity = 1.0

        inView.layer.addSublayer(barChartLayer)
        
        let animationBar = CABasicAnimation(keyPath: "path")
        animationBar.toValue = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * CGFloat((inData[0]/inData[1])), height: inView.frame.height/2)), cornerRadius: 10).cgPath
        animationBar.duration = 1
        animationBar.fillMode = .forwards
        animationBar.isRemovedOnCompletion = false

        barChartLayer.add(animationBar, forKey: nil)
    }
    
    static func getChartColour(index: Int) -> CGColor{
        if(index < colArray.count){
            return colArray[index  % colArray.count]
        }else{
            return colArray[colArray.count - 1]
        }
    }


}
