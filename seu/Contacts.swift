//
//  Contacts.swift
//  牵手东大
//
//  Created by liewli on 10/22/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import Foundation
import UIKit


protocol ConversationTableCellDelegate {
    func didTapAvatarAtCell(cell:ConversationTableCell)
}

class ConversationTableCell:UITableViewCell {
    var avatar :UIImageView!
    var nameLabel:UILabel!
    var infoLabel:UILabel!
   // var timeLabel:UILabel!
    var gender:UIImageView!
    var delegate:ConversationTableCellDelegate?
    
    func tap(sender:AnyObject?) {
        delegate?.didTapAvatarAtCell(self)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        avatar = UIImageView()
        //avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.userInteractionEnabled = true
        avatar.bounds.size = CGSizeMake(50, 50)
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        avatar.addGestureRecognizer(tap)
        addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        nameLabel.textColor = THEME_COLOR
        addSubview(nameLabel)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        infoLabel.textColor = UIColor.lightGrayColor()
        addSubview(infoLabel)
        
//        timeLabel = UILabel()
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
//        timeLabel.textColor = UIColor.lightGrayColor()
//        addSubview(timeLabel)
        
        gender = UIImageView()
        gender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gender)
        
        
        let viewDict = ["avatar" : avatar, "nameLabel":nameLabel, "infoLabel":infoLabel, "gender":gender]
        
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[avatar(50)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        var constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        
        addConstraints(constraints)
        addConstraint(constraint)
        //constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[avatar(44)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        
        addConstraint(constraint)
        
        
        
        constraint = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: avatar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 2)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: avatar, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 5)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: avatar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -2)
        addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: nameLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        addConstraint(constraint)
        
//        
//        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[nameLabel]-5-[gender]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
//        addConstraints(constraints)
//        constraint = NSLayoutConstraint(item: gender, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 16, constant: 0)
//        addConstraint(constraint)
        
        gender.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel.snp_right).offset(5)
            make.centerY.equalTo(nameLabel.snp_centerY)
            make.height.equalTo(18)
            make.width.equalTo(16)
        }
//        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[infoLabel]-5-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        addConstraints(constraints)
        
        //        let backColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 250/255.0, alpha: 1.0)
        //
        //        backgroundColor = backColor
        
        layoutMargins = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 0)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //avatar.image = nil
        nameLabel.text = ""
        infoLabel.text = ""
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class SearchResultsVC:UITableViewController, ConversationTableCellDelegate {
    
    private var friendsData = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        tableView.backgroundColor = BACK_COLOR//backColor
        tableView.tableFooterView = UIView()
        
        tableView.registerClass(ConversationTableCell.self, forCellReuseIdentifier: "ConversationTableCell")
        
        UITableViewHeaderFooterView.appearance().tintColor = BACK_COLOR//backColor

    }
    
    
    

    func didTapAvatarAtCell(cell: ConversationTableCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let id = self.friendsData[indexPath!.row]["id"].stringValue
        let url = avatarURLForID(id)
        let agrume = Agrume(imageURL:url)
        agrume.showFrom(self)
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
        
    }
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationTableCell", forIndexPath: indexPath) as! ConversationTableCell
        let data = friendsData[indexPath.row]
        let id = data["id"].stringValue
        let url = thumbnailAvatarURLForID(id)
        //cell.avatar.setImageWithURL(url, placeholder:nil, animated: false)
        cell.avatar.hnk_setImageFromURL(url, placeholder: UIImage(named: "avatar"))
        
        cell.nameLabel.text = data["name"].string ?? " "
        cell.infoLabel.text = data["school"].string ?? " "
        
        if data["gender"].stringValue == "男" {
            cell.gender.image  = UIImage(named: "male")
        }
        else if data["gender"].stringValue == "女" {
            cell.gender.image = UIImage(named: "female")
        }
        cell.selectedBackgroundView = UIView()
        cell.delegate = self
        cell.selectionStyle = .None
        return cell

    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let follow = UITableViewRowAction(style: .Normal, title: "关注") { (action, indexPath) -> Void in
            //print("unfollow")
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
                request(.POST, FOLLOW_URL, parameters: ["token":token, "id":self.friendsData[indexPath.row]["id"].stringValue], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        if json["state"] == "successful" || json["state"] == "sucessful" {
                            self?.friendsData.removeAtIndex(indexPath.row)
                            self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        }
                        else {
                            let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                            self?.presentViewController(alert, animated: true, completion: nil)
                            return
                        }
                    }
                        
                    else if let error = response.result.error {
                        let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self?.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                }
                
            }
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        follow.backgroundColor = THEME_COLOR//UIColor.redColor()
        
        return [follow]
    }
    
}

class ContactsVC:UITableViewController, UINavigationControllerDelegate {
    
    
    // private var searchVC :UISearchDisplayController!
    private var friendsData = [JSON]()
    
    private var searchController:UISearchController?
    
    var refreshCont:UIRefreshControl!
    
    private var page = 1
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR//UIColor.colorFromRGB(0x104E8B)//UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "朋友"
        setNeedsStatusBarAppearanceUpdate()
        tableView.tableFooterView = UIView()
        //let backColor = BACK_COLOR//UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)

        searchController = UISearchController(searchResultsController: SearchResultsVC())
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.placeholder = "输入姓名或ID快速查找"
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.tintColor = THEME_COLOR//UIColor.redColor()
        searchController?.searchBar.barTintColor = BACK_COLOR//backColor
        searchController?.searchBar.backgroundColor = BACK_COLOR//backColor
       // searchController?.hidesNavigationBarDuringPresentation = false
       // definesPresentationContext = false
        //searchController?.searchBar.setValue("取消", forKey: "_cancelButtonText")
        searchController?.delegate = self
        self.navigationController?.extendedLayoutIncludesOpaqueBars = true
        
        tableView.tableHeaderView = searchController?.searchBar
        
        
        
        tableView.backgroundColor = BACK_COLOR//backColor
        //view.backgroundColor = backColor
        //searchBar.barTintColor = backColor
        
        tableView.registerClass(ConversationTableCell.self, forCellReuseIdentifier: "ConversationTableCell")
        
        UITableViewHeaderFooterView.appearance().tintColor = BACK_COLOR//backColor
        
        refreshCont = UIRefreshControl()
        refreshCont.backgroundColor = BACK_COLOR//backColor
        refreshCont.addTarget(self, action: "pullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        view.addSubview(refreshCont)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "recommendFriendsExit:", name: RecommendFriendsExitNotification, object: nil)
        loadOnePage()
    }
    
    func recommendFriendsExit(sender: AnyObject?) {
        pullRefresh(self.refreshCont)
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    
    
    func pullRefresh(sender:AnyObject) {
        friendsData = [JSON]()
        tableView.reloadData()
        page = 1
        loadOnePage()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.refreshCont.endRefreshing()
        }
    }

    
    func loadOnePage() {
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
                request(.POST, GET_FOLLOWERS_URL, parameters: ["token":token, "page":"\(page)", "direction":"followeds"], encoding: .JSON, headers: nil).responseJSON(completionHandler: { (response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        
                        let json = JSON(d)
                        if json["state"] == "successful" || json["state"] == "sucessful" {
                         
                            if let arr = json["result"].array {
                                let cnt = self.friendsData.count
                                
                                
                                self.friendsData.appendContentsOf(arr)
                                
                                var indexArr = [NSIndexPath]()
                                for k in 0..<arr.count {
                                    let indexPath = NSIndexPath(forRow: cnt+k, inSection: 1)
                                    indexArr.append(indexPath)
                                }
                                
                                if (arr.count > 0) {
                                    self.page++
                                    self.tableView.insertRowsAtIndexPaths(indexArr, withRowAnimation: UITableViewRowAnimation.Fade)
                                    
                                    
                                }

                            }
                        }
                    }
                    
                    self.refreshCont.endRefreshing()

                })
            }
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return indexPath.section == 1
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let unfollow = UITableViewRowAction(style: .Normal, title: "取消关注") { (action, indexPath) -> Void in
           // print("unfollow")
                if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
                    request(.POST, UNFOLLOW_URL, parameters: ["token":token, "id":self.friendsData[indexPath.row]["id"].stringValue], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                        //debugprint(response)
                        if let d = response.result.value {
                            let json = JSON(d)
                            if json["state"] == "successful" || json["state"] == "sucessful" {
                                self?.friendsData.removeAtIndex(indexPath.row)
                                self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                                
                            }
                            else {
                                let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                self?.presentViewController(alert, animated: true, completion: nil)
                                return
                            }
                        }
                        
                        else if let error = response.result.error {
                            let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                            self?.presentViewController(alert, animated: true, completion: nil)
                            return

                        }
                        
                    }
                
            }
            

            
            
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        let message = UITableViewRowAction(style: .Normal, title: "私信") { (action, indexPath) -> Void in
            let data = self.friendsData[indexPath.row]
            let id = data["id"].stringValue

            let vc = ComposeMessageVC()
            vc.recvID = id
            
            let nav = UINavigationController(rootViewController: vc)
            self.presentViewController(nav, animated: true, completion: { () -> Void in
                
            });
        }
        message.backgroundColor =  UIColor(red: 255/255.0, green: 127/255.0, blue: 36/255.0, alpha: 1.0)
        unfollow.backgroundColor = THEME_COLOR//UIColor.redColor()
        
        return indexPath.section == 1 ? [unfollow, message] : nil
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.friendsData.count - 1 {
            loadOnePage()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = indexPath.row == 0 ? "好友推荐":"好友私信"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = .None
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ConversationTableCell", forIndexPath: indexPath) as! ConversationTableCell
                let data = friendsData[indexPath.row]
                let id = data["id"].stringValue
                let url = thumbnailAvatarURLForID(id)
                //cell.avatar.setImageWithURL(url, placeholder:nil, animated: false)
                cell.avatar.hnk_setImageFromURL(url, placeholder: UIImage(named: "avatar"))
            
                cell.nameLabel.text = data["name"].string ?? " "
                cell.infoLabel.text = data["school"].string ?? " "
            
            if data["gender"].stringValue == "男" {
                cell.gender.image  = UIImage(named: "male")
            }
            else if data["gender"].stringValue == "女" {
                cell.gender.image = UIImage(named: "female")
            }
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section <= 0 {
            return 1
        }
        else {
            return friendsData.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "我的好友" : ""
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 44
        }
        return 0
    }
  
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section <= 0 {
            return 44
        }
        else {
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                navigationController?.pushViewController(RecommendedFriendsVC(), animated: true)
            }
            else {
                let msgVC = MessageConversationVC()
                msgVC.title = "私信"
                navigationController?.pushViewController(msgVC, animated: true)
            }
        }
        else {
            let vc = MeInfoVC()
            vc.id = friendsData[indexPath.row]["id"].stringValue
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

extension ContactsVC: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            let searchVC = searchController.searchResultsController as! SearchResultsVC
            if text.characters.count > 0 {
                if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
                request(.POST, SEARCH_USER_URL, parameters: ["token":token, "text":text], encoding: .JSON).responseJSON{ [weak searchVC](response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        if json["state"] == "successful" || json["state"] == "sucessful" {
                            let data = json["result"].array!
                            searchVC?.friendsData = data
                            searchVC?.tableView.reloadData()
                        }
                        else {
//                            let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
//                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
//                            self?.presentViewController(alert, animated: true, completion: nil)
//                            return
                        }
                    }
                        
                   // else if let error = response.result.error {
//                        let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
//                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
//                        self?.presentViewController(alert, animated: true, completion: nil)
//                        return
                        
                   // }
                    
                }
                
            }
            }
            
        }
    }
}

extension ContactsVC: UISearchControllerDelegate {
    func didDismissSearchController(searchController: UISearchController) {
        pullRefresh(self.refreshCont)
    }
}


private let RecommendFriendsExitNotification = "RecommendFriendsExitNotification"
class RecommendedFriendsVC:UITableViewController, ConversationTableCellDelegate{
    
    private var friendsData = [JSON]()
    var refreshCont:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "好友推荐"
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        tableView.tableFooterView = UIView()
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        tableView.backgroundColor = BACK_COLOR//backColor
        
        tableView.registerClass(ConversationTableCell.self, forCellReuseIdentifier: "ConversationTableCell")
        
        UITableViewHeaderFooterView.appearance().tintColor = BACK_COLOR//backColor
        
        tableView.allowsSelection = false
        
        refreshCont = UIRefreshControl()
        refreshCont.addTarget(self, action: "pullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCont)
        loadFriends()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().postNotificationName(RecommendFriendsExitNotification, object: nil)
    }
    
    
    func pullRefresh(sender:AnyObject) {
        friendsData = [JSON]()
        tableView.reloadData()
        loadFriends()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.refreshCont.endRefreshing()
        }
    }

    
    func loadFriends() {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
            request(.POST, GET_RECOMMENDED_FRIENDS_URL, parameters: ["token":token], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                //debugprint(response)
                if let d = response.result.value {
                    let json = JSON(d)
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        if let arr = json["result"].array {
                            self.friendsData = arr
                            self.tableView.reloadData()
                        }
                    }
                }
                
                self.refreshCont.endRefreshing()
            })
            
        }

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.friendsData.count > 0 ? "左滑选择关注可查看详细信息" : ""
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationTableCell", forIndexPath: indexPath) as! ConversationTableCell
        let data = friendsData[indexPath.row]
        let id = data["id"].stringValue
        let url = thumbnailAvatarURLForID(id)
       // cell.avatar.setImageWithURL(url, placeholder:nil, animated: false)
        cell.avatar.hnk_setImageFromURL(url, placeholder: UIImage(named: "avatar"))
        cell.nameLabel.text = data["name"].string ?? " "
        cell.infoLabel.text = data["school"].string ?? " "
        
        if data["gender"].stringValue == "男" {
            cell.gender.image  = UIImage(named: "male")
        }
        else if data["gender"].stringValue == "女" {
            cell.gender.image = UIImage(named: "female")
        }
        cell.selectedBackgroundView = UIView()
        cell.delegate = self
        return cell
    }
    
    
    func didTapAvatarAtCell(cell: ConversationTableCell) {
        let indexPath = tableView.indexPathForCell(cell)
        let id = self.friendsData[indexPath!.row]["id"].stringValue
        let url = avatarURLForID(id)
        let agrume = Agrume(imageURL:url)
        agrume.showFrom(self)

    }
    
   
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let follow = UITableViewRowAction(style: .Normal, title: "关注") { (action, indexPath) -> Void in
            //print("unfollow")
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
                request(.POST, FOLLOW_URL, parameters: ["token":token, "id":self.friendsData[indexPath.row]["id"].stringValue], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        if json["state"] == "successful" || json["state"] == "sucessful" {
                            self?.friendsData.removeAtIndex(indexPath.row)
                            self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        }
                        else {
                            let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                            self?.presentViewController(alert, animated: true, completion: nil)
                            return
                        }
                    }
                        
                    else if let error = response.result.error {
                        let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self?.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                    
                }

            }
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        follow.backgroundColor = THEME_COLOR//UIColor.redColor()
        
        return [follow]
    }
    

    
}

