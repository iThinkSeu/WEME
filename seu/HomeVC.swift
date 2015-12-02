//
//  HomeVC.swift
//  seu
//
//  Created by liewli on 9/13/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

import UIKit
import RSKImageCropper


class HomeVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        //tabBar.tintColor = THEME_COLOR
        //navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        loadUI()
        checkForUpdates()
    }
    
    func checkForUpdates() {
        let infoDict = (NSBundle.mainBundle().infoDictionary)!
        let currentVersion = infoDict["CFBundleShortVersionString"] as! String
        request(.GET, APP_INFO_URL).responseJSON { (response) -> Void in
            if let d = response.result.value {
                let json = JSON(d)
                if json["results"].array?.count > 0 {
                    let info = json["results"][0]
                    if info["version"].stringValue.compare(currentVersion) == NSComparisonResult.OrderedDescending {
                        let alert = UIAlertController(title: "提示", message: "发现新版本", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "下次再说", style: .Default, handler: { (action) -> Void in
                            
                        }))
                        alert.addAction(UIAlertAction(title: "马上去更新", style: .Default, handler: { (action) -> Void in
                            let url = info["trackViewUrl"].stringValue
                            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                        }))
                        alert.view.tintColor = UIColor.redColor()
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
        
    }

    
    func loadUI() {
        let navHand = UINavigationController(rootViewController: HandVC())
        let navContacts =  UINavigationController(rootViewController: ContactsVC())
        let navSocial = UINavigationController(rootViewController: SocialVC())
        //let navMe = UINavigationController(rootViewController: PersonalInfoVC())
        let Me =  UINavigationController(rootViewController: MeVC())

        
        setViewControllers([navHand, navSocial,navContacts, Me], animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.colorFromRGB(0xEE3B3B)], forState: UIControlState.Selected)
        tabBar.tintColor = UIColor.colorFromRGB(0xEE3B3B)//UIColor.redColor()
        UINavigationBar.appearance().barTintColor =  THEME_COLOR//UIColor.blackColor()//UIColor.colorFromRGB(0x104E8B)//UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        selectedIndex = 0
        

        navHand.tabBarItem = UITabBarItem(title: "牵手", image: UIImage(named: "hand_inactive"), selectedImage: UIImage(named: "hand_active"))
        navContacts.tabBarItem = UITabBarItem(title: "联系人", image: UIImage(named: "contacts_inactive"), selectedImage: UIImage(named: "contacts_active"))
        navSocial.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "discovery_inactive"), selectedImage: UIImage(named: "discovery_active"))
        
        Me.tabBarItem = UITabBarItem(title: "我", image: UIImage(named: "me_inactive"), selectedImage: UIImage(named: "me_active"))

        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}




class DiscoveryVC:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "遇见"
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        
        
        let board = UILabel()
        board.backgroundColor = UIColor.whiteColor()
        board.translatesAutoresizingMaskIntoConstraints = false
        board.numberOfLines = 0
        board.font = UIFont.systemFontOfSize(20)
        board.lineBreakMode = NSLineBreakMode.ByWordWrapping
        board.layer.cornerRadius = 4.0
        board.layer.borderColor = UIColor.blackColor().CGColor
        board.layer.borderWidth = 1.0
        view.addSubview(board)
        
        board.text = "遇见模块正在紧急的赶工之中，下个版本就能和大家见面，请大家及时更新，灰常感谢～～～"
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-2-[board]-2-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["board":board])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: board, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10)
        view.addConstraint(constraint)
        
        let rect = (board.text! as NSString).boundingRectWithSize(CGSizeMake(view.frame.size.width-20, CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:board.font], context: nil)
        //print(rect)
        constraint = NSLayoutConstraint(item: board, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: rect.size.height + 20)
       view.addConstraint(constraint)
        

    }
}

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
       
        if let _ = friendID {
            tabBarController?.tabBar.hidden = true
        }
        else {
            tabBarController?.tabBar.hidden = false
        }
        
        if let _ = friendID {
            //print("called")
            navigationController?.navigationBar.translucent = true
            navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationController?.navigationBar.barStyle = .Black
            //            let bounds = self.navigationController?.navigationBar.bounds as CGRect!
            //            let blurEffect = UIBlurEffect(style: .Light)
            //            visualView = UIVisualEffectView(effect: blurEffect)
            //            visualView?.frame = CGRectMake(0, bounds.height - 64, SCREEN_WIDTH, 64)
            //            visualView?.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            //            visualView?.userInteractionEnabled = false
            //            navigationController?.navigationBar.insertSubview(visualView!, atIndex: 0)
        }
        else {
            
        }

        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if let _ = friendID {
//            tabBarController?.tabBar.hidden = true
//        }
//        else {
//            tabBarController?.tabBar.hidden = false
//        }
         //refresh()
    }
//
//
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.hidden = true
//    }
//    

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
        if let _ = friendID {
            let constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
        }
        else {
            let constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
        }
        
        let constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: "setting:")
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
                        if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
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
                        if json["state"] == "successful" || json["state"] == "sucessful" {
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
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "更换封面", style: .Default, handler: { (action) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.navigationBar.barStyle = .Black
                imagePicker.sourceType = .PhotoLibrary
                imagePicker.delegate = self
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
            actionSheet.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            actionSheet.view.tintColor = UIColor.redColor()
            if self.traitCollection.horizontalSizeClass == .Compact {
                self.presentViewController(actionSheet, animated: true,completion: nil)
            }
            else {
                if let popVC = actionSheet.popoverPresentationController {
                    let v = (sender as! UITapGestureRecognizer).view!
                    popVC.sourceView = v
                    popVC.sourceRect  = v.bounds
                    popVC.permittedArrowDirections = .Any
                    self.presentViewController(actionSheet, animated: true, completion: nil)
                }
            }

        }
    }
    
    func loadUI() {
       
      //  edgesForExtendedLayout = .None
        let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
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
        personalInfoBack.backgroundColor = backColor
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
        contactInfoLabel.backgroundColor = backColor
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

func saveProfileBackgroundImage(image:UIImage, scale:CGFloat = 1.0) {
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let path = documents.stringByAppendingString("/profile_background.jpg")
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        }
        catch {
            
        }
    }
    
    if let _ =  UIImageJPEGRepresentation(image, scale)?.writeToFile(path, atomically: true) {
        print("save profile succeed")
    }
    else {
        print("save profile failed")
    }
}

func saveAvatarImage(image:UIImage, scale:CGFloat = 1.0) {
    let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let avatar_path = documents.stringByAppendingString("/avatar.jpg")
    if NSFileManager.defaultManager().fileExistsAtPath(avatar_path) {
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(avatar_path)
        }
        catch {
            
        }
    }
    

    if let _ = UIImageJPEGRepresentation(image, scale)?.writeToFile(avatar_path, atomically: true) {
        print("save avatar succeed")
    }
    else {
        print("save avatar failed")
    }
}

extension MeVC:UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            self.dismissViewControllerAnimated(true, completion: nil)
            let cropper = RSKImageCropViewController(image: image, cropMode:.Custom)
            cropper.delegate = self
            cropper.dataSource = self
            presentViewController(cropper, animated: true, completion: nil)
        
    }
}

extension MeVC:RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource{
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        dismissViewControllerAnimated(true, completion: nil)
        self.back.image = croppedImage
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            saveProfileBackgroundImage(croppedImage, scale:1.0)
        }
        
        if let token = NSUserDefaults.standardUserDefaults().stringForKey(TOKEN),
            let id =  NSUserDefaults.standardUserDefaults().stringForKey(ID){
                spinner.alpha = 1.0
                upload(.POST, UPLOAD_AVATAR_URL, multipartFormData: { multipartFormData in
                    
                    //let dd = ["token":token]
                    //do {
                    //let jsonData = try NSJSONSerialization.dataWithJSONObject(dd, options: NSJSONWritingOptions.Prettyprinted)
                    let dd = "{\"token\":\"\(token)\", \"type\":\"-1\", \"number\":\"1\"}"
                    let jsonData = dd.dataUsingEncoding(NSUTF8StringEncoding)
                    let data = UIImageJPEGRepresentation(croppedImage, 0.75)
                    multipartFormData.appendBodyPart(data:jsonData!, name:"json")
                    multipartFormData.appendBodyPart(data:data!, name:"avatar", fileName:"avatar.jpg", mimeType:"image/jpeg")
                    // }
                    //catch  {
                    
                    // }
                    
                    }, encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _ , _):
                            upload.responseJSON { response in
                                //debugPrint(response)
                                if let d = response.result.value {
                                    let j = JSON(d)
                                    if j["state"].stringValue  == "successful" {
                                        self.spinner.alpha = 0
                                        //self.navigationController?.popViewControllerAnimated(true)
                                        self.back.setImageWithURL(profileBackgroundURLForID(id), placeholder: nil, animated: false, isAvatar: false, completion:{
                                            (image, flag) in
                                            if let img = image {
                                                //print("write fetched image")
                                                if (flag) {
                                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                                                        saveProfileBackgroundImage(img, scale:1.0)
                                                    }
                                                }
                                            }
                                        })
                                        //self.back.hnk_setImageFromURL(profileBackgroundURLForID(id))
                                    }
                                    else {
                                        self.spinner.alpha = 0
                                        let alert = UIAlertController(title: "提示", message: j["reason"].stringValue, preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                        return
                                        
                                        //self.navigationController?.popViewControllerAnimated(true)
                                        
                                    }
                                }
                                else if let error = response.result.error {
                                    self.spinner.alpha = 0
                                    let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    return
                                    //self.navigationController?.popViewControllerAnimated(true)
                                    
                                    
                                }
                            }
                            
                        case .Failure:
                            //print(encodingError)
                            self.spinner.alpha = 0
                            let alert = UIAlertController(title: "提示", message: "上载图片失败" , preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                            return
                            //self.navigationController?.popViewControllerAnimated(true)
                            
                            
                        }
                    }
                    
                )
                
                
                
        }
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController!) -> CGRect {
        return CGRectMake(view.center.x - back.bounds.size.width/2, view.center.y-back.bounds.size.height/2, back.bounds.size.width, back.bounds.size.height)
    }
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController!) -> UIBezierPath! {
        return UIBezierPath(rect: CGRectMake(view.center.x - back.bounds.size.width/2, view.center.y-back.bounds.size.height/2, back.bounds.size.width, back.bounds.size.height))
    }
}


class SettingVC :UITableViewController {
    private let setting = ["修改个人信息", "关于牵手东大"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //tabBarController?.tabBar.hidden = true
        title = "设置"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        let footer = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 60))
        tableView.tableFooterView = footer

        
        let logout = UIButton()
        footer.addSubview(logout)
        logout.translatesAutoresizingMaskIntoConstraints = false
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[logout]-20-|", options: NSLayoutFormatOptions.AlignAllLastBaseline, metrics: nil, views: ["logout":logout])
        footer.addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: logout, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: footer, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        footer.addConstraint(constraint)
        logout.layer.cornerRadius = 5.0
        logout.backgroundColor = UIColor.redColor()
        logout.setTitle("退出登录", forState: UIControlState.Normal)
        logout.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
       
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    func logout(sender : AnyObject) {
        //print("logout")
        NSUserDefaults.standardUserDefaults().removeObjectForKey(TOKEN)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ID)
        NSUserDefaults.standardUserDefaults().synchronize()
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let path = documents.stringByAppendingString("/profile_background.jpg")
        let avatar_path = documents.stringByAppendingString("/avatar.jpg")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
            catch {
                print("cannot delete profile")
            }
        }
        
        if NSFileManager.defaultManager().fileExistsAtPath(avatar_path) {
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(avatar_path)
            }
            catch {
                print("cannot delete avatar")
            }
        }

        
        
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = UINavigationController(rootViewController: LoginRegisterVC())

    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath)

        cell.textLabel?.text = setting[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
     
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            //navigationController?.pushViewController(ChangeInfoVC(), animated: true)
            let nav = UINavigationController(rootViewController: ChangeInfoVC())
            presentViewController(nav, animated: true, completion: nil)
        }
        else {
            //navigationController?.pushViewController(AboutVC(), animated: true)
            let nav = UINavigationController(rootViewController: AboutVC())
            presentViewController(nav, animated: true, completion: nil)
        }
    }
}


class AboutCollectionViewCell:UICollectionViewCell {

    
    lazy var avatar:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    
    func initialize() {
    
        
        //avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 4.0
       // avatar.layer.cornerRadius = 30
       // avatar.layer.masksToBounds = true
        addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        addSubview(nameLabel)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        infoLabel.textColor = UIColor.lightGrayColor()
        addSubview(infoLabel)
        
       
        
        
        let viewDict = ["avatar" : avatar, "nameLabel":nameLabel, "infoLabel":infoLabel]
        
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[avatar(40)]", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        var constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        
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
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[nameLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[infoLabel]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        addConstraints(constraints)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    
}


class AboutVC:UIViewController {
    private var _view :UIScrollView!
    private var contentView :UIView!


    private(set) lazy var peopleCollectionView:UICollectionView = {
        let imageCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        imageCollectionView.dataSource = self
        imageCollectionView.delegate  = self
        imageCollectionView.registerClass(AboutCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AboutCollectionViewCell))
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        imageCollectionView.backgroundColor = UIColor.whiteColor()
        return imageCollectionView
        }()
    

    private let dev_name = ["李磊", "叶庆仕", "刘历", "宋嘉冀", "马申斌"]
    private let dev_info = ["产品经理", "后台开发", "iOS开发", "Android开发", "UI设计师"]
    private let dev_img = ["dev_lilei", "dev_yeqingshi", "dev_liuli", "dev_songjiaji", "dev_mashenbin"]
    
    
    func cancel(sender:AnyObject?) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if peopleCollectionView.frame.size.height > peopleCollectionView.collectionViewLayout.collectionViewContentSize().height {
            peopleCollectionView.snp_updateConstraints(closure: { (make) -> Void in
                make.height.equalTo(peopleCollectionView.collectionViewLayout.collectionViewContentSize().height)
                self.view.layoutIfNeeded()
            })
        }
        
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints(closure: { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.barStyle = .Black
        
        let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
    
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "cancel:")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "cancel:")
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        _view = UIScrollView()
        // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        _view.backgroundColor = backColor
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        contentView.backgroundColor = backColor
        _view.addSubview(contentView)
        // contentView.backgroundColor = UIColor.yellowColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)

        //

        title = "关于牵手"
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        automaticallyAdjustsScrollViewInsets = false
        
        contentView.addSubview(peopleCollectionView)
        
        peopleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[peopleCollectionView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["peopleCollectionView":peopleCollectionView])
        view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: peopleCollectionView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute:NSLayoutAttribute.Top , multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        
//        let constrint_h = NSLayoutConstraint(item: peopleCollectionView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200)
//        view.addConstraint(constrint_h)
        
        peopleCollectionView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(200)
        }
        let contactLabel = UILabel()
        contactLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contactLabel)
        contactLabel.numberOfLines = 0
        contactLabel.lineBreakMode = .ByCharWrapping
        contactLabel.backgroundColor = UIColor.whiteColor()
        contactLabel.textAlignment = .Center
        contactLabel.text = "  如果有问题咨询我们，请发邮件至邮箱: \n  leilee1992@163.com"
       // contactLabel.textColor = UIColor.lightGrayColor()
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contact]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["contact":contactLabel])
        view.addConstraints(constraints)
        let rect = (contactLabel.text! as NSString).boundingRectWithSize(CGSizeMake(view.frame.size.width-20, CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : contactLabel.font], context: nil)
        
        constraint = NSLayoutConstraint(item: contactLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: rect.height + 20)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contactLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: peopleCollectionView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        
        let thanksLabel = UILabel()
        thanksLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thanksLabel)
        thanksLabel.text = "特别感谢"
        thanksLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[thanks]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["thanks":thanksLabel])
        view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item:thanksLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: thanksLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contactLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 2)
        view.addConstraint(constraint)
        
        
        let peopleLabel = UILabel()
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(peopleLabel)
        peopleLabel.numberOfLines = 0
        peopleLabel.backgroundColor = UIColor.whiteColor()
        peopleLabel.lineBreakMode = .ByWordWrapping
        peopleLabel.textAlignment = .Center
        peopleLabel.text = "杨骁  黄洲荣  李多  王哲\n路娟 张炜森  刘安国  吴浩\n李建宇 王阳  姚舜  杨荆轲"
        peopleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[people]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["people":peopleLabel])
        view.addConstraints(constraints)
        let rc = (peopleLabel.text! as NSString).boundingRectWithSize(CGSizeMake(view.frame.size.width-20, CGFloat.max), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : peopleLabel.font], context: nil)
        
        constraint = NSLayoutConstraint(item: peopleLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: rc.height + 20)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: peopleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: thanksLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraint(constraint)
        
//        constraint = NSLayoutConstraint(item: peopleLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -300)
//        view.addConstraint(constraint)
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(peopleLabel.snp_bottom).priorityLow()
        }
//        contentView.snp_makeConstraints { (make) -> Void in
//            make.height.greaterThanOrEqualTo(view.snp_height).offset(5)
//        }

        

    }
   
}


extension AboutVC: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dev_name.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(AboutCollectionViewCell), forIndexPath: indexPath) as! AboutCollectionViewCell
        cell.avatar.image = UIImage(named: dev_img[indexPath.item])
        cell.nameLabel.text = dev_name[indexPath.item]
        cell.infoLabel.text = dev_info[indexPath.item]
        
        return cell
        
    }
}

extension AboutVC: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let agrume = Agrume(image: UIImage(named: dev_img[indexPath.item] )!)
        agrume.showFrom(self)

    }
}

extension AboutVC: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(140, 60)
    }
    
   
}

class ChangeInfoVC:ActivityRegisterVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "修改个人信息"
        seperator.hidden = true
        confirmButton.hidden = true
        infoLabel.hidden = true
        
        if let pvc = presentingViewController {
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "done:")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "done:")
            navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        }
    }
    
    func done(sender:AnyObject?) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}


