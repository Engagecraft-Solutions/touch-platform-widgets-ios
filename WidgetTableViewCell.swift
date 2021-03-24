//
//  WidgetTableViewCell.swift
//  Touch
//
//  Created by Aurimas Petrevicius on 2021-03-24.
//

import UIKit

public class WidgetTableViewCell: UITableViewCell {
    
    public static let identifier = "widgetcell"
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
    
    public func setup(with widgetId:String){
        widget = Widget(with: widgetId)
        widget.autoResize = false
        widget.add(to: nil, on: contentView)
        widget.refresh()
    }

    public func refresh(){
        widget.refresh()
    }
    
}

