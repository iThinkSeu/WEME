//
//  ViewController.swift
//  seu
//
//  Created by liewli on 9/9/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

import UIKit
import RSKImageCropper



private func md5(string string: String) -> String {
    var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
    if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
        CC_MD5(data.bytes, CC_LONG(data.length), &digest)
    }
    
    var digestHex = ""
    for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
        digestHex += String(format: "%02x", digest[index])
    }
    
    return digestHex
}

class LoginRegisterVC: UIViewController {
    
    private var _view:UIScrollView!
    private var contentView:UIView!
    private var overlay:UIView!
    
    private var accountIcon:UIImageView!
    private var passwordIcon:UIImageView!
    private var accountBack:UIView!
    private var passwordBack:UIView!
    private var accountTextField:UITextField!
    private var passwordTextField:UITextField!
    
    private var loginButton:UIButton!
    private var registerButton:UIButton!
    
    var inputing = false

    
    private func applyBlurEffect(image: UIImage?) -> UIImage! {
        let imageToBlur = CIImage(image:image!)
        let blurfilter = CIFilter(name: "CIGaussianBlur")!
        blurfilter.setValue(imageToBlur, forKey: "inputImage")
        blurfilter.setValue(2, forKey: kCIInputRadiusKey)
        let resultImage = blurfilter.valueForKey("outputImage") as! CIImage
        let blurredImage = UIImage(CIImage: resultImage)
        return blurredImage
    }
    
    func setupScrollView() {
        //view.backgroundColor =UIColor.colorFromRGB(0x1874CD)//UIColor.blackColor()
        _view = UIScrollView()
        _view.backgroundColor = UIColor.whiteColor()
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        //contentView.backgroundColor = BACK_COLOR
        _view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).priorityHigh()
                
            }
           _view.layoutIfNeeded()
        }
       
        var maskPath = UIBezierPath(roundedRect: accountBack.bounds, byRoundingCorners: [UIRectCorner.TopLeft,UIRectCorner.TopRight], cornerRadii: CGSizeMake(3, 3))
        var shape = CAShapeLayer()
        shape.frame = accountBack.bounds
        shape.path = maskPath.CGPath
        accountBack.layer.mask = shape
        
        maskPath = UIBezierPath(roundedRect: accountBack.bounds, byRoundingCorners: [UIRectCorner.BottomLeft,UIRectCorner.BottomRight], cornerRadii: CGSizeMake(3, 3))
        shape = CAShapeLayer()
        shape.frame = accountBack.bounds
        shape.path = maskPath.CGPath
        passwordBack.layer.mask = shape
    }

    
    func setupUI() {
        setupScrollView()
        _view.backgroundColor = UIColor.colorFromRGB(0x3460b5)
       
        let background = UIImageView(image: UIImage(named: "screen"))
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)
        background.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_top)
            make.height.equalTo(view.snp_height)
        }
        
        
        background.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        background.addGestureRecognizer(tap)
        
        
       
        
        accountBack = UIView()
        accountBack.translatesAutoresizingMaskIntoConstraints = false
        accountBack.backgroundColor = UIColor.whiteColor()
        //accountBack.layer.cornerRadius = 4.0
        accountBack.layer.masksToBounds = true
        contentView.addSubview(accountBack)
        
        passwordBack = UIView()
        passwordBack.translatesAutoresizingMaskIntoConstraints = false
        passwordBack.backgroundColor = UIColor.whiteColor()
        //passwordBack.layer.cornerRadius = 4.0
        passwordBack.layer.masksToBounds = true
        contentView.addSubview(passwordBack)
        
        accountIcon = UIImageView(image: UIImage(named: "account"))
        accountIcon.translatesAutoresizingMaskIntoConstraints = false
        accountBack.addSubview(accountIcon)
        
        passwordIcon = UIImageView(image: UIImage(named: "password"))
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        passwordBack.addSubview(passwordIcon)
        
        accountTextField = UITextField()
        accountTextField.translatesAutoresizingMaskIntoConstraints = false
        accountTextField.keyboardType = .Alphabet
        accountTextField.tintColor = THEME_COLOR
        accountTextField.textColor = THEME_COLOR
        accountBack.addSubview(accountTextField)
        
        passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.secureTextEntry = true
        passwordTextField.keyboardType = .Alphabet
        passwordTextField.tintColor = THEME_COLOR
        passwordTextField.textColor = THEME_COLOR
        passwordBack.addSubview(passwordTextField)
        
        loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor.colorFromRGB(0x5278c3)
        loginButton.setTitle("登录", forState: .Normal)
        loginButton.addTarget(self, action: "login:", forControlEvents: .TouchUpInside)
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
        contentView.addSubview(loginButton)
        
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.backgroundColor = UIColor.clearColor()
        registerButton.setTitle("注册 \(APP) 用户", forState: .Normal)
        registerButton.addTarget(self, action: "register:", forControlEvents: .TouchUpInside)
        registerButton.setTitleColor( UIColor.colorFromRGB(0x8da7e1), forState: .Normal)
        registerButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        contentView.addSubview(registerButton)
        
        accountBack.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(contentView.snp_centerY)
            make.centerX.equalTo(contentView.snp_centerX)
            make.height.equalTo(44)
            make.width.equalTo(contentView.snp_width).multipliedBy(2/3.0)
        }
        
        passwordBack.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_centerY).offset(1)
            make.centerX.equalTo(contentView.snp_centerX)
            make.height.equalTo(accountBack.snp_height)
            make.width.equalTo(accountBack.snp_width)
        }
        
        accountIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(accountBack.snp_leftMargin)
            make.centerY.equalTo(accountBack.snp_centerY)
            make.width.height.equalTo(20)
        }
        
        accountTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(accountIcon.snp_right).offset(10)
            make.right.equalTo(accountBack.snp_right)
            make.centerY.equalTo(accountBack.snp_centerY)
        }
        
        passwordIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(passwordBack.snp_leftMargin)
            make.centerY.equalTo(passwordBack.snp_centerY)
            make.width.height.equalTo(20)
        }
        
        passwordTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(passwordIcon.snp_right).offset(10)
            make.right.equalTo(passwordBack.snp_right)
            make.centerY.equalTo(passwordBack.snp_centerY)
        }
        
        loginButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(passwordBack.snp_bottom).offset(20)
            make.centerX.equalTo(contentView.snp_centerX)
            make.width.equalTo(accountBack.snp_width)
            make.height.equalTo(passwordBack.snp_height)
        }
        
        registerButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView.snp_centerX)
            //make.top.equalTo(loginButton.snp_bottom).offset(60)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(registerButton.snp_bottom).offset(view.frame.size.height/8).priorityLow()
        }
        
        
        
    }
    

    
    func login(sender:AnyObject) {
        //let navigation = UINavigationController(rootViewController: HomeVC())
        if accountTextField?.text?.characters.count == 0 || passwordTextField?.text?.characters.count == 0 {
            let alert = UIAlertController(title: "提示", message: "帐号和密码不能为空", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        let pwdmd5 = md5(string: (passwordTextField?.text)!)
        
        request(.POST, LOGIN_URL, parameters: ["username":(accountTextField?.text)!, "password":pwdmd5], encoding: .JSON).responseJSON { (response) -> Void in
            //debugprint(response)
            if let d = response.result.value {
                let json  = JSON(d)
                if json["state"].stringValue == "successful" {
                    
                    token = json["token"].stringValue
                    myId = json["id"].stringValue
                    NSUserDefaults.standardUserDefaults().setValue(token, forKey: TOKEN)
                    NSUserDefaults.standardUserDefaults().setValue(myId, forKey: ID)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.labelText = "登陆成功"
                    hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hud.mode = .CustomView
                    
                    let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
                    dispatch_after(delay, dispatch_get_main_queue(), { () -> Void in
                        hud.hide(true)
                        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                        appDelegate?.window?.rootViewController = HomeVC()
                    })
                    
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
    
    func register(sender:AnyObject?) {
        
        let navigation = UINavigationController(rootViewController: RegisterUserVC())
        navigation.view.backgroundColor = UIColor.whiteColor()
        navigation.navigationBar.barTintColor = THEME_COLOR
        navigation.navigationBar.tintColor = UIColor.whiteColor()
        navigation.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-200, 0), forBarMetrics: UIBarMetrics.Default)
        UIView.transitionWithView(view, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
                self._view.removeFromSuperview()
                self.view.addSubview(navigation.view)
                self.addChildViewController(navigation)

            }) { (finished) -> Void in
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if inputing == false {
            inputing = true
            //var info = notification.userInfo!
            //let keyFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            _view.setContentOffset(CGPointMake(_view.contentOffset.x, 80), animated: true)
        }
    }
    
    func keyboardWillHide(sender:AnyObject?) {
        inputing = false
        _view.setContentOffset(CGPointMake(_view.contentOffset.x, 0), animated: true)

    }
    
    func tap(sender:AnyObject) {
        if accountTextField.isFirstResponder() {
            accountTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}


class RegisterUserVC:UITableViewController {
    
    let sections = ["用户名", "密码", "确认密码", "注册"]
    let placeholder = ["登陆账号(英文)", "密码(至少6位)", "再次输入密码"]
    
    var account = ""
    var password = ""
    var passwordRetype = ""
    var rightButton:UIBarButtonItem!
    
    var succeed = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BACK_COLOR
        tableView.registerClass(RegisterTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RegisterTableViewCell))
        tableView.registerClass(RegisterTableActionViewCell.self, forCellReuseIdentifier: NSStringFromClass(RegisterTableActionViewCell))
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        title = "注册\(APP)用户"
        let back = UIBarButtonItem(image: UIImage(named: "activity_more"), style: .Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = back
        
        rightButton = UIBarButtonItem(title: "跳过", style: UIBarButtonItemStyle.Plain, target: self, action: "skip:")
        navigationItem.rightBarButtonItem = rightButton
        rightButton.enabled = false
        rightButton.title = ""
    }
    
    func skip(sender:AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = HomeVC()
    }
    
    func back(sender:AnyObject) {
        let vc = LoginRegisterVC()
        let nav = self.navigationController!
        UIView.transitionWithView(nav.parentViewController!.view, duration: 1, options: .TransitionFlipFromLeft, animations: { () -> Void in
            nav.parentViewController!.view.addSubview(vc.view)
            nav.parentViewController?.addChildViewController(vc)
            }) { (finished) -> Void in
                self.navigationController!.view.removeFromSuperview()
                self.navigationController!.removeFromParentViewController()
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == sections.count - 1{
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(RegisterTableActionViewCell), forIndexPath: indexPath) as! RegisterTableActionViewCell
            cell.action.backgroundColor = THEME_COLOR
            if succeed {
                cell.action.setTitle("注册成功, 完善个人信息吧", forState: .Normal)
            }
            else {
                cell.action.setTitle("注册", forState: .Normal)
            }
            cell.action.addTarget(self, action: "register:", forControlEvents: .TouchUpInside)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(RegisterTableViewCell), forIndexPath: indexPath) as! RegisterTableViewCell
            cell.titleInfoLabel.text = sections[indexPath.row]
            if indexPath.row == 2 || indexPath.row == 1 {
                cell.textContentField.secureTextEntry = true
            }
            cell.textContentField.placeholder = placeholder[indexPath.row]
            cell.textContentField.tag = indexPath.row
            cell.textContentField.addTarget(self, action: "textChange:", forControlEvents: .EditingChanged)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == sections.count - 1 {
            return 80
        }
        else {
            return 70
        }
    }
    
    func textChange(sender:UITextField) {
        switch sender.tag {
        case 0:
            account = sender.text ?? ""
        case 1:
            password = sender.text ?? ""
        case 2:
            passwordRetype = sender.text ?? ""
        default:
            break
        }
    }
    
    func register(sender:AnyObject) {
        if succeed {
            let vc = EditInfoVC()
            vc.isRegistering = true
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            if (account.characters.count == 0 || password.characters.count == 0 || passwordRetype.characters.count == 0) {
                self.messageAlert("用户名或密码不能为空")
                return
            }
            
            if (password.characters.count < 6) {
                self.messageAlert("请输入至少6位密码")
                return
                
            }
            
            if password != passwordRetype {
                self.messageAlert("两次密码输入不一致")
                return
            }
            
            let pwdmd5 = md5(string: password)
            
            request(.POST, REGISTER_URL, parameters: ["username":account, "password":pwdmd5], encoding:.JSON).responseJSON { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        token = json["token"].stringValue
                        myId = json["id"].stringValue
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setValue(token, forKey: TOKEN)
                        userDefaults.setValue(myId, forKey: ID)
                        userDefaults.synchronize()
                        S.rightButton.enabled = true
                        S.rightButton.title = "跳过"
                        S.succeed = true
                        S.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .None)
                    }
                    else {
                        S.messageAlert(json["reason"].stringValue)
                        
                    }
                }
                    
                else if let _ = response.result.error {
                    self?.messageAlert("注册失败")
                }
                
                
            }
        }
        

    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tableView.endEditing(true)
    }
    
}

class RegisterTableViewCell:UITableViewCell {
    var titleInfoLabel:UILabel!
    var textContentField:UITextField!
    var backView:UIView!
    
    func initialize() {
        
        contentView.backgroundColor = BACK_COLOR
        titleInfoLabel = UILabel()
        titleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        titleInfoLabel.backgroundColor = BACK_COLOR
        titleInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleInfoLabel.textColor = TEXT_COLOR
        contentView.addSubview(titleInfoLabel)
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(backView)
        
        backView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(titleInfoLabel.snp_bottom).offset(5)
            make.bottom.equalTo(contentView.snp_bottom)
            backView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
            backView.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
            
        }
        
        
        //contentView.backgroundColor = UIColor.whiteColor()
        textContentField = UITextField()
        textContentField.translatesAutoresizingMaskIntoConstraints = false
        textContentField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        textContentField.textColor = UIColor(red: 81/255.0, green: 87/255.0, blue: 113/255.0, alpha: 1.0)
        textContentField.backgroundColor = UIColor.whiteColor()
        textContentField.tintColor = THEME_COLOR
        backView.addSubview(textContentField)
        
        titleInfoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left).offset(5)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(contentView.snp_top).offset(5)
            titleInfoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
            titleInfoLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
        }
        
        textContentField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(backView.snp_top)
            make.bottom.equalTo(contentView.snp_bottom)
            textContentField.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
            textContentField.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}
class RegisterTableActionViewCell:UITableViewCell {
    var titleInfoLabel:UILabel!
    var action:UIButton!
    var backView:UIView!
    
    func initialize() {
        
        contentView.backgroundColor = BACK_COLOR
        titleInfoLabel = UILabel()
        titleInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        titleInfoLabel.backgroundColor = BACK_COLOR
        titleInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleInfoLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(titleInfoLabel)
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(backView)
        
        backView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(titleInfoLabel.snp_bottom).offset(5)
            make.bottom.equalTo(contentView.snp_bottom)
            backView.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
            backView.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
            
        }
        
       action = UIButton()
       action.translatesAutoresizingMaskIntoConstraints = false
       action.layer.cornerRadius = 4.0
        action.layer.masksToBounds = true
       backView.addSubview(action)
        
        titleInfoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left).offset(5)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(contentView.snp_top).offset(5)
            titleInfoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
            titleInfoLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
        }
        
        action.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(backView.snp_centerY)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}