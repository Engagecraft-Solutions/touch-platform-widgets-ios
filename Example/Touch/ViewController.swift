//
//  ViewController.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import UIKit
import Touch

// just a random demo widget id
var TESTWIDGETID = "1-rIsP03ohz9XSpJu" //  "6-TgT3YNQYQOoAgsI" // "3-6euu689BaosNXhH" //

internal class ViewController: UIViewController {

    private let widget = Widget(TESTWIDGETID,location: "EngageCraft.cocoapods.demo.Touch-Example://")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        widget.add(to: self)
    }
}

