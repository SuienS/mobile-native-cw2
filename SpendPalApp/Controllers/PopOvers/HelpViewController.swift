/**
 Author      : Rammuni Ravidu Suien Silva
 UoW No   : 16267097 || IIT No: 2016134
 Mobile Native Development - Coursework 2
 */

//
//  HelpViewController.swift
//  SpendPalApp
//
//  Created by Rammuni Ravidu Suien Silva on 2021-05-10.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func setttingsButtonPressed(_ sender: UIButton) {
        // Directs to the main "Settings" App's relavant sub-section
        if let settingsPagePATH = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            if UIApplication.shared.canOpenURL(settingsPagePATH) {
                UIApplication.shared.open(settingsPagePATH)
            }
        }
    }

}
