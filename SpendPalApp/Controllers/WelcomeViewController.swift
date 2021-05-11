/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 
 File Desc: ViewController for Welcome Page
 */
//
//  WelcomeViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-05-07.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            
            // Setting the profile accordigly
            switch segueId {
            case "toSplitViewFromProf_1":
                SpendAppUtils.profile = "Profile_1"
  
            case "toSplitViewFromProf_2":
                SpendAppUtils.profile = "Profile_2"

            case "toSplitViewFromProf_3":
                SpendAppUtils.profile = "Profile_3"

            default:
                break
            }
             
        }
    }
}
