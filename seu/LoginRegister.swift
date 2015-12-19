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
        registerButton.setTitle("注册 WeMe 用户", forState: .Normal)
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
        
        let navigation = UINavigationController(rootViewController: RegisterVC())
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
            var info = notification.userInfo!
            let keyFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
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

 
    
    class RegisterVC: UIViewController, UITextFieldDelegate , UIScrollViewDelegate{
        
        private var _view :UIScrollView!
        private var contentView :UIView!

        
        private var accountTextField: UITextField?
        private var codeTextField: UITextField?
        private var codeButton:UIButton?
        private var passwordTextField:UITextField?
        private var passwordRetypeTextField:UITextField?
        private var nextButton:UIButton?
        
        
        private var  rightButton:UIBarButtonItem!

        override func prefersStatusBarHidden() -> Bool {
            return false
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            automaticallyAdjustsScrollViewInsets = false
            UIApplication.sharedApplication().statusBarHidden = false
            setNeedsStatusBarAppearanceUpdate()
            title = "注册"
            self.view.backgroundColor = UIColor.whiteColor()
            navigationController?.navigationBar.barStyle = UIBarStyle.Black
            rightButton = UIBarButtonItem(title: "跳过", style: UIBarButtonItemStyle.Plain, target: self, action: "skip:")
            navigationItem.rightBarButtonItem = rightButton
            rightButton.enabled = false
            rightButton.title = ""
            
            let back = UIBarButtonItem(image: UIImage(named: "activity_more"), style: .Plain, target: self, action: "back:")
            navigationItem.leftBarButtonItem = back

            loadUI()
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
        
        func textFieldDidBeginEditing(textField: UITextField) {
//            let frame = textField.convertRect(textField.frame, toView: _view)
//            var p = frame.origin
//            let offset = _view.contentOffset.y
//            print(offset)
//            print(p)
//            p.x = 0
//            p.y += max(p.y-offset-10, 0)
//            _view.setContentOffset(p, animated: true)
        }
        
        func scrollViewDidScroll(scrollView: UIScrollView) {
            dismissKeyboard(nil)
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.hidden = false
        }
        
        
        func skip(sender:AnyObject) {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = HomeVC()
        }
        
        func dismissKeyboard(sender:AnyObject?) {
            if (accountTextField?.isFirstResponder())! {
                accountTextField?.resignFirstResponder()
            }
            else if (passwordRetypeTextField?.isFirstResponder())! {
                passwordRetypeTextField?.resignFirstResponder()
            }
            else if (passwordTextField?.isFirstResponder())! {
                passwordTextField?.resignFirstResponder()
            }
        }

        private func loadUI() {
            
            let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
            view.addGestureRecognizer(tap)
            
            
            //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
            _view = UIScrollView()
            _view.delegate = self
            // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
            
            _view.backgroundColor = UIColor.whiteColor()
            view.addSubview(_view)
            _view.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
            view.addConstraints(constraints)
            var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
            contentView = UIView()
            contentView.backgroundColor = UIColor.whiteColor()
            _view.addSubview(contentView)
            // contentView.backgroundColor = UIColor.yellowColor()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
            _view.addConstraints(constraints)
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
            _view.addConstraints(constraints)
            
            //_view.contentSize = CGSizeMake(view.frame.width, view.frame.height)
            // _view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 10)
            
            constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)

            
            accountTextField = UITextField()
            accountTextField?.delegate = self
            codeTextField = UITextField()
            codeButton = UIButton()
            passwordTextField = UITextField()
            passwordTextField?.delegate = self
            passwordRetypeTextField = UITextField()
            passwordRetypeTextField?.delegate = self
            nextButton = UIButton()
            accountTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            accountTextField?.keyboardType = UIKeyboardType.Alphabet
            codeTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            passwordTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            passwordTextField?.keyboardType = UIKeyboardType.Alphabet
            passwordRetypeTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            passwordRetypeTextField?.keyboardType = UIKeyboardType.Alphabet
            
            
            let back = UIView()
            let back1 = UIView()
            let back2 = UIView()
            let back3 = UIView()
            //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
            
            
            contentView.addSubview(back)
            contentView.addSubview(back1)
            contentView.addSubview(back2)
            contentView.addSubview(back3)
            
            let accountLabel = UILabel()
            accountLabel.text = "账号:"
            let codeLabel = UILabel()
            codeLabel.text = "验证码:"
            let passwordLabel = UILabel()
            passwordLabel.text = "密码:"
            let passwordRetypeLabel = UILabel()
            passwordRetypeLabel.text = "确认密码:"

            
            
            let viewDict = ["account":accountTextField!, "codeText":codeTextField!, "codeButton":codeButton!, "password":passwordTextField!,"passwordRetype":passwordRetypeTextField! ,"next" : nextButton!, "back":back, "back1":back1, "back2":back2,"back3":back3, "accountLabel":accountLabel, "codeLabel":codeLabel, "passwordLabel":passwordLabel, "passwordRetypeLabel":passwordRetypeLabel]
           
            
            back.backgroundColor = BACK_COLOR//backColor
            back.translatesAutoresizingMaskIntoConstraints = false
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 5)
            view.addConstraints(constraints)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            view.addConstraint(constraint)
            
            back.addSubview(accountTextField!)
            back.addSubview(accountLabel)
            
            accountTextField?.placeholder = "请输入您的用户名(英文)"
            accountTextField?.translatesAutoresizingMaskIntoConstraints = false
            accountLabel.translatesAutoresizingMaskIntoConstraints = false
           
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[accountLabel(<=30@500)]-5-[account]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: accountTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
           
            back.addConstraints(constraints)
            back.addConstraint(constraint)
            
            
//            back1.backgroundColor = backColor
//            back1.translatesAutoresizingMaskIntoConstraints = false
//            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//            constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
//            view.addConstraints(constraints)
//            view.addConstraint(constraint)
//            constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
//            view.addConstraint(constraint)
//            
//            back1.addSubview(codeTextField!)
//            back1.addSubview(codeButton!)
//            back1.addSubview(codeLabel)
//            
//            
//            
//            codeTextField?.placeholder = "请输入验证码"
//            codeButton?.setTitle("获取验证码", forState: UIControlState.Normal)
//            codeButton?.titleLabel?.font = UIFont.systemFontOfSize(12)
//            codeButton?.backgroundColor = UIColor.redColor()
//            codeButton?.layer.cornerRadius = 4.0
//            codeTextField?.translatesAutoresizingMaskIntoConstraints = false
//            codeButton?.translatesAutoresizingMaskIntoConstraints = false
//            codeLabel.translatesAutoresizingMaskIntoConstraints = false
//            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[codeLabel(<=40@500)]-5-[codeText]-10-[codeButton(40@500)]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//
//            constraint = NSLayoutConstraint(item: codeTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem:back1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
//            
//            back1.addConstraints(constraints)
//            back1.addConstraint(constraint)
//            
            
            
            back2.backgroundColor = BACK_COLOR//backColor
            back2.translatesAutoresizingMaskIntoConstraints = false
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back2]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
            view.addConstraints(constraints)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            view.addConstraint(constraint)
            
            back2.addSubview(passwordTextField!)
            back2.addSubview(passwordLabel)
            


            passwordTextField?.placeholder = "请输入至少6位密码"
            passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
            passwordTextField?.secureTextEntry = true
            passwordLabel.translatesAutoresizingMaskIntoConstraints = false
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[passwordLabel(<=30@500)]-5-[password]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: passwordTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            back2.addConstraints(constraints)
            back2.addConstraint(constraint)
            
          
            
            
          
            
            back3.backgroundColor = BACK_COLOR//backColor
            back3.translatesAutoresizingMaskIntoConstraints = false
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back3]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
            view.addConstraints(constraints)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            view.addConstraint(constraint)
            
            back3.addSubview(passwordRetypeTextField!)
            back3.addSubview(passwordRetypeLabel)
            
            
            
            passwordRetypeTextField?.placeholder = "请再次输入密码"
            passwordRetypeTextField?.translatesAutoresizingMaskIntoConstraints = false
            passwordRetypeTextField?.secureTextEntry = true
            passwordRetypeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[passwordRetypeLabel(<=30@500)]-5-[passwordRetype]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: passwordRetypeTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back3, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            back3.addConstraints(constraints)
            back3.addConstraint(constraint)
            
            

            contentView.addSubview(nextButton!)
            nextButton!.tag = 0
            nextButton!.addTarget(self, action: "next:", forControlEvents: UIControlEvents.TouchUpInside)
            nextButton?.setTitle("注册", forState: UIControlState.Normal)
            nextButton?.translatesAutoresizingMaskIntoConstraints = false
            nextButton?.backgroundColor = THEME_COLOR//UIColor.redColor()
            nextButton?.layer.cornerRadius = 4.0
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[next]-20-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            
            constraint = NSLayoutConstraint(item: nextButton!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back3, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20)
            
            view.addConstraints(constraints)
            view.addConstraint(constraint)
            
            
            contentView.snp_makeConstraints { (make) -> Void in
                make.bottom.equalTo(nextButton!.snp_bottom).priorityLow()
            }
            
            
        }
        
   
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            if _view.contentSize.height < view.frame.height {
                contentView.snp_makeConstraints { (make) -> Void in
                    make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
                    _view.layoutIfNeeded()
                }
                
            }
        }

        
        
        func next(sender:UIButton!) {
            if sender.tag == 0 {
               // print("next")
                
                if (accountTextField?.text?.characters.count == 0 || passwordTextField?.text?.characters.count == 0 || passwordRetypeTextField?.text?.characters.count == 0) {
                    let alert = UIAlertController(title: "提示", message: "用户名或密码不能为空", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                if (passwordRetypeTextField?.text?.characters.count < 6) {
                    let alert = UIAlertController(title: "提示", message: "请输入至少6位密码", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return

                }
                
                if passwordTextField?.text! != passwordRetypeTextField?.text! {
                    let alert = UIAlertController(title: "提示", message: "两次密码输入不一致", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                
                let user = (accountTextField?.text)!
                let password = (passwordTextField?.text)!
                let pwdmd5 = md5(string: password)
                
                request(.POST, REGISTER_URL, parameters: ["username":user, "password":pwdmd5], encoding:.JSON).responseJSON { (response) -> Void in
                    //debugprint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                            token = json["token"].stringValue
                            myId = json["id"].stringValue
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.setValue(token, forKey: TOKEN)
                            userDefaults.setValue(myId, forKey: ID)
                            userDefaults.synchronize()
                            sender.setTitle("注册成功，接着完善信息", forState: UIControlState.Normal)
                            sender.tag = 1
                            self.rightButton.title = "跳过"
                            self.rightButton.enabled = true
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
                    
                    
                }
                
                
            }
            else {
                self.navigationController?.pushViewController(RegisterPersonalInfoVC(), animated: true)
            }
        }
     
        

        
     
        
    }
    
    class LoginVC: UIViewController {
        private var accountTextField: UITextField?
        private var passwordTextField:UITextField?
        private var loginButton:UIButton?
        private var _view :UIScrollView!
        private var contentView :UIView!

        func setupScrollView() {
            //view.backgroundColor =UIColor.colorFromRGB(0x1874CD)//UIColor.blackColor()
            _view = UIScrollView()
            _view.backgroundColor = UIColor.whiteColor()
            view.addSubview(_view)
            _view.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
            view.addConstraints(constraints)
            var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
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
            
            constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
            view.addConstraint(constraint)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            automaticallyAdjustsScrollViewInsets = false
            setNeedsStatusBarAppearanceUpdate()
            title = "登录"
            self.view.backgroundColor = UIColor.whiteColor()
            navigationController?.navigationBar.barStyle = UIBarStyle.Black
            //navigationItem.backBarButtonItem = UIBarButtonItem(title: "hh", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
           // UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-80, 0), forBarMetrics: UIBarMetrics.Default)
            setupScrollView()
            loadUI()
        }
        
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            navigationController?.navigationBar.hidden = false
            view.setNeedsLayout()
        }

        
        private func loadUI() {
            accountTextField = UITextField()
            passwordTextField = UITextField()
            loginButton = UIButton()
            accountTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            accountTextField?.keyboardType = UIKeyboardType.Alphabet
            passwordTextField?.clearButtonMode = UITextFieldViewMode.WhileEditing
            passwordTextField?.keyboardType = UIKeyboardType.Alphabet
            
            let back = UIView()
            let back1 = UIView()
            let back2 = UIView()
            //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
            
            contentView.addSubview(back)
            contentView.addSubview(back1)
            contentView.addSubview(back2)
            
            let accountLabel = UILabel()
            accountLabel.text = "账号:"
            let passwordLabel = UILabel()
            passwordLabel.text = "密码:"
            let forgetpasswordLabel = UILabel()
            forgetpasswordLabel.text = "忘记密码"
            
            
            let viewDict = ["account":accountTextField!,  "password":passwordTextField!, "login" : loginButton!, "back":back, "back1":back1, "back2":back2, "accountLabel":accountLabel,  "passwordLabel":passwordLabel, "forgetPasswordLabel":forgetpasswordLabel]
            
            back.backgroundColor = BACK_COLOR//backColor
            back.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            var constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 5)
            contentView.addConstraints(constraints)
            contentView.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            contentView.addConstraint(constraint)
            
            back.addSubview(accountTextField!)
            back.addSubview(accountLabel)
            
            accountTextField?.placeholder = "用户名"
            accountTextField?.translatesAutoresizingMaskIntoConstraints = false
            accountLabel.translatesAutoresizingMaskIntoConstraints = false
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[accountLabel(<=30@500)]-5-[account]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: accountTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            back.addConstraints(constraints)
            back.addConstraint(constraint)
            
            
            back1.backgroundColor = BACK_COLOR//backColor
            back1.translatesAutoresizingMaskIntoConstraints = false
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
            contentView.addConstraints(constraints)
            contentView.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            contentView.addConstraint(constraint)
            
            back1.addSubview(passwordTextField!)
            back1.addSubview(passwordLabel)
            
            
            
            passwordTextField?.placeholder = "请输入密码"
            passwordTextField?.translatesAutoresizingMaskIntoConstraints = false
            passwordTextField?.secureTextEntry = true
            passwordLabel.translatesAutoresizingMaskIntoConstraints = false
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[passwordLabel(<=30@500)]-5-[password]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: passwordTextField!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            back1.addConstraints(constraints)
            back1.addConstraint(constraint)
            
//            back2.backgroundColor = backColor
//            back2.translatesAutoresizingMaskIntoConstraints = false
//            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back2]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//            constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
//            view.addConstraints(constraints)
//            view.addConstraint(constraint)
//            constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
//            view.addConstraint(constraint)
//
//            back2.addSubview(forgetpasswordLabel)
//
//            forgetpasswordLabel.translatesAutoresizingMaskIntoConstraints = false
//            
//            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[forgetPasswordLabel]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
//            constraint = NSLayoutConstraint(item: forgetpasswordLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
//            
//            back2.addConstraints(constraints)
//            back2.addConstraint(constraint)

            
            contentView.addSubview(loginButton!)
            loginButton?.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
            loginButton?.setTitle("登录", forState: UIControlState.Normal)
            loginButton?.translatesAutoresizingMaskIntoConstraints = false
            loginButton?.backgroundColor = THEME_COLOR//UIColor.redColor()
            loginButton?.layer.cornerRadius = 4.0
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[login]-20-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            
            constraint = NSLayoutConstraint(item: loginButton!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20)
            
            contentView.addConstraints(constraints)
            contentView.addConstraint(constraint)
            
            contentView.snp_makeConstraints { (make) -> Void in
                make.bottom.equalTo(loginButton!.snp_bottom).offset(5).priorityLow()
            }


        }
        
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            if _view.contentSize.height < view.frame.height {
                contentView.snp_makeConstraints { (make) -> Void in
                    make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
                    
                }
                
            }
            
            _view.layoutIfNeeded()

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
                    if json["state"].stringValue == "successful" || json["state"].stringValue == "sucessful" {
                        
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
    }
}



class RegisterPersonalInfoVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    private var _view :UIScrollView!
    private var contentView :UIView!

    var nameTextField:UITextField!
    var sexTextField:UITextField!
    var birthDayTextField:UITextField!
    var avatar:UIImageView!
    var phoneNumberTextField:UITextField!
    
    var wechatTextField:UITextField!
    var qqTextField:UITextField!
    var hometownTextField:UITextField!
    
    var datePicker:UIDatePicker!
    var sexPicker:UIPickerView!
    
    
    lazy var spinner: UIActivityIndicatorView = {
        let activityIndicatorStyle: UIActivityIndicatorViewStyle = .WhiteLarge
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorStyle)
        spinner.color = UIColor.darkGrayColor()
        spinner.center = self.view.center
        spinner.startAnimating()
        spinner.alpha = 0
        return spinner
    }()

    
    let sexData = ["男", "女"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setNeedsStatusBarAppearanceUpdate()
        title = "填写基本信息"
        self.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "hh", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        //UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-100, 0), forBarMetrics: UIBarMetrics.Default)
        
        let rightButton = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: "next:")
        navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(spinner)
        loadUI()
    }
    
    //MARK: - UIPickerView Delegate && DataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return sexData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return sexData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sexTextField.text = sexData[row]
    }
    
    func sexPickerDone(sender:AnyObject) {
        sexTextField.text = sexData[sexPicker.selectedRowInComponent(0)]
        sexTextField.resignFirstResponder()
    }
    
    func sexPickerCancel(sender:AnyObject) {
        sexTextField.resignFirstResponder()
    }
    
    func birthPickerDone(sender:AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDayTextField.text = dateFormatter.stringFromDate(datePicker.date)
        birthDayTextField.resignFirstResponder()
    }
    
    func birthPickerCancel(sender:AnyObject) {
        birthDayTextField.resignFirstResponder()
    }
    
    func dismissKeyboard(sender:AnyObject?) {
        if nameTextField.isFirstResponder() {
            nameTextField.resignFirstResponder()
        }
        else if sexTextField.isFirstResponder() {
            sexTextField.resignFirstResponder()
        }
        else if birthDayTextField.isFirstResponder() {
            birthDayTextField.resignFirstResponder()
        }
        else if phoneNumberTextField.isFirstResponder() {
            phoneNumberTextField.resignFirstResponder()
        }
        else if wechatTextField.isFirstResponder() {
            wechatTextField.resignFirstResponder()
        }
        else if hometownTextField.isFirstResponder() {
            hometownTextField.resignFirstResponder()
        }
        else if qqTextField.isFirstResponder() {
            qqTextField.resignFirstResponder()
        }
    

    }

    func avatarTap(sender:AnyObject) {
        //print("tap avatar")
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.barStyle = .Black
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let frame = textField.convertRect(textField.frame, toView: _view)
        var p = frame.origin
        p.x = 0
        p.y -= 100
        _view.setContentOffset(p, animated: true)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let cropper = RSKImageCropViewController(image: image, cropMode:.Custom)
        cropper.delegate = self
        cropper.dataSource = self
        presentViewController(cropper, animated: true, completion: nil)
        //avatar.image = image
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func loadUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        view.addGestureRecognizer(tap)

        
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        _view = UIScrollView()
        //_view.delegate = self
        // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        _view.backgroundColor = UIColor.whiteColor()
        view.addSubview(_view)
        _view.translatesAutoresizingMaskIntoConstraints = false
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[_view]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["_view":_view])
        view.addConstraints(constraints)
        var constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: _view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal , toItem:view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        contentView = UIView()
        contentView.backgroundColor = UIColor.whiteColor()
        _view.addSubview(contentView)
        // contentView.backgroundColor = UIColor.yellowColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        //_view.contentSize = CGSizeMake(view.frame.width, view.frame.height)
       // _view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 10)
        
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        //constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        //view.addConstraint(constraint)
        

        nameTextField = UITextField()
        sexTextField = UITextField()
        birthDayTextField = UITextField()
        phoneNumberTextField = UITextField()

        avatar = UIImageView(image: UIImage(named: "avatar"))
        nameTextField.delegate = self
        sexTextField.delegate = self
        birthDayTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action:"avatarTap:")
        avatar.addGestureRecognizer(tapGesture)
        avatar.userInteractionEnabled = true
        
        let back = UIView()
        let back1 = UIView()
        let back2 = UIView()
        let back3 = UIView()
        let back4 = UIView()
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        
        let swipe = UISwipeGestureRecognizer(target: self, action: "dismissKeyboard:")
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(swipe)
        
        sexPicker = UIPickerView()
        sexPicker.dataSource = self
        sexPicker.delegate = self
        sexPicker.backgroundColor = BACK_COLOR//backColor
        
        sexTextField.inputView = sexPicker
        
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.size.width, 44))
        
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "sexPickerDone:")
        let flexibleLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let sexPickerTitleLabel = UILabel(frame: CGRectMake(0, 0, 100, 44))
        sexPickerTitleLabel.text = "选择性别"
        sexPickerTitleLabel.textAlignment = NSTextAlignment.Center
        let titleButton = UIBarButtonItem(customView: sexPickerTitleLabel)
        let flexibleRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "sexPickerCancel:")
        toolbar.tintColor = THEME_COLOR//UIColor.redColor()
        
        toolbar.setItems([cancelButton, flexibleLeft, titleButton, flexibleRight, doneButton], animated: false)
        
        sexTextField.inputAccessoryView = toolbar
        
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker .addTarget(self, action: "updateBirthDate:", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.backgroundColor = BACK_COLOR//backColor
        birthDayTextField.inputView = datePicker
        
        let toolbar1 = UIToolbar(frame: CGRectMake(0, 0, view.frame.size.width, 44))
        
        let doneButton1 = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "birthPickerDone:")
        let flexibleLeft1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let birthPickerTitleLabel = UILabel(frame: CGRectMake(0, 0, 100, 44))
        birthPickerTitleLabel.text = "选择生日"
        birthPickerTitleLabel.textAlignment = NSTextAlignment.Center
        let titleButton1 = UIBarButtonItem(customView: birthPickerTitleLabel)
        let flexibleRight1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let cancelButton1 = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "birthPickerCancel:")
        toolbar1.tintColor = THEME_COLOR//UIColor.redColor()
        
        toolbar1.setItems([cancelButton1, flexibleLeft1, titleButton1, flexibleRight1, doneButton1], animated: false)
        
        birthDayTextField.inputAccessoryView = toolbar1
        
        
        phoneNumberTextField.keyboardType = UIKeyboardType.NumberPad
        
        let nameLabel = UILabel()
        nameLabel.text = "姓名:"
        let sexLabel = UILabel()
        sexLabel.text = "性别:"
        let birthLabel = UILabel()
        birthLabel.text = "生日:"
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.text = "手机号:"
        let avatarLabel = UILabel()
        avatarLabel.text = "头像:"
        
        
        back.backgroundColor = BACK_COLOR//backColor
        back.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(back)
        let viewDict = ["back":back, "back1":back1, "back2":back2, "back3":back3,"back4":back4 ,"nameLabel":nameLabel, "name":nameTextField, "sexLabel":sexLabel, "sex":sexTextField, "birthLabel":birthLabel, "birth":birthDayTextField, "avatarLabel":avatarLabel,"avatar":avatar, "phoneNumberLabel":phoneNumberLabel, "phoneNumberTextField":phoneNumberTextField]
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute:  NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 50)
        view.addConstraint(constraint)
        
        
        avatar.layer.cornerRadius = 20
        avatar.layer.masksToBounds = true
        
        back.addSubview(avatar)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        back.addSubview(avatarLabel)
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label(<=30@500)]-5-[textField]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        //                constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        //
        //               // back.addConstraints(constraints)
        //                back.addConstraint(constraint)
        //                constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        //                back.addConstraint(constraint)
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[avatarLabel]-5-[avatar]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item:avatarLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back.addConstraints(constraints)
        back.addConstraint(constraint)
        constraint = NSLayoutConstraint(item:avatar, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back.addConstraint(constraint)
        
        
        
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        back.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: avatar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40)
        back.addConstraint(constraint)
        
        
        back1.backgroundColor = BACK_COLOR//backColor
        back1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back1)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute:  NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
        view.addConstraint(constraint)
        
        
        
        back1.addSubview(nameLabel)
        back1.addSubview(nameTextField)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "输入姓名"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[nameLabel(<=30@500)]-5-[name]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item:nameTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back1.addConstraints(constraints)
        back1.addConstraint(constraint)
        
        
        
        back2.backgroundColor = BACK_COLOR//backColor
        back2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back2)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back2]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute:  NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back2, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
        view.addConstraint(constraint)
        
        
        
        back2.addSubview(sexLabel)
        back2.addSubview(sexTextField)
        sexLabel.translatesAutoresizingMaskIntoConstraints = false
        sexTextField.translatesAutoresizingMaskIntoConstraints = false
        sexTextField.placeholder = "输入姓别"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[sexLabel(<=30@500)]-5-[sex]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item:sexTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back2.addConstraints(constraints)
        back2.addConstraint(constraint)
        
        
        back3.backgroundColor = BACK_COLOR//backColor
        back3.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back3)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back3]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back2, attribute:  NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
        view.addConstraint(constraint)
        
        
        
        back3.addSubview(birthLabel)
        back3.addSubview(birthDayTextField)
        birthLabel.translatesAutoresizingMaskIntoConstraints = false
        birthDayTextField.translatesAutoresizingMaskIntoConstraints = false
        birthDayTextField.placeholder = "输入生日"
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[birthLabel(<=30@500)]-5-[birth]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item:birthDayTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back3, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back3.addConstraints(constraints)
        back3.addConstraint(constraint)
        
        contentView.addSubview(back4)
        back4.backgroundColor = BACK_COLOR//backColor
        back4.translatesAutoresizingMaskIntoConstraints = false
        
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back4]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back4, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back3, attribute:  NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back4, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
        view.addConstraint(constraint)
        
        back4.addSubview(phoneNumberLabel)
        back4.addSubview(phoneNumberTextField)
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.placeholder = "务必保证号码真实有效"
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[phoneNumberLabel(<=30@500)]-5-[phoneNumberTextField]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item:phoneNumberTextField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back4, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        back4.addConstraints(constraints)
        back4.addConstraint(constraint)
//        constraint = NSLayoutConstraint(item: back4, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -500)
//        view.addConstraint(constraint)
        
        let back5 = UIView()
        back5.backgroundColor = BACK_COLOR
        back5.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back5)
        wechatTextField = UITextField()
        wechatTextField.delegate = self
        wechatTextField.translatesAutoresizingMaskIntoConstraints = false
        wechatTextField.placeholder = "输入微信号(可选)"
        back5.addSubview(wechatTextField)
        let wechatLabel = UILabel()
        wechatLabel.translatesAutoresizingMaskIntoConstraints = false
        wechatLabel.text = "微信号:"
        back5.addSubview(wechatLabel)
        
        back5.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(back4.snp_bottom).offset(5)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-500)
        }
        wechatLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(back5.snp_leftMargin)
            make.width.equalTo(40).priorityHigh()
            //make.centerY.equalTo(wechatTextField.snp_centerY)
            make.top.equalTo(back5.snp_top)
            make.bottom.equalTo(back5.snp_bottom)
        }
        wechatTextField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(back5.snp_right)
            make.left.equalTo(wechatLabel.snp_right)
            make.top.equalTo(back5.snp_top)
            make.bottom.equalTo(back5.snp_bottom)
        }
        
        let back6 = UIView()
        back6.backgroundColor = BACK_COLOR
        back6.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back6)
        qqTextField = UITextField()
        qqTextField.delegate = self
        qqTextField.translatesAutoresizingMaskIntoConstraints = false
        qqTextField.placeholder = "输入QQ号(可选)"
        qqTextField.keyboardType = .NumberPad
        back6.addSubview(qqTextField)
        let qqLabel = UILabel()
        qqLabel.translatesAutoresizingMaskIntoConstraints = false
        qqLabel.text = "QQ号:"
        back6.addSubview(qqLabel)
        
        back6.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(back5.snp_bottom).offset(5)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-500)
        }
        qqLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(back6.snp_leftMargin)
            make.width.equalTo(40).priorityHigh()
            //make.centerY.equalTo(wechatTextField.snp_centerY)
            make.top.equalTo(back6.snp_top)
            make.bottom.equalTo(back6.snp_bottom)
        }
        qqTextField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(back6.snp_right)
            make.left.equalTo(qqLabel.snp_right)
            make.top.equalTo(back6.snp_top)
            make.bottom.equalTo(back6.snp_bottom)
        }

        
        
        let back7 = UIView()
        back7.backgroundColor = BACK_COLOR
        back7.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(back7)
        hometownTextField = UITextField()
        hometownTextField.delegate = self
        hometownTextField.translatesAutoresizingMaskIntoConstraints = false
        hometownTextField.placeholder = "输入家乡信息"
        back7.addSubview(hometownTextField)
        let hometownLabel = UILabel()
        hometownLabel.translatesAutoresizingMaskIntoConstraints = false
        hometownLabel.text = "家乡:"
        back7.addSubview(hometownLabel)
        
        back7.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(back6.snp_bottom).offset(5)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(44)
            //make.bottom.equalTo(contentView.snp_bottom).offset(-350)
        }
        hometownLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(back7.snp_leftMargin)
            make.width.equalTo(40)
            //make.centerY.equalTo(wechatTextField.snp_centerY)
            make.top.equalTo(back7.snp_top)
            make.bottom.equalTo(back7.snp_bottom)
        }
        hometownTextField.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(back7.snp_right)
            make.left.equalTo(hometownLabel.snp_right)
            make.top.equalTo(back7.snp_top)
            make.bottom.equalTo(back7.snp_bottom)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(back7.snp_bottom).priorityLow()
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
    
    
    func updateBirthDate(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDayTextField.text = dateFormatter.stringFromDate(datePicker.date)
        
    }
    
    func next(sender:AnyObject) {
        //print("next")
        
        guard nameTextField.text?.characters.count > 0 && sexTextField.text?.characters.count > 0 && birthDayTextField.text?.characters.count > 0 && phoneNumberTextField.text?.characters.count > 0 && hometownTextField.text?.characters.count > 0 else {
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
        
        if let t = token, id = myId{
            spinner.alpha = 1.0
            request(.POST, EDIT_PERSONAL_INFO_URL, parameters: ["token":t, "name":nameTextField.text!, "gender":sexTextField.text!, "birthday":birthDayTextField.text!, "phone":phoneNumberTextField.text!, "wechat":wechatTextField.text!, "qq":qqTextField.text!, "hometown":hometownTextField.text!], encoding: .JSON).responseJSON{ (response) -> Void in
               // debugPrint(response)
                self.spinner.alpha = 0
                if let d = response.result.value {
                    let json = JSON(d)
                    
                    if json["state"].stringValue == "successful" {
                        
                        upload(.POST, UPLOAD_AVATAR_URL, multipartFormData: { multipartFormData in
                            
                            let dd = "{\"token\":\"\(token)\", \"type\":\"0\", \"number\":\"0\"}"
                            let jsonData = dd.dataUsingEncoding(NSUTF8StringEncoding)
                            let data = UIImageJPEGRepresentation(self.avatar.image!, 0.5)
                            multipartFormData.appendBodyPart(data:jsonData!, name:"json")
                            multipartFormData.appendBodyPart(data:data!, name:"avatar", fileName:"avatar.jpg", mimeType:"image/jpeg")
                            // }
                            
                            }, encodingCompletion: { encodingResult in
                                switch encodingResult {
                                case .Success(let upload, _ , _):
                                    upload.responseJSON { response in
                                        //debugprint(response)
                                        if let d = response.result.value {
                                            let j = JSON(d)
                                            if j["state"].stringValue  == "successful" {
                                                SDImageCache.sharedImageCache().storeImage(self.avatar.image, forKey:avatarURLForID(id).absoluteString, toDisk:true)
                                                SDImageCache.sharedImageCache().removeImageForKey(thumbnailAvatarURLForID(id).absoluteString, fromDisk:true)
                                                self.navigationController?.pushViewController(RegisterSchoolInfoVC(), animated: true)
                                            }
                                            else {
                                                let alert = UIAlertController(title: "提示", message: j["reason"].stringValue, preferredStyle: .Alert)
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
                                
                                case .Failure:
                                    //print(encodingError)
                                    let alert = UIAlertController(title: "提示", message: "上载图片失败" , preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    return

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

extension RegisterPersonalInfoVC:RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource{
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        dismissViewControllerAnimated(true, completion: nil)
        avatar.image = croppedImage
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController!) -> CGRect {
        let w = min(SCREEN_HEIGHT, SCREEN_WIDTH)
        return CGRectMake(view.center.x - w/2, view.center.y - w/2, w, w)
    }
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController!) -> UIBezierPath! {
        let w = min(SCREEN_HEIGHT, SCREEN_WIDTH)
        return UIBezierPath(rect: CGRectMake(view.center.x - w/2, view.center.y - w/2, w, w))

    }
}

extension RegisterPersonalInfoVC:UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        dismissKeyboard(nil)
    }
}

class RegisterMoreInfoVC:UIViewController, UITextViewDelegate {
    var interestLabel:UILabel!
    var requirementLabel:UILabel!
    var interestView:UITextView!
    var requirementView:UITextView!
    
    private var _view :UIScrollView!
    private var contentView :UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setNeedsStatusBarAppearanceUpdate()
        title = "填写基本信息"
        self.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "hh", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-200, 0), forBarMetrics: UIBarMetrics.Default)
        
        let rightButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "done:")
        navigationItem.rightBarButtonItem = rightButton
        
        
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
        // contentView.backgroundColor = UIColor.yellowColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["contentView":contentView])
        _view.addConstraints(constraints)

        
        
        loadUI()
    }
    
    func dismissKeyboard(sender:AnyObject) {
        if interestView.isFirstResponder() {
            interestView.resignFirstResponder()
        }
        else if requirementView.isFirstResponder() {
            requirementView.resignFirstResponder()
        }
    }
    
    //
    //            func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //                if textView.text.characters.count == 0 {
    //                    if textView == interestView {
    //                            interestLabel.text = "兴趣爱好(不超过100字)"
    //                    }
    //                    else {
    //                        requirementLabel.text = "理想类型(不超过100字)"
    //                    }
    //                }
    //                else {
    //                    if textView == interestView {
    //                        interestLabel.text = "兴趣爱好(\(100-textView.text.characters.count)/100字)"
    //                    }
    //                    else {
    //                        requirementLabel.text = "理想类型(\(100-textView.text.characters.count)/100字)"
    //                    }
    //                }
    //                return true
    //            }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count == 0 {
            if textView == interestView {
                interestLabel.text = "兴趣爱好(不超过100字)"
            }
            else {
                requirementLabel.text = "理想类型(不超过100字)"
            }
        }
        else {
            if textView == interestView {
                interestLabel.text = "兴趣爱好(\(100-textView.text.characters.count)/100字)"
            }
            else {
                requirementLabel.text = "理想类型(\(100-textView.text.characters.count)/100字)"
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let frame = textView.convertRect(textView.frame, toView: _view)
        var p = frame.origin
        p.x = 0
        p.y -= 100
        _view.setContentOffset(p, animated: true)
    }
    
    func loadUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        view.addGestureRecognizer(tap)
        

        
        var constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        view.addConstraint(constraint)

        
        
        interestLabel = UILabel()
        requirementLabel = UILabel()
        interestView = UITextView()
        requirementView = UITextView()
        interestView.delegate = self
        requirementView.delegate = self
        
        let back = UIView()
        let back1 = UIView()
       // let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        let viewDict = ["back":back, "back1":back1, "interestLabel":interestLabel, "interest":interestView, "requirementLabel":requirementLabel,  "requirement":requirementView]
        view.backgroundColor = UIColor.whiteColor()
        
        back.backgroundColor = BACK_COLOR//backColor
        back.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(back)
        
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute:  NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200)
        view.addConstraint(constraint)
        
        interestLabel.text = "兴趣爱好(不超过100字)"
        
        interestLabel.translatesAutoresizingMaskIntoConstraints = false
        interestView.translatesAutoresizingMaskIntoConstraints = false
        
        back.addSubview(interestLabel)
        back.addSubview(interestView)
        interestView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[interestLabel]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        
        back.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[interest]-5-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: interestView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: interestLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        
        back.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        back.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: interestLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Top , multiplier: 1.0, constant: 0)
        back.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: interestView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.Bottom , multiplier: 1.0, constant: -5)
        back.addConstraint(constraint)
        
        
        back1.backgroundColor = BACK_COLOR//backColor
        back1.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(back1)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back1]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute:  NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 5)
        view.addConstraints(constraints)
        view.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 200)
        view.addConstraint(constraint)
//        constraint = NSLayoutConstraint(item: back1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -200)
//        view.addConstraint(constraint)
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(back1.snp_bottom).priorityLow()
        }
        
        requirementLabel.text = "理想类型(不超过100字)"
        
        requirementLabel.translatesAutoresizingMaskIntoConstraints = false
        requirementView.translatesAutoresizingMaskIntoConstraints = false
        
        back1.addSubview(requirementLabel)
        back1.addSubview(requirementView)
        requirementView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[requirementLabel]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        
        back1.addConstraints(constraints)
        
        constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[requirement]-5-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
        back1.addConstraints(constraints)
        
        constraint = NSLayoutConstraint(item: requirementView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: requirementLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        
        back1.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 30)
        back1.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: requirementLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Top , multiplier: 1.0, constant: 0)
        back1.addConstraint(constraint)
        constraint = NSLayoutConstraint(item: requirementView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: back1, attribute: NSLayoutAttribute.Bottom , multiplier: 1.0, constant: -5)
        back1.addConstraint(constraint)
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints(closure: { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
            })
        }
    }

    
    func done(sender:AnyObject) {
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
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.window?.rootViewController = HomeVC()
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

class RegisterSchoolInfoVC : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    private var _view :UIScrollView!
    private var contentView :UIView!
    
    
    var schoolTextField:UITextField!
    var degreeTextField:UITextField!
    var departmentTextField:UITextField!
    var admissionYearTextField:UITextField!
    
    let degreeData = ["本科", "硕士", "博士"]
    
    var degreePicker:UIPickerView!
    
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        setNeedsStatusBarAppearanceUpdate()
        title = "学校信息"
        self.view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "hh", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        // UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-80, 0), forBarMetrics: UIBarMetrics.Default)
        
        let rightButton = UIBarButtonItem(title: "下一步", style: UIBarButtonItemStyle.Plain, target: self, action: "next:")
        navigationItem.rightBarButtonItem = rightButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        
        loadUI()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let frame = textField.convertRect(textField.frame, toView: _view)
        var p = frame.origin
        p.x = 0
        p.y -= 100
        _view.setContentOffset(p, animated: true)
    }
    

    
    
    func tap(sender:AnyObject) {
        //print("tap")
        let textFieldArr = [schoolTextField, degreeTextField, departmentTextField, admissionYearTextField]
        for v in textFieldArr {
            if v.isFirstResponder() {
                v.resignFirstResponder()
                break
            }
        }
    }
    
    func loadUI() {
        
       // let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
       // view.addGestureRecognizer(tap)
        
        
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        _view = UIScrollView()
        // _view.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
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
        contentView.backgroundColor = UIColor.whiteColor()
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

        
        schoolTextField = UITextField()
        schoolTextField.delegate = self
        degreeTextField = UITextField()
        degreeTextField.delegate = self
        departmentTextField = UITextField()
        departmentTextField.delegate = self
        admissionYearTextField = UITextField()
        admissionYearTextField.delegate = self
        
        admissionYearTextField.keyboardType = UIKeyboardType.NumberPad
        
        //let backColor = UIColor(red: 238/255.0, green: 233/255.0, blue: 233/255.0, alpha: 1.0)
        
        degreePicker = UIPickerView()
        degreePicker.delegate = self
        degreePicker.dataSource = self
        degreePicker.backgroundColor = BACK_COLOR//backColor
        
        
        degreePicker.showsSelectionIndicator = true
        degreeTextField.inputView = degreePicker
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, view.frame.size.width, 44))
        
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "degreePickerDone:")
        let flexibleLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let degreePickerTitleLabel = UILabel(frame: CGRectMake(0, 0, 100, 44))
        degreePickerTitleLabel.text = "选择学历"
        degreePickerTitleLabel.textAlignment = NSTextAlignment.Center
        let titleButton = UIBarButtonItem(customView: degreePickerTitleLabel)
        let flexibleRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: "")
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "degreePickerCancel:")
        toolbar.tintColor = THEME_COLOR//UIColor.redColor()
        
        toolbar.setItems([cancelButton, flexibleLeft, titleButton, flexibleRight, doneButton], animated: false)
        
        degreeTextField.inputAccessoryView = toolbar
        
        
        
        let textFieldArr = [schoolTextField, degreeTextField, departmentTextField, admissionYearTextField]
        
        
        
        var backViewArr = [UIView]()
        
        
        let labelTextArr = ["学校:", "学历:", "学院:", "入学年份:"]
        let hintTextArr = ["填写学校", "选择学历", "填写专业", "输入四位数字, 如2014"]
        
        for k in 0 ..< textFieldArr.count {
            let back = UIView()
            backViewArr.append(back)
            contentView.addSubview(back)
            back.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = labelTextArr[k]
            back.addSubview(label)
            
            let textField = textFieldArr[k]
            textField.placeholder = hintTextArr[k]
            textField.translatesAutoresizingMaskIntoConstraints = false
            back.addSubview(textField)
            
            let viewDict = ["back" : back, "label":label, "textField":textField]
            back.backgroundColor = BACK_COLOR//backColor
            back.translatesAutoresizingMaskIntoConstraints = false
            var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back]-0-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            var constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: ((k==0) ? contentView : backViewArr[k-1]), attribute: (k==0 ? NSLayoutAttribute.Top:NSLayoutAttribute.Bottom), multiplier: 1.0, constant: ((k==0) ? 0:5))
            view.addConstraints(constraints)
            view.addConstraint(constraint)
            constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44)
            view.addConstraint(constraint)
            
            
            constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[label(<=30@500)]-5-[textField]-10-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: viewDict)
            constraint = NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: back, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
            
            back.addConstraints(constraints)
            back.addConstraint(constraint)
            
            if k == textFieldArr.count - 1 {
//                constraint = NSLayoutConstraint(item: back, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -500)
//                view.addConstraint(constraint)
                contentView.snp_makeConstraints(closure: { (make) -> Void in
                    make.bottom.equalTo(back.snp_bottom).priorityLow()
                })
            }
            
            
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

    
    func degreePickerDone(sender:AnyObject) {
        degreeTextField.text = degreeData[degreePicker.selectedRowInComponent(0)]
        degreeTextField.resignFirstResponder()
    }
    
    func degreePickerCancel(sender:AnyObject) {
        degreeTextField.resignFirstResponder()
    }
    
    //MARK: - UIPickerView Delegates && Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return degreeData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return degreeData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        degreeTextField.text = degreeData[row]
    }
    
    func next(sender:AnyObject) {
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
                        self.navigationController?.pushViewController(RegisterMoreInfoVC(), animated: true)
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
