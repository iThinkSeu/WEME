//
//  MeVC.swift
//  牵手东大
//
//  Created by liewli on 12/2/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit


class ProfileVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView:UITableView!
    
    let items = ["好友", "时间轴", "私信"]
    let imgs = ["follow", "activity", "message"]
    var more = ["设置"]
    
    var name:String?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "个人"
        tableView = UITableView(frame: view.frame)
        view.addSubview(tableView)
        tableView.registerClass(MeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MeTableViewCell))
        tableView.registerClass(MeItemTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MeItemTableViewCell))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.colorFromRGB(0xefeff4)
        navigationController?.navigationBar.barStyle = .Black
        
        if #available(iOS 9, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if name == nil {
            fetchNameInfo()
        }
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1.0
    }
    
    
    func fetchNameInfo() {
        if let t = token {
            request(.POST, GET_PROFILE_INFO_URL, parameters: ["token":t], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                if let d = response.result.value,S = self {
                    let json = JSON(d)
                    guard json["state"] == "successful" && json["name"] != .null else{
                        return
                    }
                    
                    S.name = json["name"].stringValue
                    let cell = S.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! MeTableViewCell
                    cell.nameLabel.text = S.name
                }
            }

        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MeTableViewCell), forIndexPath: indexPath) as! MeTableViewCell
            cell.avatar.sd_setImageWithURL(thumbnailAvatarURL(), placeholderImage: UIImage(named: "avatar"))
            cell.nameLabel.text = name ?? ""
          
            cell.accessoryType = .DisclosureIndicator
            cell.selectionStyle = .None
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MeItemTableViewCell), forIndexPath: indexPath) as! MeItemTableViewCell
            if indexPath.section == 1 {
                cell.icon.image = UIImage(named: imgs[indexPath.row])?.imageWithRenderingMode(.AlwaysTemplate)
                cell.itemLabel.text = items[indexPath.row]
            }
            else {
                cell.icon.image = UIImage(named: "setting")?.imageWithRenderingMode(.AlwaysTemplate)
                cell.itemLabel.text = "设置"
            }
            cell.accessoryType = .DisclosureIndicator
            cell.selectionStyle = .None
            cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return  1
        }
        else if section == 1{
            return 3
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 70
        }
        else {
            return 46
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section < 2 ? 20 : 1
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 20))
        v.backgroundColor =  UIColor.colorFromRGB(0xefeff4)
        return v
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0  {
            if let _ = myId {
                let vc = MeVC()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.section == 2 {
            navigationController?.pushViewController(SettingVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            navigationController?.pushViewController(ContactsVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            navigationController?.pushViewController(MessageConversationVC(), animated: true)
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = false
    }
}

class MeTableViewCell:UITableViewCell {
    var avatar:UIImageView!
    var nameLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func initialize() {
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        contentView.addSubview(avatar)
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
           // make.top.equalTo(contentView.snp_topMargin)
            make.centerY.equalTo(contentView.snp_centerY)
            make.height.width.equalTo(50)
        }
        
        nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.colorFromRGB(0x636363)
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(avatar.snp_centerY)
        }
    }
}

class MeItemTableViewCell:UITableViewCell {
    var icon:UIImageView!
    var itemLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier:reuseIdentifier)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func initialize() {
        icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        //icon.layer.cornerRadius = 15
        icon.layer.masksToBounds = true
        icon.tintColor = THEME_COLOR_BACK
        contentView.addSubview(icon)
        
        itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemLabel)
        itemLabel.textColor = UIColor.colorFromRGB(0x636363)
        
        icon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            // make.top.equalTo(contentView.snp_topMargin)
            make.centerY.equalTo(contentView.snp_centerY)
            make.height.width.equalTo(22)
        }
        

        itemLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(icon.snp_right).offset(10)
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(icon.snp_centerY)
        }

    }
    
}