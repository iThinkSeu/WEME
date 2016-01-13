//
//  Discover.swift
//  WEME
//
//  Created by liewli on 2016-01-12.
//  Copyright © 2016 li liew. All rights reserved.
//

import UIKit
import Persei
import Charts

class DiscoverVC:UITableViewController{
    private var menu:MenuView!
    
    private let sections = ["好友", "美食", "附近"]
    private let icons = ["ic-big-hospitals", "ic-big-suits", "ic-big-shoes"]
    private let colors = [UIColor.colorFromRGB(0xd7e5e7), UIColor.colorFromRGB(0xc5d1b9), UIColor.colorFromRGB(0xe7e9e3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "发现"
        view.backgroundColor = BACK_COLOR
        loadMenu()
        tableView.registerClass(DiscoverTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(DiscoverTableViewCell))
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.separatorStyle = .None
        
        automaticallyAdjustsScrollViewInsets = false
    
    }
    
    private func loadMenu() {
        let menu = MenuView()
        menu.delegate = self
        menu.items = items
       // menu.backgroundColor = BACK_COLOR
        tableView.addSubview(menu)
        
        self.menu = menu
    }
    
    private lazy var items: [MenuItem] =  {
        var items = [MenuItem]()
        for i in 0..<3 {
            var menu1 = MenuItem(image: UIImage(named: "menu_icon_\(i)")!)
//            menu1.backgroundColor = BACK_COLOR
            menu1.highlightedBackgroundColor = THEME_COLOR
//            menu1.shadowColor = BACK_COLOR
            items.append(menu1)
        }
        return items
        }()
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(DiscoverTableViewCell), forIndexPath: indexPath) as! DiscoverTableViewCell
        cell.icon.image = UIImage(named: icons[indexPath.row])?.imageWithRenderingMode(.AlwaysTemplate)
        cell.icon.tintColor = UIColor(red: 51 / 255, green: 51 / 255, blue: 76 / 255, alpha: 1)

        cell.contentView.backgroundColor = BACK_COLOR//UIColor.whiteColor()//UIColor(red: 51 / 255, green: 51 / 255, blue: 76 / 255, alpha: 1)
//ChartColorTemplates.joyful()[indexPath.section]//colors[indexPath.section]
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let v = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 10))
//        v.backgroundColor = UIColor.whiteColor()
//        return v
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
}

class DiscoverTableViewCell:UITableViewCell {
    
    private var icon:UIImageView!
    
    func initialize() {
        icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
        
        icon.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp_centerX)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.height.equalTo(120)
        }
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension DiscoverVC:MenuViewDelegate {
    func menu(menu: MenuView, didSelectItemAtIndex index: Int) {
        
    }
}
