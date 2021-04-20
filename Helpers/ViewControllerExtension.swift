//
//  ViewControllerExtension.swift
//  Widgets
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
	func add(widget child: Widget, toView: UIView? = nil) {
		let v: UIView = toView ?? view
        child.add(to:self,on:v)
	}
	
	func remove() {
		// Just to be safe, we check that this view controller
		// is actually added to a parent before removing it.
		guard parent != nil else {
			return
		}
		
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
