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
                        alert.view.tintColor = THEME_COLOR//UIColor.redColor()
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
        
    }

    
    func loadUI() {
        let navHand = UINavigationController(rootViewController: ActivityVC())
        //let navContacts =  UINavigationController(rootViewController: ContactsVC())
        let navSocial = UINavigationController(rootViewController: SocialVC())
        //let navMe = UINavigationController(rootViewController: PersonalInfoVC())
        let Me =  UINavigationController(rootViewController: ProfileVC())
        
        let food = CardVC()

        
        setViewControllers([navHand, navSocial, food, Me], animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:THEME_COLOR], forState: UIControlState.Selected)
        tabBar.tintColor = THEME_COLOR//UIColor.colorFromRGB(0x6A5ACD)//UIColor.colorFromRGB(0x32CD32)//UIColor.colorFromRGB(0xEE3B3B)//UIColor.redColor()
        tabBar.backgroundColor = UIColor.whiteColor()
        //tabBar.translucent = false
        UINavigationBar.appearance().barTintColor =  THEME_COLOR//UIColor.blackColor()//UIColor.colorFromRGB(0x104E8B)//UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        selectedIndex = 0
        
        //let hand_active = UIImage(named: "hand_inactive")?.imageWithRenderingMode(.AlwaysTemplate)
        
        navHand.tabBarItem = UITabBarItem(title: "活动", image: UIImage(named: "hand_inactive")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "hand_inactive")?.imageWithRenderingMode(.AlwaysTemplate))
        //navContacts.tabBarItem = UITabBarItem(title: "联系人", image: UIImage(named: "contacts_inactive"), selectedImage: UIImage(named: "contacts_active"))
        navSocial.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "discovery_inactive")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "discovery_inactive")?.imageWithRenderingMode(.AlwaysTemplate))
        
        Me.tabBarItem = UITabBarItem(title: "我", image: UIImage(named: "me_inactive")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "me_inactive")?.imageWithRenderingMode(.AlwaysTemplate))

        food.tabBarItem = UITabBarItem(title: "我", image: UIImage(named: "me_inactive")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "me_inactive")?.imageWithRenderingMode(.AlwaysTemplate))

        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}






class SettingVC :UITableViewController {
    private let setting = ["清除缓存", "关于\(APP)"]
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
        logout.backgroundColor = THEME_COLOR//UIColor.redColor()
        logout.setTitle("退出登录", forState: UIControlState.Normal)
        logout.addTarget(self, action: "logout:", forControlEvents: UIControlEvents.TouchUpInside)
       
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        
       // tabBarController?.tabBar.hidden = false
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    func logout(sender : AnyObject) {
        //print("logout")
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(TOKEN)
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(ID)
//        NSUserDefaults.standardUserDefaults().synchronize()
//        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        let path = documents.stringByAppendingString("/profile_background.jpg")
//        let avatar_path = documents.stringByAppendingString("/avatar.jpg")
//        if NSFileManager.defaultManager().fileExistsAtPath(path) {
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(path)
//            }
//            catch {
//                print("cannot delete profile")
//            }
//        }
//        
//        if NSFileManager.defaultManager().fileExistsAtPath(avatar_path) {
//            
//            do {
//                try NSFileManager.defaultManager().removeItemAtPath(avatar_path)
//            }
//            catch {
//                print("cannot delete avatar")
//            }
//        }

        let cacheManager = SDImageCache.sharedImageCache()
        cacheManager.clearMemory()
        cacheManager.clearDisk()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = LoginRegisterVC()

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
        cell.textLabel?.textColor = UIColor.colorFromRGB(0x636363)
        if indexPath.row != 0 {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            label.textAlignment = .Right
            label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
            label.textColor = UIColor.lightGrayColor()
            label.text = "\(Double(SDImageCache.sharedImageCache().getSize()/10000)/100.0)M"
            cell.accessoryView = label
        }
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if indexPath.item == 0 {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = .Indeterminate
            hud.labelText = "正在清除..."
            hud.showAnimated(true, whileExecutingBlock: { () -> Void in
                let imgcache = SDImageCache.sharedImageCache()
                imgcache.clearMemory()
                imgcache.clearDisk()
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .None)
                    let hudFinished = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hudFinished.mode = .CustomView
                    hudFinished.labelText = "清除成功"
                    hudFinished.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hudFinished.hide(true, afterDelay: 1)
                })
               })
        }
        else if indexPath.item == 1{
            navigationController?.pushViewController(AboutUSVC(), animated: true)
            //let nav = UINavigationController(rootViewController: AboutVC())
            //presentViewController(nav, animated: true, completion: nil)
        }
        
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


