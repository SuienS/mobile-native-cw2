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

        // Do any additional setup after loading the view.
    }
    

    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
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
