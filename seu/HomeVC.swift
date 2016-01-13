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
                        alert.view.tintColor = THEME_COLOR
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
        
    }

    
    func loadUI() {
        let navHand = UINavigationController(rootViewController: ActivityVC())
        let navSocial = UINavigationController(rootViewController: SocialVC())
        let Me =  UINavigationController(rootViewController: ProfileVC())
        //let discover = UINavigationController(rootViewController: DiscoverVC())

        
        setViewControllers([navHand, navSocial, Me], animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:THEME_COLOR], forState: UIControlState.Selected)
        tabBar.tintColor = THEME_COLOR
        tabBar.backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor =  THEME_COLOR
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        selectedIndex = 0
        
        
        navHand.tabBarItem = UITabBarItem(title: "活动", image: UIImage(named: "hand")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "hand")?.imageWithRenderingMode(.AlwaysTemplate))
    
        navSocial.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "social")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "social")?.imageWithRenderingMode(.AlwaysTemplate))
        
        Me.tabBarItem = UITabBarItem(title: "我", image: UIImage(named: "me")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "me")?.imageWithRenderingMode(.AlwaysTemplate))

       // discover.tabBarItem = UITabBarItem(title: "发现", image: UIImage(named: "discovery")?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: "discovery")?.imageWithRenderingMode(.AlwaysTemplate))

        
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
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(ID)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(TOKEN)
        
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
            navigationController?.pushViewController(AboutVC(), animated: true)
            //let nav = UINavigationController(rootViewController: AboutVC())
            //presentViewController(nav, animated: true, completion: nil)
        }
        
    }
}






