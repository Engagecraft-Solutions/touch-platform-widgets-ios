//
//  WidgetTableViewCell.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import UIKit

public class WidgetTableViewCell: UITableViewCell {
    
    public static let identifier = "widgetcell"
    weak private var tableView: UITableView?
    
    public static func register(on tableView: UITableView){
        tableView.register(Self.self, forCellReuseIdentifier: WidgetTableViewCell.identifier)
    }
    
    private var widget: Widget!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented. Use widget(id)")
    }
    
    public func setup(widgetId:String, location: String, on tableView: UITableView? = nil){
        widget = Widget(widgetId, location: location)
        self.tableView = tableView
        widget.onLoaded = { [weak self] height in
            guard let strongSelf = self else {return}
            if let path = self?.tableView?.indexPath(for: strongSelf) {
                strongSelf.tableView?.reloadRows(at: [path], with: .automatic)
            }
        }
        widget.add(to: nil, on: contentView)
        refresh()
    }

    public func refresh(){
        widget.refresh()
    }
    
}

