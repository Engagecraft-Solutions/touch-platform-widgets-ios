//
//  InViewViewController.swift
//  Touch_Example
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import UIKit
import Touch

class InViewViewController: UIViewController {

    private let widget = Widget(TESTWIDGETID,location: "EngageCraft.cocoapods.demo.Touch-Example://")
    
    @IBOutlet weak var inView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        widget.add(to: self, on: inView)
    }
    
    @IBAction func setUIDAction(_ sender: Any) {
        // Testing: set logged in user id
        //Touch.shared.login(userId: "123456")
    }
    
}
