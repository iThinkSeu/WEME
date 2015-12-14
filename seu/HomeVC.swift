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

        
        setViewControllers([navHand, navSocial, Me], animated: true)
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
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        view.backgroundColor = BACK_COLOR//backColor
        
        
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
    private let setting = ["修改个人信息",  "清除缓存", "关于牵手"]
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

        let cacheManager = SDImageCache.sharedImageCache()
        cacheManager.clearMemory()
        cacheManager.clearDisk()
        
        
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
        if indexPath.row != 1 {
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
     
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == 0 {
            navigationController?.pushViewController(ChangeInfoVC(), animated: true)
            //let nav = UINavigationController(rootViewController: ChangeInfoVC())
            //presentViewController(nav, animated: true, completion: nil)
        }
        else if indexPath.item == 1 {
            let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.mode = .Indeterminate
            hud.labelText = "正在清除..."
            hud.showAnimated(true, whileExecutingBlock: { () -> Void in
                let imgcache = SDImageCache.sharedImageCache()
                imgcache.clearMemory()
                imgcache.clearDisk()
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
                dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 1, inSection: 0)], withRowAnimation: .None)
                    let hudFinished = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hudFinished.mode = .CustomView
                    hudFinished.labelText = "清除成功"
                    hudFinished.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hudFinished.hide(true, afterDelay: 1)
                })
               })
        }
        else if indexPath.item == 2{
            navigationController?.pushViewController(AboutVC(), animated: true)
            //let nav = UINavigationController(rootViewController: AboutVC())
            //presentViewController(nav, animated: true, completion: nil)
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
        
       // let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
    
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: "cancel:")
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "cancel:")
       // navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        _view = UIScrollView()
        // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        _view.backgroundColor = BACK_COLOR//backColor
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        contentView.backgroundColor = BACK_COLOR//backColor
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
        view.backgroundColor = BACK_COLOR//backColor
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


