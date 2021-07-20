//
//  CalendarInstructionVC.swift
//  SmartCleaner
//
//  Created by Alyona Sabitskaya  on 16.07.2021.
//  Copyright © 2021 Luchik. All rights reserved.
//
import UIKit

class CalendarInstructionVC: UIViewController {
    
    let rootView = CalendarInstructionView()
    
    override func loadView() {
        self.view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.backAction = {
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.navbar.setAttributedTitle(title: "Clean up stubborn spam")
        rootView.navbar.setShadow()
    }



}
