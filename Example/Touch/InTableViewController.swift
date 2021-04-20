//
//  InTableViewController.swift
//  Touch_Example
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import UIKit
import Touch
class InTableViewController: UITableViewController {

    let demoCells = ["cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell","cell",
                     "cell","cell","cell", WidgetTableViewCell.identifier, "cell","cell","cell","cell","cell","cell","cell","cell","cell","cell"]
    
    var widgetCell: WidgetTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        WidgetTableViewCell.register(on: tableView)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return demoCells.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = demoCells[indexPath.row]
        guard identifier == WidgetTableViewCell.identifier  else {
            return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
        guard widgetCell == nil else {
            return widgetCell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WidgetTableViewCell
        cell.setup(widgetId: TESTWIDGETID, location: "EngageCraft.cocoapods.demo.Touch-Example://", on: tableView)
        widgetCell = cell
        return cell
    }

}
