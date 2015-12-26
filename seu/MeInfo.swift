//
//  MeInfo.swift
//  牵手
//
//  Created by liewli on 12/13/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit
import RSKImageCropper

class MeInfoVC:UIViewController, UINavigationControllerDelegate {
    
    var id:String!

    private var _view :UIScrollView!
    private var contentView :UIView!
    
    private var avatar:UIImageView!
    private var cover:UIImageView!
    private var infoLabel:UILabel!
    
    private var pageMenuController:CAPSPageMenu!
    
    private var statusBarView:UIView?
    
    
    private var personInfo:PersonModel?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black

        if statusBarView != nil {
            statusBarView?.removeFromSuperview()
            statusBarView = nil
        }
        statusBarView = UIView(frame: CGRectMake(0, -20, SCREEN_WIDTH, 20))
        statusBarView?.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.addSubview(statusBarView!)
        
        self.scrollViewDidScroll(self._view)
        
        configUI()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if statusBarView != nil {
            statusBarView?.removeFromSuperview()
        }
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        //statusBarView?.alpha = 0
        navigationController?.navigationBar.alpha = 1.0
        statusBarView?.backgroundColor = UIColor.clearColor()

    }
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
       
        let action = UIBarButtonItem(image: UIImage(named: "more")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: "action:")
        action.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = action
        visit()
        setUI()
    }
    
    func visit() {
        if let t = token, id = id {
            request(.POST, VISIT_URL, parameters: ["token":t, "userid":id], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                
            })
        }
    }
    
    func action(sender:AnyObject) {
        if let ID = myId where ID != id {
            let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
                if index == 0 {
                    let alertText = AlertTextView(title: "举报", placeHolder: "犀利的写下你的举报内容吧╮(╯▽╰)╭")
                    alertText.showInView(self.navigationController!.view)
                }
                else if index == 1 {
                    let vc = ComposeMessageVC()
                    vc.recvID = self.id
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["举报", "私信"])
            sheet.setButtonTextColor(THEME_COLOR)
            sheet.showInView(navigationController!.view)
        }
        else {
            let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
                if index == 0 {
                    self.navigationController?.pushViewController(ChangeInfoVC(), animated: true)
                }
                }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["修改个人信息"])
            sheet.setButtonTextColor(THEME_COLOR)
            sheet.showInView(navigationController!.view)
        }

    }
    
    func setupScrollView() {
        _view = UIScrollView()
        _view.delegate = self
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
    
    func setupPageMenu() {
        let vc1 = PersonalInfoVC()
        vc1.id = id
        vc1.title = "资料"
        vc1.view.backgroundColor = UIColor.whiteColor()
        let vc2 = TimelineVC()
        vc2.userid = id
        vc2.title = "时间轴"
        vc2.view.backgroundColor = BACK_COLOR
        let vc3 = UserImageVC()
        vc3.userid = id
        vc3.title = "图集"
        vc3.view.backgroundColor = BACK_COLOR
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(THEME_COLOR),
            .UnselectedMenuItemLabelColor(THEME_COLOR_BACK),
            .SelectionIndicatorColor(THEME_COLOR),
            .UseMenuLikeSegmentedControl(true),
            .SelectionIndicatorHeight(1),
        ]
        pageMenuController = CAPSPageMenu(viewControllers: [vc1, vc2, vc3], frame: CGRectMake(0, 0, view.frame.width, view.frame.height), pageMenuOptions: parameters)
        pageMenuController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageMenuController.view)
        addChildViewController(pageMenuController)
    }
    
    func tapCover(sender:AnyObject) {
        if let Id = myId where Id == id {
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
            sheet.showInView(navigationController!.view)

        }
    }
    
    func setUI() {
        setupScrollView()
        cover = UIImageView()
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.userInteractionEnabled = true
        let tapCover = UITapGestureRecognizer(target: self, action: "tapCover:")
        cover.addGestureRecognizer(tapCover)
        contentView.addSubview(cover)
        
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        avatar.addGestureRecognizer(tap)
        contentView.addSubview(avatar)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(infoLabel)
        infoLabel.textColor = THEME_COLOR_BACK
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        infoLabel.textAlignment = .Center
        
        cover.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.equalTo(cover.snp_width).multipliedBy(3/4.0)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(84)
            make.centerY.equalTo(cover.snp_bottom)
            make.centerX.equalTo(cover.snp_centerX)
            avatar.layer.cornerRadius = 42
            avatar.layer.masksToBounds = true
            avatar.layer.borderWidth = 2.0
            avatar.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(avatar.snp_bottom).offset(5)
        }
        
        setupPageMenu()
        
        pageMenuController.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(infoLabel.snp_bottom).offset(5)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.height.greaterThanOrEqualTo(view.frame.height-CGRectGetHeight(navigationController!.navigationBar.frame)-20)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(pageMenuController.view.snp_bottom).priorityLow()
        }
        
        
    }
    
    func tapAvatar(sender:AnyObject?) {
        let showImg = Agrume(imageURL: avatarURLForID(id))
        showImg.showFrom(self)
    }
    
    func configUI() {
        let coverURL = profileBackgroundURLForID(id)
        cover.sd_setImageWithURL(coverURL, placeholderImage: UIImage(named: "profile_background"))
        
        let avatarURL = thumbnailAvatarURLForID(id)
        avatar.sd_setImageWithURL(avatarURL, placeholderImage: UIImage(named: "avatar"))
        
        fetchFriendInfo()
        //infoLabel.text = "Stay Hungry, Stay Foolish"
    }
    
    
    func fetchFriendInfo() {
        if let t = token, id = id {
        request(.POST, GET_VISIT_INFO_URL, parameters: ["token": t, "userid":id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
            if let d = response.result.value, S = self {
                let json = JSON(d)
                guard json != .null && json["state"].stringValue == "successful" && json["result"] != .null && json["result"]["today"] != .null else {
                    return
                }
            
                S.infoLabel.text = "今日访问 \((json["result"]["today"]).stringValue) 总访问 \(json["result"]["total"].stringValue)"
               
            }
            
            
            
        })
        }

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if _view.contentSize.height < view.frame.height {
            contentView.snp_makeConstraints { (make) -> Void in
                make.height.greaterThanOrEqualTo(view.snp_height).offset(5).priorityHigh()
                
            }
            
        }

    }
}


extension MeInfoVC:UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let cropper = RSKImageCropViewController(image: image, cropMode:.Custom)
        cropper.delegate = self
        cropper.dataSource = self
        presentViewController(cropper, animated: true, completion: nil)
        
    }
}

extension MeInfoVC:RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource{
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        dismissViewControllerAnimated(true, completion: nil)
        self.cover.image = croppedImage
        
        if let t = token,
            let id =  myId{
                upload(.POST, UPLOAD_AVATAR_URL, multipartFormData: { multipartFormData in
                    let dd = "{\"token\":\"\(t)\", \"type\":\"-1\", \"number\":\"1\"}"
                    let jsonData = dd.dataUsingEncoding(NSUTF8StringEncoding)
                    let data = UIImageJPEGRepresentation(croppedImage, 0.75)
                    multipartFormData.appendBodyPart(data:jsonData!, name:"json")
                    multipartFormData.appendBodyPart(data:data!, name:"avatar", fileName:"avatar.jpg", mimeType:"image/jpeg")
               
                    }, encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .Success(let upload, _ , _):
                            upload.responseJSON { response in
                                //debugPrint(response)
                                if let d = response.result.value {
                                    let j = JSON(d)
                                    if j != .null && j["state"].stringValue  == "successful" {
                                        SDImageCache.sharedImageCache().storeImage(self.cover.image, forKey:profileBackgroundURLForID(id).absoluteString, toDisk:true)
                                    }
                                    else {
                                        let alert = UIAlertController(title: "提示", message: j["reason"].stringValue, preferredStyle: .Alert)
                                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                        self.presentViewController(alert, animated: true, completion: nil)
                                        return
                                        
                                        //self.navigationController?.popViewControllerAnimated(true)
                                        
                                    }
                                }
                                else if let error = response.result.error {
                                    let alert = UIAlertController(title: "提示", message: error.localizedFailureReason ?? error.localizedDescription, preferredStyle: .Alert)
                                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                                    self.presentViewController(alert, animated: true, completion: nil)
                                    return
                                    //self.navigationController?.popViewControllerAnimated(true)
                                    
                                    
                                }
                            }
                            
                        case .Failure:
                            //print(encodingError)
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
        return CGRectMake(view.center.x - cover.bounds.size.width/2, view.center.y-cover.bounds.size.height/2, cover.bounds.size.width, cover.bounds.size.height)
    }
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController!) -> UIBezierPath! {
        return UIBezierPath(rect: CGRectMake(view.center.x - cover.bounds.size.width/2, view.center.y-cover.bounds.size.height/2, cover.bounds.size.width, cover.bounds.size.height))
    }
}

extension MeInfoVC:UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset <= 10 {
            navigationController?.navigationBar.translucent = true
            navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            //statusBarView?.alpha = 0
            navigationController?.navigationBar.alpha = 1.0
            statusBarView?.backgroundColor = UIColor.clearColor()
        }
        else if yOffset <= SCREEN_WIDTH*3/4 {
            
            navigationController?.navigationBar.backgroundColor = THEME_COLOR
            statusBarView?.backgroundColor = THEME_COLOR
            //statusBarView?.alpha = (yOffset-10)/90
            navigationController?.navigationBar.alpha = (yOffset-10)/((SCREEN_WIDTH*3/4 - 10.0))
        }
        else {
            navigationController?.navigationBar.backgroundColor = THEME_COLOR
            statusBarView?.backgroundColor = THEME_COLOR
            navigationController?.navigationBar.alpha = 1
        }
    
    }
    
   
}

//MARK: - PersonalInfoVC
class PersonalInfoVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    var id:String!
    private var tableView:UITableView!
    
    private let infomationSections = ["基本信息", "学校信息", "家乡信息", "联系方式","添加关注"]
    private let sectionRows = [2, 2, 1, 2, 1]
    
    private var info:PersonModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame, style: .Grouped)
        //tableView.bounces = false
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(PersonalInfoVCTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PersonalInfoVCTableViewCell))
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell))
        view.addSubview(tableView)
        
        setupUI()
        configUI()
    }
    
    func configUI() {
       
        fetchInfo()
        
    }
    
    func fetchInfo() {
        if let t = token {
            request(.POST, GET_FRIEND_PROFILE_URL, parameters: ["token": t, "id":id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" && json.dictionaryObject != nil else {
                        return
                    }
                    
                    
                    do {
                        let p = try MTLJSONAdapter.modelOfClass(PersonModel.self, fromJSONDictionary: json.dictionaryObject!) as! PersonModel
                        S.info = p
                        S.tableView.reloadData()
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
                
                
                })
        }
        

    }
    
    func setupUI(){
        view.backgroundColor = BACK_COLOR
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let ID = myId where ID != id {
            return infomationSections.count
        }
        else {
            return infomationSections.count - 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infomationSections[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 25:20
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let title = infomationSections[indexPath.section]
        if title != "添加关注"{
            let  cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PersonalInfoVCTableViewCell), forIndexPath: indexPath) as! PersonalInfoVCTableViewCell
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell.infoLabel.text = "姓名"
                    cell.detailLabel.text = info?.name ?? ""
                }
                else {
                    cell.infoLabel.text = "生日"
                    cell.detailLabel.text = info?.birthday ?? ""
                }
            }
            else if indexPath.section == 1  {
                if indexPath.row == 0 {
                    cell.infoLabel.text  = "学校"
                    cell.detailLabel.text = info?.school ?? ""
                }
                else {
                    cell.infoLabel.text = "专业"
                    cell.detailLabel.text = info?.department ?? ""
                }
            }
            else if indexPath.section ==  2{
                cell.infoLabel.text = "家乡"
                cell.detailLabel.text = info?.hometown ?? ""
            }
            else {
                if indexPath.row == 0 {
                    cell.infoLabel.text = "QQ"
                    cell.detailLabel.text = info?.qq ?? ""
                }
                else {
                    cell.infoLabel.text = "微信"
                    cell.detailLabel.text = info?.wechat ?? ""
                }
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell), forIndexPath: indexPath)
            let addFriendButton = UIButton()
            addFriendButton.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(addFriendButton)
            addFriendButton.snp_makeConstraints(closure: { (make) -> Void in
                //make.centerX.equalTo(cell.contentView.snp_centerX)
                make.centerY.equalTo(cell.contentView.snp_centerY)
                make.height.equalTo(cell.contentView.snp_height).offset(-10)
                make.left.equalTo(cell.contentView.snp_leftMargin)
                make.right.equalTo(cell.contentView.snp_rightMargin)
            })
            addFriendButton.addTarget(self, action: "addFriend:", forControlEvents: UIControlEvents.TouchUpInside)
            addFriendButton.layer.cornerRadius = 4.0
            addFriendButton.layer.masksToBounds = true
            addFriendButton.setTitle("添加关注", forState: .Normal)
            addFriendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            addFriendButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            addFriendButton.backgroundColor = THEME_COLOR
            return cell
        }
        
    }
    
    func addFriend(sender:AnyObject) {
        if let t = token, id = info?.ID{
            request(.POST, FOLLOW_URL, parameters: ["token":t, "id":id], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                //debugprint(response)
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                     guard json != .null && json["state"].stringValue == "successful" else{
                        let hud = MBProgressHUD.showHUDAddedTo(S.view, animated: true)
                        hud.mode = .Text
                        hud.labelText = "提示"
                        hud.detailsLabelText = json["reason"].stringValue
                        hud.hide(true, afterDelay: 1)
                        return
                     }
                    
                    let hud = MBProgressHUD.showHUDAddedTo(S.view, animated: true)
                    hud.labelText = "添加好友成功"
                    hud.mode = .CustomView
                    hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hud.hide(true, afterDelay: 1)
                }
            }
            
        }

    }

}

//MARK: -PersonalInfoVCTableViewCell

class PersonalInfoVCTableViewCell:UITableViewCell {
    
    var infoLabel:UILabel!
    var detailLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func initialize() {
        selectionStyle = .None
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        infoLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(infoLabel)
        detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.textAlignment = .Right
        detailLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        contentView.addSubview(detailLabel)
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.centerY.equalTo(contentView.snp_centerY)
            infoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis:.Horizontal)
        }
        
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(infoLabel.snp_centerY)
            make.left.equalTo(infoLabel.snp_right)
            detailLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        }
    }
}
