//
//  SpendAppUtils.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-04-18.
//
// This file will contain all the utility Methods for the app

import Foundation
import UIKit


class SpendAppUtils {
    static var managedAppObjContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var managedAppObj = (UIApplication.shared.delegate as! AppDelegate)
    
    static var colourAlpha = CGFloat(0.3)
    
    static let colourCodes = ["Green":
                                UIColor.systemGreen.withAlphaComponent(colourAlpha),
                              "Blue":
                                UIColor.systemBlue.withAlphaComponent(colourAlpha),
                              "Yellow": UIColor.systemYellow.withAlphaComponent(colourAlpha),
                              "Pink": UIColor.systemPink.withAlphaComponent(colourAlpha),
                              "Purple": UIColor.systemPurple.withAlphaComponent(colourAlpha),
                              "Teal": UIColor.systemTeal.withAlphaComponent(colourAlpha),
                              "DEFAULT": UIColor.systemGray6,
                              "SELECTED": UIColor.systemBlue.withAlphaComponent(0.1)] as [String : UIColor]
    
    static let colourCodesIndex = ["Green": 0,
                              "Blue": 1,
                              "Yellow":2,
                              "Pink":3,
                              "Purple":4,
                              "Teal":5] as [String : Int]
    
    
    static let NSDecimalFormatter = NumberFormatter()
    
    static func getCodeColour(_ strColour: String) -> UIColor{
        
        switch strColour {
        case "Green":
            return colourCodes[strColour]!
        case "Blue":
            return colourCodes[strColour]!
        case "Yellow":
            return colourCodes[strColour]!
        case "Pink":
            return colourCodes[strColour]!
        case "Purple":
            return colourCodes[strColour]!
        case "Teal":
            return colourCodes[strColour]!
        case "SELECTED":
            return colourCodes[strColour]!
        default:
            return colourCodes["DEFAULT"]!
        }
        
    }
    
    static func toNSDecimal(_ string: String) -> NSDecimalNumber {
        NSDecimalFormatter.generatesDecimalNumbers = true
        return NSDecimalFormatter.number(from: string) as? NSDecimalNumber ?? 0
    }
}


extension UIView {
    func fadeUpdateTransition(_ animDuration:CFTimeInterval) {
        let updateAnimation = CATransition()
        updateAnimation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        updateAnimation.type = CATransitionType.fade
        updateAnimation.duration = animDuration
        layer.add(updateAnimation, forKey: CATransitionType.fade.rawValue)
    }
}



