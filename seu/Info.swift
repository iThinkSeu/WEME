//
//  Info.swift
//  WEME
//
//  Created by liewli on 2016-01-18.
//  Copyright © 2016 li liew. All rights reserved.
//

import UIKit
import RSKImageCropper

enum MenuBarState {
    case dock(CGFloat, CGFloat, CGFloat)
    case float(CGFloat)
}

protocol InfoVCPreviewDelegate:class {
    func didTapMessage(id:String)
    func didTapUnfollow(id:String)
}


class InfoVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var coverImageView:UIImageView!
    var tableView:UITableView!
    
    private var statusBarView:UIView?
    
    var id:String!
    
    var headerView:PersonalHeaderView!
    
    var menuBar:MenuBarView!
    
    let menu = ["资料", "时间轴", "图集"]
    var currentIndex = 0
    
    var info:PersonModel?
    
    var events = [TimelineModel]()
    
    var timelineCurrentPage = 1
    
    weak var delegate:InfoVCPreviewDelegate?
    
    var sheet:IBActionSheet?
    
    private let infos = ["姓名", "生日", "学校", "学历", "专业", "家乡", "QQ", "微信"]
    private let sectionRows = [2, 3, 1, 2, 1]
    
    private var images = [UserImageModel]()
    private var imageCurrentPage = 1
    
    var currentMenuBarState:MenuBarState = .float(0)
    
    @available(iOS 9, *)
    override func previewActionItems() -> [UIPreviewActionItem] {
        let message = UIPreviewAction(title: "私信", style: .Default) { (action, viewController) -> Void in
            self.delegate?.didTapMessage(self.id)
        }
        
        let unfollow = UIPreviewAction(title: "取消关注", style: .Destructive) { (action, vc) -> Void in
            self.delegate?.didTapUnfollow(self.id)
        }
    
        
        return [message, unfollow]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let action = UIBarButtonItem(image: UIImage(named: "more")?.imageWithRenderingMode(.AlwaysTemplate), style: .Plain, target: self, action: "action:")
        action.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = action
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "editInfo:", name: EDIT_INFO_NOTIFICATION, object: nil)
        setupUI()
        visit()
        configUI()
    }
    
    
    func visit() {
        if let t = token, id = id {
            request(.POST, VISIT_URL, parameters: ["token":t, "userid":id], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                
            })
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        sheet?.removeFromView()
    }
    
    func editInfo(sender:NSNotification) {
        if let ID = myId where ID == id {
            headerView.avatar.sd_setImageWithURL(thumbnailAvatarURL(), placeholderImage: UIImage(named: "avatar"))
            fetchInfo()
        }
    }
    
    func action(sender:AnyObject) {
        if let ID = myId where ID != id {
            sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
                if index == 0 {
                    let alertText = AlertTextView(title: "举报", placeHolder: "犀利的写下你的举报内容吧╮(╯▽╰)╭")
                    alertText.delegate = self
                    alertText.showInView(self.navigationController!.view)
                }
                else if index == 1 {
                    let vc = ComposeMessageVC()
                    vc.recvID = self.id
                    let nav = UINavigationController(rootViewController: vc)
                    self.navigationController?.pushViewController(nav, animated: true)
                }
                }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["举报", "私信"])
            sheet?.setButtonTextColor(THEME_COLOR)
            sheet?.showInView(navigationController!.view)
        }
        else {
            sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
                if index == 0 {
                    self.navigationController?.pushViewController(MyQRCodeVC(), animated: true)
                }
                else if index == 1 {
                    self.navigationController?.pushViewController(EditInfoVC(), animated: true)
                }
                else if index == 2 {
                    let imagePicker = UIImagePickerController()
                    imagePicker.navigationBar.barStyle = .Black
                    imagePicker.sourceType = .PhotoLibrary
                    imagePicker.delegate = self
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
                else if index == 3 {
                    let vc = AudioRecordVC()
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["我的二维码","修改个人信息", "改变封面","制作个性语音卡片"])
            sheet?.setButtonTextColor(THEME_COLOR)
            sheet?.showInView(navigationController!.view)
        }
        
    }

    
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
        
        scrollViewDidScroll(tableView)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
    
        if yOffset >= -SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3 && yOffset <= 0  {
            let r = yOffset / (-SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3)
            let yy = (-SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3) * (2*r - r*r)
            coverImageView.frame = CGRectMake(0,  -SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3 - yy, SCREEN_WIDTH, SCREEN_WIDTH )
        }
        else {
            coverImageView.frame = CGRectMake(0,  -SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3 - yOffset, SCREEN_WIDTH, SCREEN_WIDTH )
        }
     
        
        if yOffset <= SCREEN_WIDTH*2/3 - 60 {
            title = ""
            menuBar.frame = CGRectMake(0, SCREEN_WIDTH * 2 / 3  - yOffset, SCREEN_WIDTH, 40)
            currentMenuBarState = .float(yOffset)
        }
        else {
            title = info?.name ?? ""
            menuBar.frame = CGRectMake(0, 60, SCREEN_WIDTH, 40)
            if case .float(_) = currentMenuBarState {
                currentMenuBarState = .dock(yOffset, yOffset, yOffset)
            }
            else if case let .dock(left, mid, right) = currentMenuBarState {
                if currentIndex == 0 {
                    currentMenuBarState = .dock(yOffset, mid, right)
                }
                else if currentIndex == 1 {
                    currentMenuBarState = .dock(left, yOffset, right)
                }
                else if currentIndex == 2 {
                    currentMenuBarState = .dock(left, mid, yOffset)
                }
            }

        }
        
       
        
        if yOffset <= 10 {
            navigationController?.navigationBar.translucent = true
            navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            navigationController?.navigationBar.alpha = 1.0
            statusBarView?.backgroundColor = UIColor.clearColor()
        }
        else if yOffset <= SCREEN_WIDTH*2/3 - 60{
            navigationController?.navigationBar.backgroundColor = THEME_COLOR
            statusBarView?.backgroundColor = THEME_COLOR
            navigationController?.navigationBar.alpha = (yOffset-10)/((SCREEN_WIDTH*2/3 - 70.0))
        }
        else {
            navigationController?.navigationBar.backgroundColor = THEME_COLOR
            statusBarView?.backgroundColor = THEME_COLOR
            navigationController?.navigationBar.alpha = 1
        }
        
    }
    
    func setupUI() {
        view.backgroundColor = BACK_COLOR
        coverImageView = UIImageView(frame:CGRectMake(0, -SCREEN_WIDTH + SCREEN_WIDTH * 2 / 3, SCREEN_WIDTH, SCREEN_WIDTH ))
        view.addSubview(coverImageView)
        tableView = UITableView(frame: view.frame)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell))
        tableView.registerClass(InfoTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(InfoTableViewCell))
        tableView.registerClass(ThreeImageTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ThreeImageTableViewCell))
        tableView.registerClass(TimelineTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineTableViewCell))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        headerView = PersonalHeaderView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 2 / 3))
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        
        menuBar = MenuBarView(frame: CGRectMake(0, SCREEN_WIDTH * 2 / 3, SCREEN_WIDTH, 40))
        menuBar.delegate = self
        view.addSubview(menuBar)
    
    }
    
      
    func fetchVisitInfo() {
        if let t = token, id = id {
            request(.POST, GET_VISIT_INFO_URL, parameters: ["token": t, "userid":id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" && json["result"] != .null && json["result"]["today"] != .null else {
                        return
                    }
                    
                    S.headerView.infoLabel.text = "今日访问 \((json["result"]["today"]).stringValue) 总访问 \(json["result"]["total"].stringValue)"
                    
                }
                
                
                
                })
        }
        
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
                        if S.currentIndex == 0 {
                            S.tableView.reloadData()
                        }
                    }
                    catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                
                
                
                })
        }
        
        
    }
    
    func fetchEvents() {
        if let t = token{
            request(.POST, GET_USER_TIMELINE, parameters: ["token":t, "userid":id, "page":"\(timelineCurrentPage)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null  && json["state"].stringValue == "successful" else {
                        return
                    }
                    do {
                        let events = try MTLJSONAdapter.modelsOfClass(TimelineModel.self, fromJSONArray: json["result"].arrayObject) as! [TimelineModel]
                        if events.count > 0 {
                            S.timelineCurrentPage++
                            var k = S.events.count
                            let indexSets = NSMutableIndexSet()
                            for _ in events {
                                indexSets.addIndex(k++)
                            }
                            S.events.appendContentsOf(events)
                            if S.currentIndex == 1 {
                                S.tableView.insertSections(indexSets, withRowAnimation: .Fade)

                            }
                        }
                    }
                    catch let e as NSError {
                        print(e)
                    }
                }
                })
        }
    }
    
    func fetchImages() {
        if let t = token {
            request(.POST, GET_USER_TIMELINE_IMAGES, parameters: ["token":t, "userid":id, "page":"\(imageCurrentPage)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" else {
                        return
                    }
                    
                    do {
                        let imgs = try MTLJSONAdapter.modelsOfClass(UserImageModel.self, fromJSONArray: json["result"].arrayObject) as! [UserImageModel]
                        if imgs.count > 0 {
                            S.imageCurrentPage++
                            S.images.appendContentsOf(imgs)
                            if (S.currentIndex == 2) {
                                S.tableView.reloadData()
                            }
                            
                        }
                    }
                    catch let e as NSError {
                        print(e)
                    }
                }
                })
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

    
    func configUI() {
        fetchVisitInfo()
        fetchInfo()
        //fetchEvents()
        coverImageView.sd_setImageWithURL(profileBackgroundURLForID(id), placeholderImage: UIImage(named: "info_default"))
        headerView.avatar.sd_setImageWithURL(thumbnailAvatarURLForID(id), placeholderImage: UIImage(named: "avatar"))
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentIndex == 0 {
             return section == 0 ? 40 : 20
        }
        else if currentIndex == 1 {
            return section == 0 ? 40 : 10
        }
        else {
            return section == 0 ? 40 : 20
        }
       
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if currentIndex == 0 {
            let rect = ("历" as NSString).boundingRectWithSize(CGSizeMake(tableView.frame.width, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)], context: nil)
            return ( indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 || indexPath.row == 6) ? rect.height + 40 : 40
        }
        else if currentIndex == 1 {
            return 120
        }
        else {
            return (SCREEN_WIDTH-20) / 3
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if currentIndex == 1 {
            if indexPath.section == events.count - 1{
                fetchEvents()
            }
        }
        else if currentIndex == 2 {
            if indexPath.row == ((images.count + 2)/3) - 1 {
                fetchImages()
            }
        }
    }
    

   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if currentIndex == 0 || currentIndex == 2 {
            return 1
        }
        else {
            return events.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentIndex == 0 {
            if let ID = myId where ID != id {
                return infos.count + 1
            }
            else {
                return infos.count
            }
        }
        else if currentIndex == 1 {
            return 1
        }
        else {
            return (images.count + 2) / 3
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if currentIndex == 0 {
            if indexPath.row < infos.count {
                let  cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(InfoTableViewCell), forIndexPath: indexPath) as! InfoTableViewCell
                cell.titleLabel.text = title
                    cell.infoLabel.text = infos[indexPath.row]
                    if indexPath.row == 0 {
                        cell.titleLabel.text = "基本信息"
                        cell.detailLabel.text = info?.name ?? ""
                    }
                    else if indexPath.row == 1 {
                        cell.detailLabel.text = info?.birthday ?? ""
                    }
                
                    else  if indexPath.row == 2 {
                        cell.titleLabel.text = "学校信息"
                        cell.detailLabel.text = info?.school ?? ""
                    }
                    else if indexPath.row == 3 {
                        cell.detailLabel.text = info?.degree ?? ""
                    }
                    else if indexPath.row == 4 {
                        cell.detailLabel.text = info?.department ?? ""
                    }
            
                    else if indexPath.row ==  5{
                        cell.titleLabel.text = "家乡信息"
                        cell.detailLabel.text = info?.hometown ?? ""
                    }
                 
                    else if indexPath.row == 6 {
                        cell.titleLabel.text = "联系方式"
                        cell.detailLabel.text = info?.qq ?? ""
                    }
                    else {
                        cell.detailLabel.text = info?.wechat ?? ""
                    }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell), forIndexPath: indexPath)
                let addFriendButton = UIButton()
                cell.backgroundColor = BACK_COLOR
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
        else if currentIndex == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TimelineTableViewCell), forIndexPath: indexPath) as! TimelineTableViewCell
            let data = events[indexPath.section]
            let info = "\(data.time.hunmanReadableString())  发布帖子于\(data.topic)"
            let attributed = NSMutableAttributedString(string: info)
            attributed.addAttribute(NSForegroundColorAttributeName, value: THEME_COLOR, range:NSMakeRange(0, data.time.hunmanReadableString().characters.count))
            cell.infoLabel.attributedText = attributed
            cell.titleLabel.text = data.title
            cell.bodyLabel.text = data.body
            cell.thumbnail.sd_setImageWithURL(data.image, placeholderImage: UIImage(named: "avatar"))
            cell.selectionStyle = .None
            return cell

        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ThreeImageTableViewCell), forIndexPath: indexPath) as! ThreeImageTableViewCell
            let startIdx = 3 * indexPath.row
            cell.leftImageView.sd_setImageWithURL(images[startIdx].thumbnail)
            if startIdx + 1 < images.count {
                cell.midImageView.sd_setImageWithURL(images[startIdx + 1].thumbnail)
            }
            if startIdx + 2 < images.count {
                cell.rightImageView.sd_setImageWithURL(images[startIdx + 2].thumbnail)
            }
            cell.selectionStyle = .None
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if currentIndex == 1 {
            let data = events[indexPath.section]
            let vc = PostVC()
            vc.postID = data.postid
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension InfoVC:AlertTextViewDelegate {
    func alertTextView(alertView: AlertTextView, doneWithText text: String?) {
        if let t = token, s = text where s.characters.count > 0 {
            request(.POST, REPORT_URL, parameters: ["token":t, "body": s , "type":"user", "typeid": id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json["state"].stringValue == "successful" else {
                        return
                    }
                    let hud = MBProgressHUD.showHUDAddedTo(S.view, animated: true)
                    hud.mode = .CustomView
                    hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hud.labelText = "举报成功"
                    hud.hide(true, afterDelay: 1.0)
                }
                })

        }
    }
}

extension InfoVC:ThreeImageTableViewCellDelegate {
    func didTapImageAtThreeImageTableViewCell(cell: ThreeImageTableViewCell, atIndex idx: Int) {
        if currentIndex == 2 {
            if let indexPath = tableView.indexPathForCell(cell) {
                let browser = MWPhotoBrowser(delegate: self)
                browser.setCurrentPhotoIndex(UInt(indexPath.row * 3 + idx))
                browser.displayActionButton = false
                navigationController?.pushViewController(browser, animated: true)

            }
        }
    }
}

extension InfoVC:MenuBarViewDelegate {
    func didSelectButtonAtIndex(index: Int) {
        if index == 0 {
            currentIndex = 0
            
            if case let .float(yOffset) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, yOffset), animated: false)
            }
            else if case let .dock(left, _, _) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, left), animated: false)
            }
            tableView.reloadData()

            fetchInfo()
        }
        else if index == 1 {
            currentIndex = 1
            
            if case let .float(yOffset) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, yOffset), animated: false)
            }
            else if case let .dock(_, mid, _) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, mid), animated: false)
            }
            tableView.reloadData()
            if events.count == 0 {
                fetchEvents()
            }
        }
        else if index == 2 {
            currentIndex = 2
            
            
            if case let .float(yOffset) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, yOffset), animated: false)
            }
            else if case let .dock(_, _,right) = currentMenuBarState {
                tableView.setContentOffset(CGPointMake(0, right), animated: false)
            }
            tableView.reloadData()
            if images.count == 0 {
                fetchImages()
            }
        }
    }
}

extension InfoVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let cropper = RSKImageCropViewController(image: image, cropMode:.Custom)
        cropper.delegate = self
        cropper.dataSource = self
        presentViewController(cropper, animated: true, completion: nil)
        
    }
}

extension InfoVC:RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource{
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        dismissViewControllerAnimated(true, completion: nil)
        self.coverImageView.image = croppedImage
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
                                        SDImageCache.sharedImageCache().storeImage(croppedImage, forKey:profileBackgroundURLForID(id).absoluteString)
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
        return CGRectMake(view.center.x - coverImageView.bounds.size.width/2, view.center.y-coverImageView.bounds.size.height/2, coverImageView.bounds.size.width, coverImageView.bounds.size.height)
    }
    
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController!) -> UIBezierPath! {
        return UIBezierPath(rect: CGRectMake(view.center.x - coverImageView.bounds.size.width/2, view.center.y-coverImageView.bounds.size.height/2, coverImageView.bounds.size.width, coverImageView.bounds.size.height))
    }
}

extension InfoVC:MWPhotoBrowserDelegate {
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(images.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        let data = images[Int(index)]
        let photo = MWPhoto(URL: data.image)
        var body = data.body
        if data.body.characters.count > 24 {
            body = data.body.substringWithRange(Range<String.Index>(start: data.body.startIndex, end: data.body.startIndex.advancedBy(24))) + "..."
        }
        let text = "发布于\(data.topic)\n\(data.title)\n\(body)\n\(data.time.hunmanReadableString())"
        var start = 0;
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes([NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1),
            NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(start, data.topic.characters.count + 3))
        start += data.topic.characters.count + 4
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline), range: NSMakeRange(start, data.title.characters.count))
        start += data.title.characters.count + 1
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote), range: NSMakeRange(start, body.characters.count))
        start += body.characters.count + 1
        attributedText.addAttributes([NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1),
            NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(start, data.time.hunmanReadableString().characters.count))
        photo.caption = attributedText
        return photo
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, didTapCaptionViewAtIndex index: UInt) {
        let data = images[Int(index)]
        let vc = PostVC()
        vc.postID = data.postid
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension InfoVC:PersonalHeaderViewDelegate {
    func didTapAvatar() {
        let showImg = Agrume(imageURL: avatarURLForID(id))
        showImg.showFrom(self)
    }
}

protocol PersonalHeaderViewDelegate:class {
    func didTapAvatar()
}
class PersonalHeaderView:UIView {
    
    var avatar:UIImageView!
    var infoLabel:DLLabel!
    weak var delegate:PersonalHeaderViewDelegate?
    func initialize() {
        backgroundColor = UIColor.clearColor()
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        avatar.addGestureRecognizer(tap)
        addSubview(avatar)
        
        infoLabel = DLLabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoLabel)
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        infoLabel.textAlignment = .Center
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(84)
            make.centerY.equalTo(snp_centerY)
            make.centerX.equalTo(snp_centerX)
            avatar.layer.cornerRadius = 42
            avatar.layer.masksToBounds = true
            avatar.layer.borderWidth = 2.0
            avatar.layer.borderColor = UIColor.whiteColor().CGColor
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(avatar.snp_bottom).offset(5)
        }

 
    }
    
    func tapAvatar(sender:AnyObject?) {
        delegate?.didTapAvatar()
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
protocol MenuBarViewDelegate:class {
    func didSelectButtonAtIndex(index:Int)
}
class MenuBarView:UIView {
    var leftButton:UIButton!
    var midButton:UIButton!
    var rightButton:UIButton!
    //var bottomline:UIView!
    //var hairline:UIView!
    weak var delegate:MenuBarViewDelegate?
    
    func initialize() {
        backgroundColor = UIColor.whiteColor()
        leftButton = UIButton()
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftButton)
        leftButton.backgroundColor = UIColor.whiteColor()
        leftButton.setTitle("个人资料", forState: .Normal)
        leftButton.setTitleColor(THEME_COLOR, forState: .Normal)
        leftButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        leftButton.addTarget(self, action: "tapButton:", forControlEvents: .TouchUpInside)
        leftButton.tag = 0
        
        midButton = UIButton()
        midButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(midButton)
        midButton.backgroundColor = UIColor.whiteColor()
        midButton.setTitle("时间轴", forState: .Normal)
        midButton.setTitleColor(TEXT_COLOR, forState: .Normal)
        midButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        midButton.addTarget(self, action: "tapButton:", forControlEvents: .TouchUpInside)
        midButton.tag = 1
        
        rightButton = UIButton()
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightButton)
        rightButton.backgroundColor = UIColor.whiteColor()
        rightButton.setTitle("图集", forState: .Normal)
        rightButton.setTitleColor(TEXT_COLOR, forState: .Normal)
        rightButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        rightButton.addTarget(self, action: "tapButton:", forControlEvents: .TouchUpInside)
        rightButton.tag = 2
        
//        bottomline = UIView()
//        bottomline.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(bottomline)
        
        leftButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.centerY.equalTo(snp_centerY)
        }
        
        midButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftButton.snp_right)
            make.centerY.equalTo(leftButton.snp_centerY)
            make.width.equalTo(leftButton.snp_width)
        }
        
        rightButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(midButton.snp_right)
            make.right.equalTo(snp_right)
            make.centerY.equalTo(midButton.snp_centerY)
            make.width.equalTo(midButton.snp_width)
            
        }
        
//        bottomline.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(leftButton.snp_bottom)
//            make.height.equalTo(2)
//            make.left.equalTo(snp_left)
//            make.right.equalTo(snp_right)
//            make.bottom.equalTo(snp_bottom)
//        }
//        
        
        
    }
    
    func tapButton(sender:UIButton) {
 
        leftButton.setTitleColor(TEXT_COLOR, forState: .Normal)
        midButton.setTitleColor(TEXT_COLOR, forState: .Normal)
        rightButton.setTitleColor(TEXT_COLOR, forState: .Normal)
        
        sender.setTitleColor(THEME_COLOR, forState: .Normal)
        
        delegate?.didSelectButtonAtIndex(sender.tag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


protocol ThreeImageTableViewCellDelegate:class {
    func didTapImageAtThreeImageTableViewCell(cell:ThreeImageTableViewCell, atIndex:Int)
}
class ThreeImageTableViewCell:UITableViewCell {
    var leftImageView:UIImageView!
    var midImageView:UIImageView!
    var rightImageView:UIImageView!
    weak var delegate:ThreeImageTableViewCellDelegate?
    
    func initialize() {
        leftImageView = UIImageView()
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        leftImageView.userInteractionEnabled = true
        leftImageView.tag = 0
        let tap = UITapGestureRecognizer(target: self, action: "tapImg:")
        leftImageView.addGestureRecognizer(tap)
        contentView.addSubview(leftImageView)
        
        midImageView = UIImageView()
        midImageView.translatesAutoresizingMaskIntoConstraints = false
        midImageView.tag = 1
        midImageView.userInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: "tapImg:")
        midImageView.addGestureRecognizer(tap1)
        contentView.addSubview(midImageView)
        
        rightImageView = UIImageView()
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.tag = 2
        rightImageView.userInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: "tapImg:")
        rightImageView.addGestureRecognizer(tap2)
        contentView.addSubview(rightImageView)
        
        leftImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.centerY.equalTo(contentView.snp_centerY)
            make.height.equalTo(leftImageView.snp_width)
        }
        
        midImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftImageView.snp_right).offset(10)
            make.centerY.equalTo(contentView.snp_centerY)
            make.height.equalTo(midImageView.snp_width)
            make.width.equalTo(leftImageView.snp_width)
        }
        
        rightImageView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(midImageView.snp_right).offset(10)
            make.centerY.equalTo(contentView.snp_centerY)
            make.right.equalTo(contentView.snp_rightMargin)
            make.height.equalTo(rightImageView.snp_width)
            make.width.equalTo(midImageView.snp_width)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func tapImg(tap:UITapGestureRecognizer) {
        if let v = tap.view as? UIImageView{
            if v.image != nil {
                delegate?.didTapImageAtThreeImageTableViewCell(self, atIndex: v.tag)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftImageView.image = nil
        midImageView.image = nil
        rightImageView.image = nil
    }
}

class InfoTableViewCell:UITableViewCell {
    var titleLabel:UILabel!
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
        let containerView = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        titleLabel.backgroundColor = BACK_COLOR
        titleLabel.textColor = TEXT_COLOR
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        infoLabel.textColor = UIColor.lightGrayColor()
        containerView.addSubview(infoLabel)
        detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.textAlignment = .Right
        detailLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        detailLabel.textColor = TEXT_COLOR
        containerView.addSubview(detailLabel)
        
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
            
        }
        
        containerView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(contentView.snp_bottom)
            containerView.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Vertical)
        }
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(containerView.snp_centerY)
            make.left.equalTo(containerView.snp_leftMargin)
            infoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis:.Horizontal)
        }
        
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(containerView.snp_rightMargin)
            make.centerY.equalTo(infoLabel.snp_centerY)
            make.left.equalTo(infoLabel.snp_right)
            detailLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        }
    }
    
}

class TimelineTableViewCell:UITableViewCell {
    var infoLabel:UILabel!
   // var moreAction:UIImageView!
    var thumbnail:UIImageView!
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    
    func initialize() {
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        contentView.addSubview(infoLabel)
        
//        moreAction = UIImageView(image: UIImage(named: "more"))
//        moreAction.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(moreAction)
        
        thumbnail = UIImageView()
        thumbnail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnail)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        contentView.addSubview(titleLabel)
        
        bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        bodyLabel.textColor = UIColor.lightGrayColor()
        bodyLabel.numberOfLines = 2
        bodyLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(bodyLabel)
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.top.equalTo(contentView.snp_topMargin)
        }
        
//        moreAction.snp_makeConstraints { (make) -> Void in
//            make.width.height.equalTo(24)
//            make.right.equalTo(contentView.snp_rightMargin)
//            make.left.equalTo(infoLabel.snp_right)
//            make.centerY.equalTo(infoLabel.snp_centerY)
//        }
        
        thumbnail.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(60)
            make.left.equalTo(contentView.snp_leftMargin)
            make.top.equalTo(infoLabel.snp_bottom).offset(10)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(thumbnail.snp_top)
            make.left.equalTo(thumbnail.snp_right).offset(5)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        bodyLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleLabel.snp_left)
            make.right.equalTo(contentView.snp_rightMargin)
            make.bottom.equalTo(thumbnail.snp_bottom)
            make.top.equalTo(titleLabel.snp_bottom)
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
