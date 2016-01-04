//
//  HandVC.swift
//  seu
//
//  Created by liewli on 10/15/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

import Photos

import GMPhotoPicker

protocol ActivityTableViewCellDelegate {
    func didTapTableViewCell(cell:AcitivityTableViewCell)
}

class AcitivityTableViewCell:UITableViewCell {
    var back:UIImageView!
    var titleLabel:UILabel!
    var timeLabel:UILabel!
    var locationLabel:UILabel!
    var peopleLabel:UILabel!
    var registerButton:UIButton!
    
    var delegate:ActivityTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        back = UIImageView()
        back.translatesAutoresizingMaskIntoConstraints = false
        //back.backgroundColor = backColor
        back.layer.cornerRadius = 4.0
        back.layer.borderColor = UIColor.blackColor().CGColor
        back.layer.borderWidth = 1.0
        back.userInteractionEnabled = true
        contentView.addSubview(back)
        
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(titleLabel)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(timeLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(locationLabel)
        
        peopleLabel = UILabel()
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(peopleLabel)
        
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(registerButton)
        
        let viewDict = ["back":back, "titleLabel":titleLabel, "timeLabel":timeLabel,"locationLabel":locationLabel ,"peopleLabel":peopleLabel, "register":registerButton]
        
        back.snp_updateConstraints(closure: { (make) -> Void in
            make.left.equalTo(contentView.snp_left).offset(2)
            make.right.equalTo(contentView.snp_right).offset(-2)
        })
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        addConstraints(constraints)
        
        
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[titleLabel]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        var constraint = NSLayoutConstraint(item: timeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        back.addConstraint(constraint)
        
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[locationLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: locationLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        back.addConstraint(constraint)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[peopleLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: peopleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: locationLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        back.addConstraint(constraint)

        registerButton.backgroundColor = THEME_COLOR//UIColor.redColor()
        registerButton.titleLabel?.textColor = UIColor.whiteColor()
        registerButton.layer.cornerRadius = 5.0
//        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[register(300@50)]-40-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//        back.addConstraints(constraints)
        registerButton.snp_makeConstraints { (make) -> Void in
           make.width.equalTo(back.snp_width).multipliedBy(2/3.0)
            //make.width.lessThanOrEqualTo(300).priorityHigh()
            //make.width.greaterThanOrEqualTo(200).priorityHigh()
        }
        
        constraint = NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: peopleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        back.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        back.addConstraint(constraint)
        
        registerButton.addTarget(self, action: "register:", forControlEvents: UIControlEvents.TouchUpInside)
        
      
        
    }
   //    override func layoutSubviews() {
//        super.layoutSubviews()
//        print(registerButton.frame.width)
//        if registerButton.frame.width > 300 {
//            let delta = ((back.frame.width - 300) / 2)
//            registerButton.snp_updateConstraints(closure: { (make) -> Void in
//                make.left.equalTo(back.snp_left).offset(delta)
//                make.right.equalTo(back.snp_right).offset(-delta)
//               // super.layoutSubviews()
//            })
//        }
//    }
//    

    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        //print("here")
        if  traitCollection.verticalSizeClass == .Regular{
            //print("compact")
            back.snp_updateConstraints(closure: { (make) -> Void in
                make.left.equalTo(contentView.snp_left).offset(2)
                make.right.equalTo(contentView.snp_right).offset(-2)
            })
//            registerButton.snp_updateConstraints { (make) -> Void in
//                make.width.equalTo(back.snp_width).multipliedBy(2/3.0)
//            }
        }
        else {
            back.snp_updateConstraints(closure: { (make) -> Void in
                make.left.equalTo(contentView.snp_left).offset(50)
                make.right.equalTo(contentView.snp_right).offset(-50)
            })
//            registerButton.snp_updateConstraints { (make) -> Void in
//                make.width.equalTo(back.snp_width).multipliedBy(1/2.0)
//                
//            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func register(sender:AnyObject) {
        delegate?.didTapTableViewCell( self)
    }
}



class HandVC:UITableViewController, ActivityTableViewCellDelegate, UINavigationControllerDelegate {
    var refreshCont:UIRefreshControl!
    
    var activities:[JSON]?
    
    lazy var registered = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "活动"
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        navigationController?.navigationBar.translucent = false
        
        tableView.registerClass(AcitivityTableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.tableFooterView = UIView()
        
        refreshCont = UIRefreshControl()
        refreshCont.addTarget(self, action: "pullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCont)
        //tableView.contentInset = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = false
        
        navigationController?.delegate = self
        
        
        
        refresh()
 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        refresh()
    }
    //
//
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.hidden = true
//    }
    
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        tabBarController?.tabBar.hidden = false
//    }
    
//    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
//        tabBarController?.tabBar.hidden = viewController != self
//    }
//    
//    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//           tabBarController?.tabBar.hidden = viewController != self
//    }
//    
    func pullRefresh(sender:AnyObject) {
        refresh()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.refreshCont.endRefreshing()
        }
    }
    func refresh()  {
        //print("refresh")
        
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
            request(.POST, GET_ACTIVITY_INFO_URL, parameters: ["token":token], encoding: .JSON).responseJSON{ (response) -> Void in
                //debugprint(response)
                if let d = response.result.value {
                    let json = JSON(d)
                    //if json["state"] == "successful" || json["state"] == "sucessful" {
                    self.activities = json["result"].array
                    self.tableView.reloadData()
                   // }
                }
                
                //else if let error = response.result.error {
                //
                // }
                
                self.refreshCont.endRefreshing()
            }
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activities?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! AcitivityTableViewCell
        let json = activities?[indexPath.section]
        cell.delegate = self
        cell.titleLabel.text = json?["title"].stringValue ?? ""
        cell.timeLabel.text = "时间: " + (json?["time"].stringValue ?? " ")
        cell.locationLabel.text = "地点: " + (json?["location"].stringValue ?? " ")
        cell.peopleLabel.text = "人数: " + (json?["number"].stringValue ?? " ") + "人"
        if json?["state"].stringValue == "yes" {
            let color = UIColor(red: 255/255.0, green: 127/255.0, blue: 36/255.0, alpha: 1.0)
            cell.registerButton.setTitle("已报名", forState: UIControlState.Normal)
            cell.registerButton.backgroundColor = color
        }
        else {
          
            cell.registerButton.setTitle("报名参加", forState: UIControlState.Normal)
            
        }
        cell.back.image = UIImage(named: "activity_back" + String(indexPath.section%4+1))
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    func didTapTableViewCell(cell: AcitivityTableViewCell) {
       // print("tap register")
        let vc = ActivityRegisterVC()
        let indexPath = tableView.indexPathForCell(cell)
        vc.id = activities?[(indexPath?.section)!]["id"].stringValue
        if let s = activities?[(indexPath?.section)!]["state"] {
            if s != "yes" {
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}


class ActivityRegisterVC:UIViewController {
    
    var id:String?
    private var _view :UIScrollView!
    private var contentView :UIView!
    
    var personalInfoLabel:UILabel!
    var nameInfoLabel:UILabel!
    var gender:UIImageView!
    var birthdayLabel:UILabel!
    var confirmButton:UIButton!
    var avatar:UIImageView!
    var schoolInfo:UITextView!
    var interestLabel:UITextView!
    var requirementLabel:UITextView!
    
    var wechatLabel:UILabel!
    var qqLabel:UILabel!
    var hometownLabel:UILabel!
    
    var refreshControl:UIRefreshControl!
    
    var seperator:UILabel!
    var infoLabel:UILabel!
    
    
    private var profile:JSON?
    
    var phoneNumberLabel:UILabel!
    
    var schoolInfoHeightConstraint:NSLayoutConstraint!
    
    var interestInfoHeightConstraint:NSLayoutConstraint!
    
    var requirementInfoHeightConstraint:NSLayoutConstraint!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "报名申请"
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
       // tabBarController?.tabBar.hidden = true
        
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        _view = UIScrollView()
        // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        _view.backgroundColor = BACK_COLOR//backColor
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        contentView.backgroundColor = BACK_COLOR//backColor
        _view.addSubview(contentView)
        //contentView.backgroundColor = UIColor.yellowColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        _view.addSubview(refreshControl)
        
        loadUI()
        
        refresh()
    }
    
    func pullRefresh(sender:AnyObject) {
        refresh()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2*Int64(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    func refresh() {
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
            request(.POST, GET_PROFILE_INFO_URL, parameters: ["token":token], encoding: .JSON).responseJSON{ (response) -> Void in
                //debugPrint(response)
                if let d = response.result.value {
                    let json = JSON(d)
                    if json["state"] == "successful"{
                        //self.profile = json
                        NSUserDefaults.standardUserDefaults().setValue(d, forKey: PROFILE)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        //self.profile = JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())

                    }
                }
                
                self.configUI()
                
                self.refreshControl.endRefreshing()
            }
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // print("viewwillappear")
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR//UIColor.colorFromRGB(0x104E8B)//UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1.0
        refresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = true
        
         refresh()
    }
    
    func configUI() {
        
        profile =  JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())
        
        
        
        nameInfoLabel.text = profile?["name"].string ?? ""
        if let sex = profile?["gender"].string {
            if sex == "男" {
                gender.image = UIImage(named: "male")
            }
            else if sex == "女"{
                gender.image = UIImage(named: "female")
            }
            else {
                gender.image = nil
            }
        }

        phoneNumberLabel.text = profile?["phone"].string ?? ""
        wechatLabel.text = profile?["wechat"].string ?? ""
        qqLabel.text = profile?["qq"].string ?? ""
        hometownLabel.text = profile?["hometown"].string ?? " "
        hometownLabel.resizeHeightWithSnapKit()
        birthdayLabel.text = profile?["birthday"].string ?? ""
        
        avatar.setImageWithURL(thumbnailAvatarURL()!)

        
        let schoolinfo = ["school", "department", "enrollment", "degree"]
        var ss = ""
        for s in schoolinfo {
            ss += (profile?[s].string ?? "") + "  "
        }
        
        schoolInfo.text = ss
        
        schoolInfo.resizeHeightToFit(schoolInfoHeightConstraint)
   
        interestLabel.text = profile?["hobby"].string ?? ""
        interestLabel.resizeHeightToFit(interestInfoHeightConstraint)
        requirementLabel.text = profile?["preference"].string ?? ""
        requirementLabel.resizeHeightToFit(requirementInfoHeightConstraint)

    }
    
    func loadUI() {
       // let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        var constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)

        
        personalInfoLabel = UILabel()
        nameInfoLabel = UILabel()
        let back = UIView()
        let back1 = UIView()
        let back2 = UIView()
        let back3 = UIView()
        let back4 = UIView()
        birthdayLabel = UILabel()
        gender = UIImageView()
        let editPersonalInfo = UIImageView()
        confirmButton = UIButton()
        avatar = UIImageView()
        let schoolInfoLabel = UILabel()
        let editSchoolInfo = UIImageView()
        schoolInfo = UITextView()
        let editMoreInfoLabel = UILabel()
        let editMoreInfo = UIImageView()
         let interestInfoLabel = UILabel()
        interestLabel = UITextView()
        requirementLabel = UITextView()
        let requirementInfoLabel = UILabel()
        phoneNumberLabel = UILabel()
        let contactInfoLabel = UILabel()
        let phoneNumberInfoLabel = UILabel()
        let contactInfoBack = UIView()
        
      
        let viewDict = ["personalInfoLabel":personalInfoLabel, "nameInfoLabel":nameInfoLabel,"back1":back1 ,"back":back, "gender":gender, "birthdayLabel":birthdayLabel, "editPersonalInfo":editPersonalInfo, "confirmButton":confirmButton, "avatar":avatar, "schoolInfoLabel":schoolInfoLabel, "back2":back2, "editSchoolInfo":editSchoolInfo, "schoolInfo":schoolInfo, "back3":back3,
        "editMoreInfoLabel":editMoreInfoLabel, "back4":back4, "editMoreInfo":editMoreInfo, "interestInfoLabel":interestInfoLabel,"interestLabel":interestLabel, "requirementLabel":requirementLabel, "requirementInfoLabel":requirementInfoLabel, "phoneNumberLabel":phoneNumberLabel, "contactInfoLabel":contactInfoLabel, "phoneNumberInfoLabel":phoneNumberInfoLabel, "contactInfoBack":contactInfoBack]
        
        
        
        contentView.addSubview(back)
        back.backgroundColor = BACK_COLOR//backColor
        back.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        contentView.addConstraint(constraint)
        
        
        
        personalInfoLabel.text = "个人信息"
        personalInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        personalInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(personalInfoLabel)

        editPersonalInfo.translatesAutoresizingMaskIntoConstraints = false
        editPersonalInfo.image = UIImage(named: "edit")?.imageWithRenderingMode(.AlwaysTemplate)
        editPersonalInfo.tintColor = THEME_COLOR
        editPersonalInfo.userInteractionEnabled = true
        let tapEditPersonalInfo = UITapGestureRecognizer(target: self, action: "editPersonalInfo:")
        editPersonalInfo.addGestureRecognizer(tapEditPersonalInfo)
        back.addSubview(editPersonalInfo)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[personalInfoLabel]-[editPersonalInfo(26)]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[personalInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: editPersonalInfo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: editPersonalInfo, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
//        constraint = NSLayoutConstraint(item:editPersonalInfo, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
//        view.addConstraint(constraint)
        
        
        contentView.addSubview(back1)
        back1.backgroundColor = UIColor.whiteColor()
        back1.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        contentView.addConstraint(constraint)
        
        back1.addSubview(nameInfoLabel)
        back1.addSubview(gender)
        back1.addSubview(birthdayLabel)
        back1.addSubview(avatar)
        nameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        gender.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.textAlignment = NSTextAlignment.Right
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 20
        avatar.layer.masksToBounds = true
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[avatar(40)]-[nameInfoLabel]-[gender]-[birthdayLabel(40@200)]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nameInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
//        constraint = NSLayoutConstraint(item: gender, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: gender, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
//        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: avatar, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        gender.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(18)
            make.width.equalTo(16)
        }
        
        
        contactInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contactInfoLabel.backgroundColor = BACK_COLOR//backColor
        contentView.addSubview(contactInfoLabel)
        contactInfoLabel.text = "联系方式"
        contactInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[contactInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: contactInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: contactInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        contentView.addConstraint(constraint)
        
        
        contentView.addSubview(contactInfoBack)
        contactInfoBack.translatesAutoresizingMaskIntoConstraints = false
        contactInfoBack.backgroundColor = UIColor.whiteColor()
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contactInfoBack]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: contactInfoBack, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contactInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
//        constraint = NSLayoutConstraint(item: contactInfoBack, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
//        contentView.addConstraint(constraint)

        
        contactInfoBack.addSubview(phoneNumberInfoLabel)
        contactInfoBack.addSubview(phoneNumberLabel)
        phoneNumberInfoLabel.text = "手机号"
        phoneNumberInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.textAlignment =  NSTextAlignment.Right
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[phoneNumberInfoLabel]-[phoneNumberLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
//        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[phoneNumberInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//        contentView.addConstraints(constraints)
        phoneNumberInfoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contactInfoBack.snp_topMargin)
        }

        
        let wechatInfoLabel = UILabel()
        wechatInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        wechatLabel = UILabel()
        wechatLabel.textAlignment = .Right
        wechatLabel.translatesAutoresizingMaskIntoConstraints = false
        contactInfoBack.addSubview(wechatLabel)
        contactInfoBack.addSubview(wechatInfoLabel)
        wechatInfoLabel.text = "微信号"
        wechatInfoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(phoneNumberInfoLabel.snp_bottom).offset(5)
            make.left.equalTo(phoneNumberInfoLabel.snp_left)
            make.width.equalTo(30).priorityHigh()
            make.centerY.equalTo(wechatLabel.snp_centerY)
        }
        wechatLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contactInfoBack.snp_rightMargin)
            make.left.equalTo(wechatInfoLabel.snp_right)
        }
        
        let qqInfoLabel = UILabel()
        qqInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        qqLabel = UILabel()
        qqLabel.textAlignment = .Right
        qqLabel.translatesAutoresizingMaskIntoConstraints = false
        contactInfoBack.addSubview(qqInfoLabel)
        contactInfoBack.addSubview(qqLabel)
        qqInfoLabel.text = "QQ号"
        qqInfoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(wechatInfoLabel.snp_bottom).offset(5)
            make.left.equalTo(wechatInfoLabel.snp_left)
            make.width.equalTo(30).priorityHigh()
            make.centerY.equalTo(qqLabel.snp_centerY)
            make.bottom.equalTo(contactInfoBack.snp_bottomMargin)
        }
        qqLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contactInfoBack.snp_rightMargin)
            make.left.equalTo(qqInfoLabel.snp_right)
        }
        
        let geoInfoLabel = UILabel()
        contentView.addSubview(geoInfoLabel)
        geoInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        geoInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        geoInfoLabel.text = "地理位置"
        geoInfoLabel.backgroundColor = BACK_COLOR
        
        geoInfoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contactInfoBack.snp_bottom).offset(5)
        }
        
        let geoInfoBack = UIView()
        geoInfoBack.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(geoInfoBack)
        geoInfoBack.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(geoInfoLabel.snp_bottom).offset(5)
        }
        
        let hometownInfoLabel = UILabel()
        hometownInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        hometownInfoLabel.text = "家乡"
        geoInfoBack.addSubview(hometownInfoLabel)
        hometownLabel = UILabel()
        hometownLabel.textAlignment = .Right
        hometownLabel.numberOfLines = 0
        hometownLabel.lineBreakMode = .ByWordWrapping
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        geoInfoBack.addSubview(hometownLabel)
        
        hometownInfoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(geoInfoBack.snp_leftMargin)
            make.top.equalTo(geoInfoBack.snp_top)
            make.width.equalTo(40).priorityHigh()
            //make.centerY.equalTo(hometownLabel.snp_centerY)
            make.bottom.equalTo(geoInfoBack.snp_bottom)
        }
        
        hometownLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(geoInfoBack.snp_rightMargin)
            make.left.equalTo(hometownInfoLabel.snp_right).offset(5)
            make.top.equalTo(geoInfoBack.snp_top)
            make.bottom.equalTo(geoInfoBack.snp_bottom)
        }

        
        
        
        
        
        contentView.addSubview(back2)
        back2.backgroundColor = BACK_COLOR//backColor
        back2.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back2]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: geoInfoBack, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        contentView.addConstraint(constraint)
        
        
        
        schoolInfoLabel.text = "学校信息"
        schoolInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        schoolInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        back2.addSubview(schoolInfoLabel)
        
        editSchoolInfo.translatesAutoresizingMaskIntoConstraints = false
        editSchoolInfo.image = UIImage(named: "edit")?.imageWithRenderingMode(.AlwaysTemplate)
        editSchoolInfo.tintColor = THEME_COLOR
        editSchoolInfo.userInteractionEnabled = true
        let tapEditSchoolInfo = UITapGestureRecognizer(target: self, action: "editSchoolInfo:")
        editSchoolInfo.addGestureRecognizer(tapEditSchoolInfo)
        back2.addSubview(editSchoolInfo)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[schoolInfoLabel]-[editSchoolInfo(26)]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[schoolInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: editSchoolInfo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: editSchoolInfo, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)

        
        contentView.addSubview(back3)
        back3.backgroundColor = UIColor.whiteColor()
        back3.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back3]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        schoolInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)
        
        
        back3.addSubview(schoolInfo)
        schoolInfo.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        schoolInfo.translatesAutoresizingMaskIntoConstraints = false
        schoolInfo.editable = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[schoolInfo]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[schoolInfo]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        
        contentView.addConstraints(constraints)
   
        
        contentView.addSubview(back4)
        back4.backgroundColor = BACK_COLOR//backColor
        back4.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back4]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: back4, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back3, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: back4, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        contentView.addConstraint(constraint)

        editMoreInfoLabel.text = "更多信息"
        editMoreInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        editMoreInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        back4.addSubview(editMoreInfoLabel)
        
        editMoreInfo.translatesAutoresizingMaskIntoConstraints = false
        editMoreInfo.image = UIImage(named: "edit")?.imageWithRenderingMode(.AlwaysTemplate)
        editMoreInfo.tintColor = THEME_COLOR
        editMoreInfo.userInteractionEnabled = true
        let tapEditMoreInfo = UITapGestureRecognizer(target: self, action: "editMoreInfo:")
        editMoreInfo.addGestureRecognizer(tapEditMoreInfo)
        back4.addSubview(editMoreInfo)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[editMoreInfoLabel]-[editMoreInfo(26)]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[editMoreInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: editMoreInfo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: editMoreInfo, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)

        
        
        
       
        contentView.addSubview(interestInfoLabel)
        interestInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        interestInfoLabel.text = "兴趣爱好"
        interestInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[interestInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: interestInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back4, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
       
        interestLabel.editable = false
        interestLabel.backgroundColor = UIColor.whiteColor()
        //interestLabel.textAlignment = NSTextAlignment.Justified
        interestLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        contentView.addSubview(interestLabel)
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
       

        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[interestLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: interestInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100)
        interestInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)
        //

        contentView.addSubview(requirementInfoLabel)
        requirementInfoLabel.translatesAutoresizingMaskIntoConstraints = false
       
        requirementInfoLabel.text = "理想类型"
        requirementInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[requirementInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: requirementInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: interestLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        
 
        requirementLabel.editable = false
        requirementLabel.backgroundColor = UIColor.whiteColor()
        // requirementLabel.textAlignment = NSTextAlignment.Center
        requirementLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        contentView.addSubview(requirementLabel)
        requirementLabel.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[requirementLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: requirementInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 100)
        requirementInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)

        
        seperator = UILabel()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = THEME_COLOR_BACK//UIColor.blackColor()
        contentView.addSubview(seperator)
        constraint = NSLayoutConstraint(item: seperator, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 2)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: seperator, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: requirementLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[seperator]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["seperator":seperator])
        contentView.addConstraints(constraints)
        
        
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        infoLabel.text = "  请保证个人资料中的信息真实有效，否则将取消参加资格，我们将根据报名情况进行筛选，通过手机短信告知您是否入选参加活动。"
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(infoLabel)
        let rect = (infoLabel.text! as NSString).boundingRectWithSize(CGSizeMake(view.frame.size.width-20, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:infoLabel.font], context: nil)
        //print(rect)
        constraint = NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: rect.size.height+10)
        contentView.addConstraint(constraint)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[infoLabel]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["infoLabel":infoLabel])
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: seperator, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        
        
        
        
        confirmButton.backgroundColor = THEME_COLOR//UIColor.redColor()
        confirmButton.setTitle("下一步", forState: UIControlState.Normal)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.layer.cornerRadius = 4.0
        confirmButton.addTarget(self, action: "confirm:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(confirmButton)
        
//        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[confirmButton(280@700)]-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//        contentView.addConstraints(constraints)
        confirmButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp_width).multipliedBy(4/5.0)
        }
        constraint = NSLayoutConstraint(item: confirmButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: confirmButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:infoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        contentView.addConstraint(constraint)
//        constraint = NSLayoutConstraint(item: confirmButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100)
//        contentView.addConstraint(constraint)
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(confirmButton.snp_bottom).priorityLow()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints(closure: { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
            })
        }
    }
    
    
    func confirm(sender:AnyObject!) {
        //print("confirm submit")
        
        guard nameInfoLabel.text?.characters.count > 0 && birthdayLabel.text?.characters.count > 0 && phoneNumberLabel.text?.characters.count > 0 && schoolInfo.text.characters.count > 0 && interestLabel.text.characters.count > 0  && requirementLabel.text.characters.count > 0 && hometownLabel.text?.characters.count > 0 else {
            let alert = UIAlertController(title: "提示", message: "报名申请，信息不能为空", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let uploadVC = UpLoadImageVC()
        uploadVC.id = id
        navigationController?.pushViewController(uploadVC, animated: true)
        
    }
    func editPersonalInfo(sender:AnyObject!) {
       // print("edit personal info")
        
        navigationController?.pushViewController(ModifyPersonalInfoVC(), animated: true)
    }
    
    func editSchoolInfo(sender:AnyObject!) {
        //print("edit school info")
        navigationController?.pushViewController(ModifySchoolInfoVC(), animated: true)
        
    }
    
    func editMoreInfo(sender:AnyObject) {
        //print("edit more info")
        navigationController?.pushViewController(ModifyMoreInfoVC(), animated: true)
    }
}


protocol ImageCollectionViewCellDelegate:class {
    func didTapDelete(cell:ImageCollectionViewCell)
}

class ImageCollectionViewCell:UICollectionViewCell {

    lazy var imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    weak var  delegate:ImageCollectionViewCellDelegate?
    
    lazy var overlay:UIImageView = {
        let overlay = UIImageView()
        overlay.contentMode = .ScaleAspectFill
        overlay.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:" )
        overlay.addGestureRecognizer(tapGesture)
        return overlay
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func tap(tapGesture:UITapGestureRecognizer) {
        let p = tapGesture.locationInView(self)
        if p.x >= bounds.size.width/2 && p.y <= bounds.size.height/2 {
            delegate?.didTapDelete(self)
        }
    }
    
    func initialize() {
        addSubview(imageView)
        addSubview(overlay)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        overlay.image = nil
        overlay.userInteractionEnabled = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        overlay.frame = bounds
    }
    
    
}



class ModifyMoreInfoVC: RegisterMoreInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.title = "完成"
        navigationItem.title = "修改信息"
        let profile = JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())

        interestView.text = profile["hobby"].string ?? ""
        requirementView.text = profile["preference"].string ?? ""
    }
    
    override func done(sender: AnyObject) {
        //print("done")
        
        guard interestView.text.characters.count > 0 && requirementView.text.characters.count > 0 else {
            let alert = UIAlertController(title: "提示", message: "兴趣爱好与理想类型不能为空", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        guard interestView.text.characters.count <= 100 && requirementView.text.characters.count <= 100 else {
            let alert = UIAlertController(title: "提示", message: "字数不能超过100字", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
            request(.POST, EDIT_PREFER_INFO_URL, parameters: ["token":token, "hobby":interestView.text,"preference":requirementView.text], encoding: .JSON).responseJSON{ (response) -> Void in
                
                //debugprint(response.request)
                //debugprint(response)
                
                if let d = response.result.value {
                    let json = JSON(d)
                    
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                }
                    
                else if let error = response.result.error {
                    let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                    
                }
                
            }
        }
        

    }
}

class ModifyPersonalInfoVC: RegisterPersonalInfoVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profile = JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())
        navigationItem.rightBarButtonItem?.title = "完成"
        title = "修改信息"
        //navigationItem.title = ""
        nameTextField.text = profile["name"].string ?? ""
        sexTextField.text = profile["gender"].string ?? ""
        birthDayTextField.text = profile["birthday"].string ?? ""
        phoneNumberTextField.text = profile["phone"].string  ?? ""
        wechatTextField.text = profile["wechat"].string ?? ""
        qqTextField.text = profile["qq"].string ?? ""
        hometownTextField.text = profile["hometown"].string ?? ""
    
        avatar.setImageWithURL(avatarURL()!)
        
    }
    
    
    override func next(sender: AnyObject) {
        //print("next")
        
        guard nameTextField.text?.characters.count > 0 && sexTextField.text?.characters.count > 0 && birthDayTextField.text?.characters.count > 0 && phoneNumberTextField.text?.characters.count > 0 else {
            let alert = UIAlertController(title: "提示", message: "信息不能为空", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard phoneNumberTextField.text?.characters.count == 11 else {
            let alert = UIAlertController(title: "提示", message: "号码长度应是11位的", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        guard nameTextField.text?.characters.count <= 4 else {
            let alert = UIAlertController(title: "提示", message: "请输入真实姓名", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if let t = token, id = myId {
            spinner.alpha = 1.0
            request(.POST, EDIT_PERSONAL_INFO_URL, parameters: ["token":t, "name":nameTextField.text!, "gender":sexTextField.text!, "birthday":birthDayTextField.text!, "phone":phoneNumberTextField.text!, "wechat":wechatTextField.text!, "qq":qqTextField.text!, "hometown":hometownTextField.text!], encoding: .JSON).responseJSON{ (response) -> Void in
                //debugprint(response)
                self.spinner.alpha = 0
                if let d = response.result.value {
                    let json = JSON(d)
                    
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        
                        upload(.POST, UPLOAD_AVATAR_URL, multipartFormData: { multipartFormData in
                                let dd = "{\"token\":\"\(t)\", \"type\":\"0\", \"number\":\"0\"}"
                                let jsonData = dd.dataUsingEncoding(NSUTF8StringEncoding)
                                let data = UIImageJPEGRepresentation(self.avatar.image!, 0.5)
                                multipartFormData.appendBodyPart(data:jsonData!, name:"json")
                                multipartFormData.appendBodyPart(data:data!, name:"avatar", fileName:"avatar.jpg", mimeType:"image/jpeg")
                            
                            }, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .Success(let upload, _ , _):
                                    upload.responseJSON { response in
                                        //debugPrint(response)
                                        if let d = response.result.value {
                                            let j = JSON(d)
                                            if j["state"].stringValue  == "successful" {
                                                SDImageCache.sharedImageCache().storeImage(self.avatar.image, forKey:avatarURLForID(id).absoluteString, toDisk:true)
                                                SDImageCache.sharedImageCache().removeImageForKey(thumbnailAvatarURLForID(id).absoluteString, fromDisk:true)

                                                self.navigationController?.popViewControllerAnimated(true)
                                            }
                                            else {
//                                                let alert = UIAlertController(title: "提示", message: j["reason"].stringValue, preferredStyle: .Alert)
//                                                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
//                                                self.presentViewController(alert, animated: true, completion: nil)
//                                                return
                                                
                                                self.navigationController?.popViewControllerAnimated(true)
  
                                            }
                                        }
                                        else if let error = response.result.error {
//                                            print("error")
//                                            let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
//                                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
//                                            self.presentViewController(alert, animated: true, completion: nil)
//                                            return
                                            self.navigationController?.popViewControllerAnimated(true)

                                            
                                        }
                                    }
                                    
                                case .Failure(let encodingError):
                                    //print(encodingError)
//                                    let alert = UIAlertController(title: "提示", message: "上载图片失败" , preferredStyle: .Alert)
//                                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
//                                    self.presentViewController(alert, animated: true, completion: nil)
//                                    return
                                    self.navigationController?.popViewControllerAnimated(true)

                                    
                                }
                            }
                            
                        )
                        
                        
                        
                    }
                    else {
                        let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        return
                        
                    }
                }
                else if let error = response.result.error {
                    let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                    
                }
            }
        }
        
    }
}

class ModifySchoolInfoVC: RegisterSchoolInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.title = "完成"
        navigationItem.title = "修改信息"
        let profile = JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())

        schoolTextField.text = profile["school"].string ?? ""
        departmentTextField.text = profile["department"].string ?? ""
        admissionYearTextField.text = profile["enrollment"].string ?? ""
        degreeTextField.text = profile["degree"].string ?? ""
        
    }
    
    override func next(sender: AnyObject) {
        if schoolTextField.text?.characters.count == 0 || degreeTextField.text?.characters.count == 0 ||
            departmentTextField.text?.characters.count == 0 || admissionYearTextField.text?.characters.count == 0 {
                let alert = UIAlertController(title: "提示", message: "信息不能为空", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
        }
        
        let year = Int(admissionYearTextField.text!)
        
        if admissionYearTextField.text?.characters.count != 4 || year == nil || (year! < 2000 || year! > 2015) {
            let alert = UIAlertController(title: "提示", message: "请输入正确的入学年份", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        //print("next")
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("TOKEN") {
            request(.POST, EDIT_SCHOOLINFO_URL, parameters: ["token":token, "school":schoolTextField.text!, "degree":degreeTextField.text!, "department":departmentTextField.text!, "enrollment":admissionYearTextField.text!], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                
                //debugprint(response)
                if let d = response.result.value {
                    let json = JSON(d)
                    
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    else {
                        let alert = UIAlertController(title: "提示", message: json["reason"].stringValue, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                    
                else if let error = response.result.error {
                    let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
                
            })
        }
        
        
    }
}
