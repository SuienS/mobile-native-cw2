//
//  GraphicalDetailsViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-20.
//

import UIKit

class GraphicalDetailsViewController: UIViewController {
    @IBOutlet weak var labelExCategory: UILabel!
    @IBOutlet var viewGraphics: UIView!
    var expenseCategory = ""
    var category: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelExCategory.text = expenseCategory
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        buildPieChart(with: [50,10,10,30,30,12.5,20.3], on: viewGraphics, arcCenter: viewGraphics.center)
        
    }

    
    func buildPieChart(with inData:[Float], on inView:UIView, arcCenter: CGPoint){
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
    
    
}

