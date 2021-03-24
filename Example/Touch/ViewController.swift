//
//  ViewController.swift
//  Touch
//
//  Created by Aurimas Petrevicius on 03/23/2021.
//  Copyright (c) 2021 Aurimas Petrevicius. All rights reserved.
//

import UIKit
import Touch

class ViewController: UIViewController {

    private let widget = Widget(with: "1-TusnfgQuklK4O8n")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        widget.add(to: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        widget.refresh()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

