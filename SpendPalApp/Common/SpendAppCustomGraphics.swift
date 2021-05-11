/**
 Author       : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: This file will contain all the Graphic Elements' logics
 */
//
//  GraphicCharts.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-29.
//

import UIKit

class SpendAppCustomGraphics: UIView {
    
    // Colour set for pie chart
    static let colArray = [UIColor.systemGreen.cgColor,UIColor.systemTeal.cgColor,UIColor.systemBlue.cgColor,UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor,UIColor.systemGray.cgColor]
    
    // MARK: - Custom Pie Chart
    
    // Reduced pie chart into [reduction + 1] segements
    static func buildPieChartReduced(reduction:Int, with inData:[Float], on inView:UIView, arcCenter: CGPoint){
        let inDataSorted = Array(inData[1 ..< inData.count].sorted().reversed())
        print(inDataSorted)
        var processedData: [Float] = []
        
        // Reducing data
        if inDataSorted.count > reduction {
            processedData = Array(inDataSorted[0 ..< reduction])
            let sumLast = Array(inDataSorted[reduction ..< inDataSorted.count]).reduce(0, +)
            processedData.append(sumLast)

        }else{
            processedData = inDataSorted
        }
        processedData.insert(inData[0], at: 0)
        print(processedData)
        
        buildPieChart(with: processedData, on: inView, arcCenter: arcCenter)
    }
    

    // Custom Pie chart build function
    static func buildPieChart(with inData:[Float], on inView:UIView, arcCenter: CGPoint){
        if inData.isEmpty{
            return
        }
        
        // Base CAShapeLayer
        let pieChartLayerBack = CAShapeLayer()

        // Circular BezierPath
        let pieChartPathBack = UIBezierPath(arcCenter: arcCenter, radius: 175, startAngle: 0, endAngle: (2 * CGFloat.pi), clockwise: true)
        
        // Appearence adjustments
        pieChartLayerBack.path = pieChartPathBack.cgPath
        pieChartLayerBack.fillColor = nil
        pieChartLayerBack.strokeColor = UIColor.systemGray4.cgColor
        pieChartLayerBack.lineWidth = 35
        pieChartLayerBack.lineCap = .round
        pieChartLayerBack.shadowRadius = 5.0
        pieChartLayerBack.shadowColor = UIColor.systemGray.cgColor
        pieChartLayerBack.shadowOpacity = 1.0
        
        // Laying out the main layer
        inView.layer.addSublayer(pieChartLayerBack)
        
        // Array for holding the data representing segments
        var pieLayers: [CAShapeLayer] = []

        let total = inData.reduce(0, +)
        
        var startAnglePie = CGFloat(0)
        var endAnglePie = CGFloat(0)
        
        // Loop for generating circular shapes representing the contribution from each expense
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
            pieChartLayer.strokeEnd = 0 // Intially set to zero to allow animation of growing
            
            inView.layer.addSublayer(pieChartLayer)
            pieLayers.append(pieChartLayer)

            startAnglePie = endAnglePie
        }
        
        // Animating the generated layers
        for pieLayer in pieLayers {
            let animationPie = CABasicAnimation(keyPath: "strokeEnd")
            animationPie.toValue = 1
            animationPie.duration = 1.5
            animationPie.fillMode = .forwards
            animationPie.isRemovedOnCompletion = false
            pieLayer.add(animationPie, forKey: nil)
        }
        
    }
    
    
    // MARK: - Custom Bar Chart
    
    // Custom Bar chart build function
    static func buildBarChart(with inData:[Float], on inView:UIView, origin: CGPoint, colour: CGColor) {
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
        barChartLayer.fillColor = colour
        barChartLayer.shadowRadius = 5.0
        barChartLayer.shadowColor = UIColor.gray.cgColor
        barChartLayer.shadowOpacity = 1.0

        inView.layer.addSublayer(barChartLayer)
        
        // Animating
        let animationBar = CABasicAnimation(keyPath: "path")
        animationBar.toValue = UIBezierPath(roundedRect: CGRect(origin: origin, size: CGSize(width: inView.frame.width * CGFloat((inData[0]/inData[1])), height: inView.frame.height/2)), cornerRadius: 10).cgPath
        animationBar.duration = 1
        animationBar.fillMode = .forwards
        animationBar.isRemovedOnCompletion = false

        barChartLayer.add(animationBar, forKey: nil)
    }
    
    
    // MARK: - Support Functions
    
    static func getBarChartColour(index: Int) -> CGColor{
        if((index+1) < colArray.count){
            return colArray[(index+1)]
        }else{
            return colArray[colArray.count - 1]
        }
    }
    
    static func getChartColour(index: Int) -> CGColor{
        if(index < colArray.count){
            return colArray[index]
        }else{
            return colArray[colArray.count - 1]
        }
    }


}

