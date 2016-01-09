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
    
    let items = ["好友", "私信", "活动", "心声"]
    let imgs = ["follow", "message", "time", "audio"]
    var more = ["设置"]
    
    var personInfo:PersonModel?
    
    var unreadMessage:String?
 
    
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
        tableView.separatorStyle = .None
        fetchNameInfo()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "editInfo:", name: EDIT_INFO_NOTIFICATION, object: nil)
    }
    
    func editInfo(sender:AnyObject) {
        fetchNameInfo()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
      
        
        fetchUnreadMessage()
        
        tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1.0
        
    }
    
    func loadNameInfoFromFile() {
        let cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        let profileFile = cacheDir.stringByAppendingString("/\(PROFILE_CACHE_FILE)")
        if NSFileManager.defaultManager().fileExistsAtPath(profileFile) {
            
        }
    }
    
    func fetchUnreadMessage() {
        if let t = token {
            request(.POST, GET_UNREAD_MESSAGE_URL, parameters: ["token":t], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" && json["number"] != .null else {
                        return
                    }
                    
                    S.unreadMessage = json["number"].stringValue
                    S.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: .None)
                    //S.tableView.reloadData()
                }
            })
        }
    }
    
    
    func fetchNameInfo() {
        if let t = token {
            request(.POST, GET_PROFILE_INFO_URL, parameters: ["token":t], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                if let d = response.result.value,S = self {
                    let json = JSON(d)
                    guard json["state"] == "successful" && json["name"] != .null else{
                        return
                    }
                    do {
                        S.personInfo = try MTLJSONAdapter.modelOfClass(PersonModel.self, fromJSONDictionary: json.dictionaryObject) as? PersonModel
                        S.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .None)
                        //S.tableView.reloadData()
                    }
                    catch {
                        print(error)
                    }
                   
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
            cell.nameLabel.text = personInfo?.name ?? " "
            cell.accessoryType = .DisclosureIndicator
            cell.selectionStyle = .None
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MeItemTableViewCell), forIndexPath: indexPath) as! MeItemTableViewCell
            if indexPath.section == 1 {
                cell.icon.image = UIImage(named: imgs[indexPath.row])?.imageWithRenderingMode(.AlwaysTemplate)
                cell.icon.tintColor = THEME_COLOR_BACK
                cell.itemLabel.text = items[indexPath.row]
                if indexPath.row == 1 {
                    if let _ = unreadMessage {
                        if let num = Int(unreadMessage!) where num > 0 {
                            let badge = CustomBadge(string: "\(num)")
                            cell.accessoryView = badge
                        }
                        else {
                            cell.accessoryView = nil
                        }
                    }
                    else {
                        cell.accessoryView = nil
                    }
                }
                
                if indexPath.row == items.count - 1 {
                    cell.seperator.hidden = true
                }
                
            }
            else {
                cell.icon.image = UIImage(named: "setting")?.imageWithRenderingMode(.AlwaysTemplate)
                cell.itemLabel.text = "设置"
                cell.seperator.hidden = true
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
            return items.count
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
            if let id = myId {
                let vc = MeInfoVC()
                vc.id = id
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if indexPath.section == 2 {
            navigationController?.pushViewController(SettingVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            navigationController?.pushViewController(ContactsVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            navigationController?.pushViewController(MessageConversationVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            navigationController?.pushViewController(MyActivityVC(), animated: true)
        }
        else if indexPath.section == 1 && indexPath.row == 3 {
            navigationController?.pushViewController(TopicVoiceVC(topic:"1"), animated: true)
        }
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
    var seperator:UIView!
    
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
        
        seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(seperator)
        seperator.backgroundColor = BACK_COLOR
        
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
        
        seperator.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(itemLabel.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_bottom).offset(-1)
            make.height.equalTo(1)
        }

    }
    
}