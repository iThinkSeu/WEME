//
//  Me.swift
//  牵手东大
//
//  Created by liewli on 11/5/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class MeVC:UIViewController, UINavigationControllerDelegate {
    private var _view :UIScrollView!
    private var contentView :UIView!
    
    var avatar:UIImageView!
    var sex:UIImageView!
    var birthLabel:UILabel!
    var schoolLabel:UITextView!
    var interestLabel:UITextView!
    var requirementLabel:UITextView!
    var idLabel:UITextView!
    var nameInfoLabel:UILabel!
    var phoneNumberLabel:UILabel!
    var wechatLabel:UILabel!
    var qqLabel:UILabel!
    var hometownLabel:UILabel!
    
    var back:UIImageView!
    
    
    var refreshControl:UIRefreshControl!
    
    var schoolInfoHeightConstraint:NSLayoutConstraint!
    
    var interestInfoHeightConstraint:NSLayoutConstraint!
    
    var requirementInfoHeightConstraint:NSLayoutConstraint!
    
    lazy var spinner: UIActivityIndicatorView = {
        let activityIndicatorStyle: UIActivityIndicatorViewStyle = .WhiteLarge
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        spinner.color = UIColor.darkGrayColor()
        spinner.center = self.view.center
        spinner.startAnimating()
        spinner.alpha = 0
        return spinner
    }()
    
    private var profile:JSON?
    
    var friendID: String?
    
    var visualView:UIVisualEffectView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tabBarController?.tabBar.hidden = true
    
    
    
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        _view = UIScrollView()
        //_view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        _view.backgroundColor = BACK_COLOR
        view.addSubview(_view)
        // _view.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
      
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        
       
        
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        contentView.backgroundColor = BACK_COLOR
        _view.addSubview(contentView)
        // contentView.backgroundColor = UIColor.yellowColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        //
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "pullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        _view.addSubview(refreshControl)
        contentView.addSubview(spinner)
        
        if let _ = friendID {
            title = "个人信息"
        }
        else {
            title = "个人信息"
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "setting:")
        }
        
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
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
            if let id = friendID {
                request(.POST, GET_FRIEND_PROFILE_URL, parameters: ["token": token, "id":id], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        if json["state"].stringValue == "successful"  {
                            self.profile = json
                        }
                    }
                    
                    self.configUI()
                    self.refreshControl.endRefreshing()
                    
                })
            }
            else {
                request(.POST, GET_PROFILE_INFO_URL, parameters: ["token":token], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                    //debugPrint(response)
                    if let d = response.result.value {
                        
                        let json = JSON(d)
                        if json["state"] == "successful" {
                            //self.profile = json
                            NSUserDefaults.standardUserDefaults().setValue(d, forKey: PROFILE)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            self?.profile = JSON(NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) ?? NSNull())
                            
                        }
                    }
                    
                    //                else if let error = response.result.error {
                    //
                    //                }
                    self?.configUI()
                    
                    self?.refreshControl.endRefreshing()
                }
            }
            
        }
        
    }
    
    func setting(sender:AnyObject) {
        //print("setting")
        if let _ = friendID {
            
        }
        else {
            
            navigationController?.pushViewController(SettingVC(), animated: true)
        }
    }
    
    
    
    func configUI() {
        if let id = friendID {
            let url = thumbnailAvatarURLForID(id)
            avatar.setImageWithURL(url, placeholder:nil)
            let back_url = profileBackgroundURLForID(id)
            //back.setImageWithURL(back_url, placeholder: UIImage(named: "profile_background"), animated: true, isAvatar: false)
            back.hnk_setImageFromURL(back_url, placeholder: UIImage(named: "profile_background"))
            
        }
        else {
            let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let path = documents.stringByAppendingString("/profile_background.jpg")
            let avatar_path = documents.stringByAppendingString("/avatar.jpg")
            let url = thumbnailAvatarURL()!
            
            avatar.setImageWithURL(url, placeholder: NSFileManager.defaultManager().fileExistsAtPath(avatar_path) ? UIImage(contentsOfFile: avatar_path) : UIImage(named: "avatar"), animated: true, isAvatar: true, completion: {
                (image, flag) in
                if let img = image {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        if flag {
                            saveAvatarImage(img, scale: 1.0)
                        }
                        dispatch_async(dispatch_get_main_queue()
                            , { () -> Void in
                                self.avatar.image = img
                        })
                        
                    }
                    
                }
                else {
                    if (NSFileManager.defaultManager().fileExistsAtPath(avatar_path)) {
                        self.avatar.image = UIImage(contentsOfFile: avatar_path)
                    }
                }
            })
            
            let back_url = profileBackgroundURL()!
            
            back.setImageWithURL(back_url, placeholder: NSFileManager.defaultManager().fileExistsAtPath(path) ?UIImage(contentsOfFile: path) : UIImage(named: "profile_background"), animated: true, isAvatar: false, completion: {
                (image, flag) in
                if let img = image {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        if flag {
                            saveProfileBackgroundImage(img, scale:1.0)
                        }
                        dispatch_async(dispatch_get_main_queue()
                            , { () -> Void in
                                self.back.image = img
                        })
                        
                        
                    }
                    
                }
                else {
                    if (NSFileManager.defaultManager().fileExistsAtPath(path)) {
                        //print("exists")
                        self.back.image = UIImage(contentsOfFile: path)
                    }
                }
            })
            //  }
            //back.hnk_setImageFromURL(profileBackgroundURL()!, placeholder: UIImage(named: "profile_background"))
            if profile == nil {
                if let d = NSUserDefaults.standardUserDefaults().valueForKey(PROFILE) {
                    profile = JSON(d)
                }
            }
            
        }
        
        
        
        if let gender = profile?["gender"].string {
            if gender == "男" {
                sex.image = UIImage(named: "male")
            }
            else if gender == "女"{
                sex.image = UIImage(named: "female")
            }
            else {
                sex.image = nil
            }
        }
        
        birthLabel.text =  (profile?["birthday"].string ?? "")
        let schoolinfo = ["school", "department", "enrollment", "degree"]
        var ss = ""
        for s in schoolinfo {
            ss += (profile?[s].string ?? "") + "  "
        }
        schoolLabel.text = ss
        
        nameInfoLabel.text = profile?["name"].string ?? ""
        phoneNumberLabel.text = profile?["phone"].string ?? ""
        wechatLabel.text = profile?["wechat"].string ?? ""
        qqLabel.text = profile?["qq"].string ?? ""
        hometownLabel.text = profile?["hometown"].string ?? " "
        hometownLabel.resizeHeightWithSnapKit()
        
        
        schoolLabel.resizeHeightToFit(schoolInfoHeightConstraint)
        interestLabel.text = profile?["hobby"].string ?? ""
        interestLabel.resizeHeightToFit(interestInfoHeightConstraint)
        
        requirementLabel.text = profile?["preference"].string ?? ""
        requirementLabel.resizeHeightToFit(requirementInfoHeightConstraint)
        
        //idLabel.text = "ID : " + (profile?["id"].stringValue ?? "") + " \n详细资料让你更方便交朋友"
        idLabel.text = "ID : " + (profile?["id"].stringValue ?? " ") + " \n详细资料让你更方便交朋友"
        
        
    }
    
    func tapAvatar(sender:AnyObject) {
        if let id = friendID {
            let url = avatarURLForID(id)
            let agrume = Agrume(imageURL:url)
            agrume.showFrom(self)
            
        }
        else {
            let url = avatarURL()
            let agrume = Agrume(imageURL:url!)
            agrume.showFrom(self)
            
        }
    }
    
    func tapProfileBack(sender:AnyObject){
        if let id = friendID {
            
        }
        else {
            
//            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//            actionSheet.addAction(UIAlertAction(title: "更换封面", style: .Default, handler: { (action) -> Void in
//                let imagePicker = UIImagePickerController()
//                imagePicker.navigationBar.barStyle = .Black
//                imagePicker.sourceType = .PhotoLibrary
//                imagePicker.delegate = self
//                self.presentViewController(imagePicker, animated: true, completion: nil)
//            }))
//            actionSheet.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }))
//            actionSheet.view.tintColor = THEME_COLOR//UIColor.redColor()
//            if self.traitCollection.horizontalSizeClass == .Compact {
//                self.presentViewController(actionSheet, animated: true,completion: nil)
//            }
//            else {
//                if let popVC = actionSheet.popoverPresentationController {
//                    let v = (sender as! UITapGestureRecognizer).view!
//                    popVC.sourceView = v
//                    popVC.sourceRect  = v.bounds
//                    popVC.permittedArrowDirections = .Any
//                    self.presentViewController(actionSheet, animated: true, completion: nil)
//                }
//            }
            
            let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
                    if index == 0 {
                        let imagePicker = UIImagePickerController()
                        imagePicker.navigationBar.barStyle = .Black
                        imagePicker.sourceType = .PhotoLibrary
                        imagePicker.delegate = self
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    }
                }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["改变封面"])
            sheet.setButtonTextColor(THEME_COLOR)
            sheet.showInView((UIApplication.sharedApplication().delegate?.window)!)
            
        }
    }
    
    func loadUI() {
        
        //  edgesForExtendedLayout = .None
        // let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        var constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        //        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        //        view.addConstraint(constraint)
        //
        //        contentView.snp_makeConstraints { (make) -> Void in
        //            make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityLow()
        //        }
        //view.backgroundColor = backColor
        
        back = UIImageView()
        back.userInteractionEnabled = true
        let tapBack = UITapGestureRecognizer(target: self, action: "tapProfileBack:")
        back.addGestureRecognizer(tapBack)
        var viewDict:[String:UIView] = ["profile_background":back]
        back.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back)
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[profile_background]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        //        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 240)
        //        contentView.addConstraint(constraint)
        back.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(back.snp_width).multipliedBy(3/4.0)
        }
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        //        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        //        contentView.addConstraint(constraint)
        
        avatar = UIImageView()
        contentView.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        viewDict["avatar"] = avatar
        //avatar.layer.shadowColor = UIColor.blackColor().CGColor
        //avatar.layer.shadowOffset = CGSizeMake(5, 5)
        //avatar.layer.shadowOpacity = 0.5
        avatar.layer.cornerRadius = 4.0
        avatar.layer.masksToBounds = true
        let tapAvatarGesture = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        avatar.addGestureRecognizer(tapAvatarGesture)
        avatar.userInteractionEnabled  = true
        
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 80)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 80)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -84)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -10)
        contentView.addConstraint(constraint)
        
        let personalInfoBack = UILabel()
        personalInfoBack.backgroundColor = BACK_COLOR//backColor
        personalInfoBack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(personalInfoBack)
        viewDict["personalInfoBack"] = personalInfoBack
        personalInfoBack.text = "个人信息"
        personalInfoBack.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[personalInfoBack]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: personalInfoBack, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        contentView.addConstraint(constraint)
        
        
        constraint = NSLayoutConstraint(item: personalInfoBack, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        
        
        
        //
        let back1 = UIView()
        contentView.addSubview(back1)
        back1.translatesAutoresizingMaskIntoConstraints = false
        back1.backgroundColor = UIColor.whiteColor()
        viewDict["back1"] = back1
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: personalInfoBack, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        contentView.addConstraint(constraint)
        
        sex = UIImageView()
        back1.addSubview(sex)
        sex.translatesAutoresizingMaskIntoConstraints = false
        viewDict["sex"] = sex
        
        nameInfoLabel = UILabel()
        back1.addSubview(nameInfoLabel)
        nameInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        viewDict["nameInfoLabel"] = nameInfoLabel
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[nameInfoLabel]", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewDict)
        back1.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: nameInfoLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back1.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: sex, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 18)
        back1.addConstraint(constraint)
        //
        birthLabel = UILabel()
        //birthLabel.text = "1992-12-18 射手座"
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        back1.addSubview(birthLabel)
        viewDict["birthLabel"] = birthLabel
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[sex(==16)]-[birthLabel]-20-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        back1.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: birthLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back1.addConstraint(constraint)
        
        
        let contactInfoLabel = UILabel()
        contactInfoLabel.backgroundColor = BACK_COLOR//backColor
        contactInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactInfoLabel)
        viewDict["contactInfoLabel"] = contactInfoLabel
        contactInfoLabel.text = "联系方式"
        contactInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[contactInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: contactInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contactInfoLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        contentView.addConstraint(constraint)
        
        
        
        let contactInfoBack = UIView()
        contactInfoBack.backgroundColor = UIColor.whiteColor()
        contactInfoBack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactInfoBack)
        viewDict["contactInfoBack"] = contactInfoBack
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contactInfoBack]-0-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: contactInfoBack, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contactInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        
        contentView.addConstraint(constraint)
        //        constraint = NSLayoutConstraint(item: contactInfoBack, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        //        contentView.addConstraint(constraint)
        
        
        let phoneNumberInfoLabel = UILabel()
        phoneNumberLabel = UILabel()
        phoneNumberInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contactInfoBack.addSubview(phoneNumberLabel)
        contactInfoBack.addSubview(phoneNumberInfoLabel)
        
        viewDict["phoneNumberInfoLabel"] = phoneNumberInfoLabel
        viewDict["phoneNumberLabel"] = phoneNumberLabel
        
        phoneNumberInfoLabel.text = "手机号"
        phoneNumberLabel.textAlignment = .Right
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[phoneNumberInfoLabel(30@500)]-[phoneNumberLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        
        //        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[phoneNumberInfoLabel]-|", options: NSLayoutFormatOptions.AlignAllFirstBaseline, metrics: nil, views: viewDict)
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
        hometownLabel.numberOfLines = 0
        hometownLabel.textAlignment = .Right
        hometownLabel.lineBreakMode = .ByWordWrapping
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        geoInfoBack.addSubview(hometownLabel)
        
        hometownInfoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(geoInfoBack.snp_leftMargin)
            make.top.equalTo(geoInfoBack.snp_topMargin)
            make.width.equalTo(40).priorityHigh()
            //make.centerY.equalTo(hometownLabel.snp_centerY)
            make.bottom.equalTo(geoInfoBack.snp_bottomMargin)
        }
        
        hometownLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(geoInfoBack.snp_rightMargin)
            make.left.equalTo(hometownInfoLabel.snp_right).offset(5)
            make.top.equalTo(geoInfoBack.snp_top)
            make.bottom.equalTo(geoInfoBack.snp_bottom)
        }
        
        //
        let schoolInfoLabel = UILabel()
        contentView.addSubview(schoolInfoLabel)
        schoolInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        schoolInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        viewDict["schoolInfoLabel"] = schoolInfoLabel
        schoolInfoLabel.text = "学校信息"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[schoolInfoLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: schoolInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: geoInfoBack, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        schoolLabel = UITextView()
        schoolLabel.editable = false
        schoolLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        schoolLabel.backgroundColor = UIColor.whiteColor()
        //schoolLabel.textAlignment = NSTextAlignment.Center
        contentView.addSubview(schoolLabel)
        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        //schoolLabel.text = "东南大学 \t 2014级 \t 自动化学院 \t 研究生"
        viewDict["schoolLabel"] = schoolLabel
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[schoolLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: schoolLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: schoolInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: schoolLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
        schoolInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)
        //
        let interestInfoLabel = UILabel()
        contentView.addSubview(interestInfoLabel)
        interestInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        interestInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        viewDict["interestInfoLabel"] = interestInfoLabel
        interestInfoLabel.text = "兴趣爱好"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[interestInfoLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: interestInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: schoolLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        interestLabel = UITextView()
        interestLabel.editable = false
        interestLabel.backgroundColor = UIColor.whiteColor()
        //interestLabel.textAlignment = NSTextAlignment.Justified
        interestLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(interestLabel)
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        //interestLabel.text = "人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。"
        viewDict["interestLabel"] = interestLabel
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[interestLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: interestInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 80)
        interestInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)
        //
        let requirementInfoLabel = UILabel()
        contentView.addSubview(requirementInfoLabel)
        requirementInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        requirementInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        viewDict["requirementInfoLabel"] = requirementInfoLabel
        requirementInfoLabel.text = "理想类型"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[requirementInfoLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: requirementInfoLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: interestLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        
        requirementLabel = UITextView()
        requirementLabel.editable = false
        requirementLabel.backgroundColor = UIColor.whiteColor()
        // requirementLabel.textAlignment = NSTextAlignment.Center
        requirementLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(requirementLabel)
        requirementLabel.translatesAutoresizingMaskIntoConstraints = false
        //requirementLabel.text = "人生若只如初见，何事秋风悲画扇。等闲变却故人心，却道故人心易变。骊山语罢清宵半，泪雨零铃终不怨。何如薄幸锦衣郎，比翼连枝当日愿。"
        viewDict["requirementLabel"] = requirementLabel
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[requirementLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: requirementInfoLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 80)
        requirementInfoHeightConstraint = constraint
        contentView.addConstraint(constraint)
        //
        let back2 = UIView()
        contentView.addSubview(back2)
        //back2.backgroundColor = UIColor.whiteColor()
        back2.translatesAutoresizingMaskIntoConstraints = false
        viewDict["back2"] = back2
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back2]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: requirementLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        
        //        let recentLabel = UILabel()
        //        recentLabel.text = "最近来访"
        //        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        //        recentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        //        viewDict["recentLabel"] = recentLabel
        //        back2.addSubview(recentLabel)
        //        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[recentLabel]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        //        back2.addConstraints(constraints)
        //        constraint = NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //        back2.addConstraint(constraint)
        //        constraint = NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 26)
        //        back2.addConstraint(constraint)
        //
        //        for k in 0..<3 {
        //            let visitor = UIImageView(image: UIImage(named: "avatar"))
        //            back2.addSubview(visitor)
        //            viewDict["visitor\(k)"] = visitor
        //            visitor.layer.cornerRadius = 30/2;
        //            visitor.layer.masksToBounds = true
        //            visitor.layer.borderWidth = 2.0
        //            visitor.layer.borderColor = UIColor.whiteColor().CGColor
        //            visitor.translatesAutoresizingMaskIntoConstraints = false
        //            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[visitor\(k)(==30)]-\(35*k+5)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        //            back2.addConstraints(constraints)
        //            constraint = NSLayoutConstraint(item: visitor, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //            back2.addConstraint(constraint)
        //            constraint = NSLayoutConstraint(item: visitor, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        //            back2.addConstraint(constraint)
        //
        //        }
        //
        
        
        idLabel = UITextView()
        idLabel.editable = false
        idLabel.backgroundColor = UIColor.whiteColor()
        idLabel.textAlignment = NSTextAlignment.Center
        //Label.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(idLabel)
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        //idLabel.text = "ID : 1995126 \n详细资料让你更方便交朋友"
        viewDict["idLabel"] = idLabel
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[idLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        contentView.addConstraints(constraints)
        constraint = NSLayoutConstraint(item: idLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        contentView.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: idLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        contentView.addConstraint(constraint)
        
        //        constraint = NSLayoutConstraint(item: idLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100)
        //        contentView.addConstraint(constraint)
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(idLabel.snp_bottom).priorityLow()
        }
        //        contentView.snp_makeConstraints { (make) -> Void in
        //            make.height.greaterThanOrEqualTo(view.snp_height).offset(5)
        //        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print(contentView.frame.size.height)
        // print(_view.contentSize.height)
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
                _view.layoutIfNeeded()
            }
            
        }
    }
}


