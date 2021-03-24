//
//  InViewViewController.swift
//  Touch_Example
//
//  Created by Aurimas Petrevicius on 2021-03-24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import Touch

class InViewViewController: UIViewController {

    private let widget = Widget(with: "1-TusnfgQuklK4O8n")
    
    @IBOutlet weak var inView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        widget.add(to: self, on: inView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        widget.refresh()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
