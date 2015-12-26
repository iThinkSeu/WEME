//
//  PostVC.swift
//  牵手东大
//
//  Created by liewli on 11/20/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit
import WebImage

struct PostDetail {
    var postid:String = ""
    var userid:String = ""
    var name:String = ""
    var school:String = ""
    var gender:String = ""
    var timestamp:String = ""
    var title:String = ""
    var body:String = ""
    var flag:String = ""
    var likenumber:String = ""
    var commentnumber:String = ""
    var imageurl = [String]()
    var likeusers = [String]()
}

struct Comment {
    let id:String
    let userID:String
    let name:String
    let school:String
    let gender:String
    let timestamp:String
    let body:String
    let flag:String
    let likenumber:String
    let reply:[Reply]
    let thumbnail:[String]
    let image:[String]
    
}

struct Reply {
    let id:String
    let userid:String
    let name:String
    let body:String
    let destcommentid:String
    let destname:String
    let destuserid:String
}

class PostVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var postID:String!
    var post:PostDetail = PostDetail()
    var comments = [Comment]()
    var refreshCont:UIRefreshControl!
    var currentPage = 1
    var isLoading = false {
        didSet{
            print(isLoading)
        }
    }
    var tableView:UITableView!
    var input:STInputBar!
    var tapGesture:UITapGestureRecognizer!
    var alldone = false
    //var pageArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame, style: .Grouped)
        tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        input = STInputBar()
        input.fitWhenKeyboardShowOrHide = true
        input.placeHolder = "说点什么吧..."
        let adjust = navigationController != nil ? UIApplication.sharedApplication().statusBarFrame.height + (navigationController?.navigationBar.frame.height)! : 0
        input.center = CGPointMake(view.frame.width/2, view.bounds.size.height-input.frame.size.height/2-adjust)
        input.adjust = adjust
        input.hidden = true
        view.addSubview(input)
        
        
        tableView.registerClass(CommentHeaderView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(CommentHeaderView))
        tableView.registerClass(CommentFooterView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(CommentFooterView))
        tableView.registerClass(PostArticleTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PostArticleTableViewCell))
        tableView.registerClass(PostCommmentTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PostCommmentTableViewCell))
        tableView.registerClass(PostCommentTableImageViewCell.self, forCellReuseIdentifier:NSStringFromClass(PostCommentTableImageViewCell))
        
       // tableView.rowHeight = UITableViewAutomaticDimension
      //  tableView.estimatedRowHeight = PostCommentImageController.SIZE + 200
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(-1, 0, 20, 0)
        tableView.backgroundColor = BACK_COLOR
        //tableView.allowsSelection = false
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReplyPost:", name: ReplyPostVC.DID_REPLY_POST_NOTIFICATION, object: nil)
        refreshCont = UIRefreshControl()
        refreshCont.backgroundColor = UIColor.clearColor()
        refreshCont.tintColor = UIColor.clearColor()
        refreshCont.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshCont)
        
        if WXApi.isWXAppInstalled() {
            let share = UIBarButtonItem(image: UIImage(named: "share")?.imageWithRenderingMode(.AlwaysTemplate), style: UIBarButtonItemStyle.Plain, target: self, action: "share:")
            share.tintColor = THEME_COLOR
            navigationItem.rightBarButtonItem = share
        }
        
        WXApiManager.sharedManager().delegate = self
        
        //print(WXApi.isWXAppInstalled())
        
        configUI()
    }

    func shareToWeChat(scene: UInt32) {
        var image:UIImage?
        if self.post.imageurl.count > 0 {
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! PostArticleTableViewCell
            let imgCell =  cell.imageCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! TopicImageCollectionViewCell
            image = Utility.imageWithImage(imgCell.imgView.image, scaledToSize: CGSizeMake(100, 100))//
            
        }
        let title = self.post.title.characters.count < 500 ? self.post.title : self.post.title.substringWithRange(Range<String.Index>(start: self.post.title.startIndex, end: self.post.title.startIndex.advancedBy(500)))
        let body = self.post.body.characters.count < 1000 ? self.post.body : self.post.body.substringWithRange(Range<String.Index>(start: self.post.body.startIndex, end: self.post.body.startIndex.advancedBy(1000)))
       // WXApiRequestHandler.sendAppContentData(nil, extInfo: "", extURL: sharePostURLStringForPostID(self.post.postid), title: title, description: body, messageExt: "", messageAction: "", thumbImage: image, inScene: WXScene.init(rawValue: scene))
        WXApiRequestHandler.sendLinkURL(sharePostURLStringForPostID(self.post.postid), tagName: "WeMe", title: title, description: body, thumbImage: image, inScene: WXScene.init(rawValue:scene))
    }
    
    func share(sender:AnyObject) {
        let sheet = IBActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["分享到微信会话", "分享到微信朋友圈"])
        sheet.showInView((UIApplication.sharedApplication().delegate?.window)!)
        sheet.setButtonTextColor(THEME_COLOR)

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let rect = (post.title as NSString).boundingRectWithSize(CGSizeMake(tableView.frame.size.width-20, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)], context: nil)
            let titleHeight = rect.height
            let bodyRect = (post.body as NSString).boundingRectWithSize(CGSizeMake(tableView.frame.size.width-20, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)], context: nil)
            
            let bodyHeight = bodyRect.height
            
            let row = CGFloat((post.imageurl.count+2)/3)
            let imgHeight = row*PostImageManager.SIZE+5*(row+1)
            return 80 + titleHeight + bodyHeight + imgHeight + 70
            
        }
        else {
            let data = self.comments[indexPath.section-1]
            if indexPath.row == 0 {
                let bodyRect = (data.body as NSString).boundingRectWithSize(CGSizeMake(tableView.frame.size.width-80, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)], context: nil)
                if data.image.count > 0 {
                    return bodyRect.height + PostCommentImageController.SIZE + 20 + 10
                }
                else {
                    return bodyRect.height
                }
            }
            else {
                let reply = data.reply[indexPath.row-1]
                let bodyRect = ("xxxxxxxxxxxxx" + reply.body as NSString).boundingRectWithSize(CGSizeMake(tableView.frame.size.width-80, CGFloat.max), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)], context: nil)
                return bodyRect.height + 10
            }
        }
    }
    
    func refresh(sender:AnyObject?) {
      
        let endTime = dispatch_time(DISPATCH_TIME_NOW, Int64( 1 * NSEC_PER_SEC))
        dispatch_after(endTime, dispatch_get_main_queue()) { () -> Void in
            self.refreshCont.endRefreshing()
        }
        if !isLoading {
            reloadComments()
        }
    }
    
    deinit {
        WXApiManager.sharedManager().delegate = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didReplyPost(sender:AnyObject) {
        reloadComments()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //input.center = CGPointMake(view.frame.width/2, view.bounds.size.height-input.frame.size.height/2-t)
    }
    
    func configUI() {
       // pageArray.insert(0, atIndex: 0)
        fetchPostDetail()
        //refresh(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
       // navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.barTintColor = THEME_COLOR
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()//UIColor.colorFromRGB(0x32CD32)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.alpha = 1
    }
    
    

  
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 + comments.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return comments[section-1].reply.count + 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PostArticleTableViewCell), forIndexPath: indexPath) as! PostArticleTableViewCell
            
            //cell.avatar.image = UIImage(named: "dev_liuli")
            cell.avatar.sd_setImageWithURL(thumbnailAvatarURLForID(post.userid), placeholderImage: UIImage(named: "avatar"))
            cell.nameLabel.text = post.name//"牵手东大官方帐号"
            cell.infoLabel.text = post.school//"东南大学・射手座"
            let dateFormat = NSDateFormatter(withUSLocaleAndFormat: "EE, d LLLL yyyy HH:mm:ss zzzz")
            if let date = dateFormat.dateFromString(post.timestamp) {
                cell.timeLabel.text = date.hunmanReadableString()
            }
            if post.flag == "1" {
                cell.likeImage.image = UIImage(named: "liked")?.imageWithRenderingMode(.AlwaysTemplate)
            }
            cell.titleLabel.text = post.title//"好奇心远比雄心走的更远"
            cell.bodyLabel.text = post.body//" <<丈量世界>>里的主人公--数学家高斯和博物学家洪堡，一个足不出户，一个步行天下，两人本不是一路人, 却在与世隔绝之后的书中相遇。他们身上有一个最大的共同特点就是，对未知世界的探索。\n虽然我们毕生追求的事业最后都会衰退和消亡，但是人最大的价值是对未知世界的探索，即好奇心。\n牵手社区新版块“看世界”，带你看看未知的世界！本版块欢迎分享身边“最熟悉的不知道”。\n老规矩，请不要在本版块发布水帖或者恶意晒自拍，若发现立马拎进小黑屋，没得商量 （傲娇脸"
            cell.commentLabel.text = post.commentnumber//"\(1 + (random()%1000))"
            cell.likeLabel.text = post.likenumber//"\(1 + (random()%1000))"
            if cell.imgController == nil {
                cell.imgController = PostImageManager()
            }
            
            cell.imgController?.imageURLs = post.imageurl
            if cell.likeController == nil {
                cell.likeController = PostLikeImageManager()
            }
            cell.likeController?.likeIDs = post.likeusers
            
            cell.selectedBackgroundView = UIView()
            cell.selectionStyle = .None
            cell.delegate = self
            return cell
        }
        else {
            
            if indexPath.row == 0 {
                let data = comments[indexPath.section-1]
                if data.thumbnail.count == 0 || data.image.count == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PostCommmentTableViewCell), forIndexPath: indexPath) as! PostCommmentTableViewCell
                    cell.commentLabel.attributedText = NSAttributedString(string: data.body)
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PostCommentTableImageViewCell), forIndexPath: indexPath) as! PostCommentTableImageViewCell
                    cell.commentLabel.attributedText = NSAttributedString(string: data.body)
                    if cell.imgController == nil {
                        cell.imgController = PostCommentImageController()
                    }
                    cell.imgController.imageURLs = data.thumbnail
                    cell.delegate = self
                    cell.selectionStyle = .None
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PostCommmentTableViewCell), forIndexPath: indexPath) as! PostCommmentTableViewCell
                
                let data = comments[indexPath.section-1].reply[indexPath.row-1]
                let attributedText = NSMutableAttributedString(string: "⎥\(data.name) 回复 \(data.destname)：\(data.body)")
                attributedText.addAttribute(NSForegroundColorAttributeName, value: THEME_COLOR, range: NSMakeRange(0, data.name.characters.count+1))
                attributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(13), range: NSMakeRange(0, data.name.characters.count+1))
                attributedText.addAttribute(NSForegroundColorAttributeName, value: THEME_COLOR, range: NSMakeRange(data.name.characters.count+5, data.destname.characters.count))
                attributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(13), range: NSMakeRange(data.name.characters.count+5, data.destname.characters.count))
                cell.commentLabel.attributedText = attributedText
                return cell
            }
            
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(NSStringFromClass(CommentHeaderView)) as! CommentHeaderView
            let data = comments[section-1]
            //header.avatar.image = UIImage(named: "dev_liuli")
            header.avatar.sd_setImageWithURL(thumbnailAvatarURLForID(data.userID), placeholderImage: UIImage(named: "avatar"))
            header.nameLabel.text = data.name//"刘历"
            header.infoLabel.text = data.school//"东南大学・射手座"
            let dateFormat = NSDateFormatter(withUSLocaleAndFormat: "EE, d LLLL yyyy HH:mm:ss zzzz")
            if let date = dateFormat.dateFromString(data.timestamp) {
                header.timeLabel.text = date.hunmanReadableString()
            }
            header.tag = section
            header.delegate = self
            return header
        }
        return nil
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section > 0 {
            let footer = tableView.dequeueReusableHeaderFooterViewWithIdentifier(NSStringFromClass(CommentFooterView)) as! CommentFooterView
            let data = comments[section-1]
            if data.flag == "1" {
                footer.likeImage.image = UIImage(named: "liked")?.imageWithRenderingMode(.AlwaysTemplate)
            }
            footer.commentLabel.text = "\(data.reply.count)"//"\(1 + (random()%1000))"
            footer.likeLabel.text = data.likenumber//"\(1 + (random()%1000))"
            footer.tag = section
            footer.delegate = self
            return footer
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 50
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 30
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section >= comments.count - 5 && !isLoading {
            fetchComments()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section > 0 {
            if indexPath.row == 0 {
                let id = comments[indexPath.section-1].id
                replyToComment(id, atSection: indexPath.section)
            }
            else {
                let id = comments[indexPath.section-1].reply[indexPath.row-1].id
                replyToComment(id, atSection: indexPath.section)
            }
        }
    }
    
    
    func fetchPostDetail() {
        print(__FUNCTION__)
        if let t = token {
            request(.POST, GET_POST_DETAIL, parameters: ["token":t, "postid":postID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    
                    guard json != .null && json["state"] == "successful" && json["result"] != .null && json["result"]["postid"] != .null && json["result"]["userid"] != .null  && json["result"]["likeusers"].array != nil else {
                        return
                    }
                    let result = json["result"]
                    var like = [String]()
                    for u in result["likeusers"].array! {
                        like.append(u.stringValue)
                    }
                    S.post = PostDetail(postid:result["postid"].stringValue, userid: result["userid"].stringValue, name: result["name"].stringValue, school: result["school"].stringValue, gender: result["gender"].stringValue, timestamp: result["timestamp"].stringValue, title: result["title"].stringValue, body: result["body"].stringValue, flag: result["flag"].stringValue,likenumber: result["likenumber"].stringValue, commentnumber: result["commentnumber"].stringValue, imageurl: (result["imageurl"].arrayObject as! [String]), likeusers: like)
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        S.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Fade)
                    //})
                
                }
            })
        }
    }
    
    func fetchComments() {
        print(__FUNCTION__)
        if let t = token {
            isLoading = true
            request(.POST, GET_POST_COMMENT, parameters: ["token":t, "postid":postID, "page":"\(currentPage)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    
                    guard json != .null && json["state"].stringValue == "successful" && json["result"] != .null else {
                        return
                    }
                    guard let arr = json["result"].array where arr.count > 0 else {
                        return
                    }
                    
                    var comm = [Comment]()
                    var k = S.comments.count + 1
                    let indexSets = NSMutableIndexSet()
                    var indexPaths = [NSIndexPath]()
                    for a in arr {
                        guard a["id"] != .null && a["userid"] != .null && a["reply"].array != nil else {
                            continue
                        }
                        
                        var reply = [Reply]()
                        var s = 0
                        for r in a["reply"].array! {
                            guard r["id"] != .null else {
                                continue
                            }
                            
                            let re = Reply(id:r["id"].stringValue,userid: r["authorid"].stringValue, name: r["name"].stringValue, body: r["body"].stringValue, destcommentid: r["destcommentid"].stringValue, destname: r["destname"].stringValue, destuserid: r["destuserid"].stringValue)
                            indexPaths.append(NSIndexPath(forRow: s++, inSection: k))
                            reply.append(re)
                        }
                       // k++
                        let c = Comment(id: a["id"].stringValue, userID: a["userid"].stringValue, name: a["name"].stringValue, school: a["school"].stringValue, gender: a["gender"].stringValue, timestamp: a["timestamp"].stringValue, body: a["body"].stringValue, flag:a["flag"].stringValue, likenumber: a["likenumber"].stringValue, reply: reply, thumbnail:(a["thumbnail"].arrayObject?.count > 0 ? a["thumbnail"].arrayObject as! [String]:[String]()), image:(a["image"].arrayObject?.count > 0 ? a["image"].arrayObject as! [String] : [String]()))
                        comm.append(c)
                       // S.pageArray.insert(S.currentPage, atIndex: k)
                        indexSets.addIndex(k++)
                    }
                    if comm.count == 0 {
                        S.alldone = true
                    }
                    if comm.count > 0 && comm.count == indexSets.count{
                        S.currentPage++
                        S.comments.appendContentsOf(comm)
                       // let oldIndexPath = S.tableView.indexPathsForVisibleRows![0]
                       // let before = S.tableView.rectForRowAtIndexPath(oldIndexPath)
                       
                        
                        //S.tableView.beginUpdates()
                        //S.tableView.insertSections(indexSets, withRowAnimation: .None)
//                        if #available(iOS 9.0, *) {
//                           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                               // let offset = S.tableView.contentOffset
//                                S.tableView.reloadData()
//                                //S.tableView.contentOffset = offset
//                           // })
//                        }
//                        else {
                           // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                //let offset = S.tableView.contentOffset
                               // S.tableView.reloadData()
                                //S.tableView.contentOffset = offset
                           // })
                            S.tableView.beginUpdates()
                            S.tableView.insertSections(indexSets, withRowAnimation: .Fade)
                            S.tableView.endUpdates()

                        //}
                        
                        //let after = S.tableView.rectForRowAtIndexPath(oldIndexPath)
                        //offset.y += after.origin.y - before.origin.y
                        
                        //S.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                        //S.tableView.endUpdates()
                    }
                    S.isLoading = false
                }
            })
        }
    }
    

    
    func likePost() {
        if let t = token, id = myId {
            request(.POST, LIKE_POST, parameters: ["token":t, "postid":post.postid], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" else {
                        return
                    }
                   // S.post.likenumber = "\(Int(S.post.likenumber)!+1)"
                    //S.post.likeusers.insert(id, atIndex: 0)
                    //S.tableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .None)
                    S.fetchPostDetail()
                }
            })
        }
    }
    
    func tap(sender:AnyObject) {
        hideInput()
    }
    
    func reloadComments() {
       // print(__FUNCTION__)
        alldone = false
        fetchPostDetail()
        comments.removeAll()
        tableView.reloadData()
//            let indexSets = NSMutableIndexSet()
//            for k in 1...comments.count {
//                indexSets.addIndex(k)
//            }
//            tableView.deleteSections(indexSets, withRowAnimation: .Fade)
        currentPage = 1
        fetchComments()
        
    }
    
    func showInput() {
        input.hidden = false
        input.textView.becomeFirstResponder()
        view.addGestureRecognizer(tapGesture)
    }
    
    func replyToComment(id:String, atSection section:Int) {
        input.enablePhoto = false
        showInput()
        input.setDidSendClicked { [weak self](text) -> Void in
            if let S = self, t = token {
                request(.POST, REPLY_COMMENT, parameters: ["token":t, "destcommentid":id, "body":text], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                    debugPrint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        guard json != .null && json["state"].stringValue == "successful" else {
                            return
                        }
                        S.reloadComment(section)
                    }
                })
            }
            
            self?.hideInput()
        }
    }
    
    func commentPost() {
        input.enablePhoto = true
        showInput()
        input.setDidSendClicked { [weak self](text) -> Void in
            if let S = self, t = token {
                request(.POST, COMMENT_POST, parameters: ["token":t, "postid":S.post.postid, "body":text], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                    debugPrint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        guard json != .null && json["state"].stringValue == "successful" else {
                            return
                        }
                        
                        S.reloadComments()
                    }
                })
            }
            
            self?.hideInput()
        }
        
        input.setDidPhotoClicked { [weak self](text) -> Void in
            self?.hideInput()
            if let S = self {
                let vc = ReplyPostVC()
                vc.postID = S.post.postid
                vc.body = text
                let nav = UINavigationController(rootViewController: vc)
                S.presentViewController(nav, animated: true, completion: nil)
            }
            
        }
    }
    
    func hideInput() {
        input.textView.resignFirstResponder()
        input.hidden = true
        view.removeGestureRecognizer(tapGesture)
        //input.center = CGPointMake(view.frame.width/2, view.bounds.size.height-input.frame.size.height/2-adjust)
    }
    
    func reloadComment(section:Int) {
        fetchPostDetail()
        guard section > 0 && section <= comments.count else {
            return
        }
        let id = comments[section-1].id
        if let t = token {
            request(.POST, GET_COMMENT_BY_COMMENTID, parameters: ["token":t, "commentid":id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" && json["result"] != .null && json["result"]["id"] != .null && json["result"]["reply"].array != nil else {
                        return
                    }
                    let a = json["result"]
                    var reply = [Reply]()
                    for r in a["reply"].array! {
                        guard r["id"] != .null else {
                            continue
                        }
                        
                        let re = Reply(id:r["id"].stringValue, userid: r["authorid"].stringValue, name: r["name"].stringValue, body: r["body"].stringValue, destcommentid: r["destcommentid"].stringValue, destname: r["destname"].stringValue, destuserid: r["destuserid"].stringValue)
                        
                        reply.append(re)
                    }
              
                    let c = Comment(id: a["id"].stringValue, userID: a["userid"].stringValue, name: a["name"].stringValue, school: a["school"].stringValue, gender: a["gender"].stringValue, timestamp: a["timestamp"].stringValue, body: a["body"].stringValue, flag:a["flag"].stringValue, likenumber: a["likenumber"].stringValue, reply: reply, thumbnail:(a["thumbnail"].arrayObject?.count > 0 ? a["thumbnail"].arrayObject as! [String]:[String]()), image:(a["image"].arrayObject?.count > 0 ? a["image"].arrayObject as! [String] : [String]()))
                    
                    S.comments.replaceRange((section-1)..<section, with: [c])
                    //if #available(iOS 9.0, *) {
                        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //S.tableView.beginUpdates()
                           // let offset = S.tableView.contentOffset
                            //
                          //  S.tableView.reloadData()
                            //S.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Fade)
                          //  S.tableView.contentOffset = offset
                            //S.tableView.endUpdates()
                        //})
                   // }
                  //  else {
                       // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            S.tableView.beginUpdates()
                            //let offset = S.tableView.contentOffset
                            //
                           //S.tableView.reloadData()
                            S.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: .Fade)
                            //S.tableView.contentOffset = offset
                            S.tableView.endUpdates()
                        //})

                    //}
                }
            })
        }
    }
}

//MARK: -ActionSheet
extension PostVC:IBActionSheetDelegate {
    func actionSheet(actionSheet: IBActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.shareToWeChat(0)
        }
        else if buttonIndex == 1 {
            self.shareToWeChat(1)
        }
    }
}

//MARK: - WeChat
extension PostVC :WXApiManagerDelegate {

    
    func managerDidRecvAddCardResponse(response: AddCardToWXCardPackageResp!) {
        
    }
    
    func managerDidRecvGetMessageReq(request: GetMessageFromWXReq!) {
        
    }
    
    func managerDidRecvAuthResponse(response: SendAuthResp!) {
        
    }
    
    func managerDidRecvLaunchFromWXReq(request: LaunchFromWXReq!) {
        
    }
    
    func managerDidRecvMessageResponse(response: SendMessageToWXResp!) {
        print(response.errCode)
    }
    
    func managerDidRecvShowMessageReq(request: ShowMessageFromWXReq!) {
        print("\(__FUNCTION__)")
    }
}


extension PostVC : PostArticleTableViewCellDelegate {
    func didTapComment() {
        commentPost()
    }
    
    func didTapLike() {
        likePost()
    }
    
    
    func showProfileFor(id:String) {
        //if let Id = myId where Id != id{
            let vc = MeInfoVC()
            vc.id = id
            navigationController?.pushViewController(vc, animated: true)
        //}
    }
    
    func didTapAvatar() {
        showProfileFor(post.userid)
    }
    
    func didTapImageCollectionAt(startIndexPath: NSIndexPath) {
        let urls = post.imageurl
        var URLs = [NSURL]()
        for s in urls {
            URLs.append(NSURL(string:s)!)
        }
        let agrume = Agrume(imageURLs: URLs, startIndex: startIndexPath.item, backgroundBlurStyle: .Dark)
        agrume.title = "查看照片"
        agrume.showFrom(self)

    }
    
    func didTapLikeImageAtIndex(index: Int, isMore: Bool) {
        if !isMore {
            guard index >= 0 && index < post.likeusers.count else {
                return
            }
            showProfileFor(post.likeusers[index])
        }
        else {
            let vc = PostLikeVC()
            vc.postID = post.postid
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapMore() {
        //MARK: -tapMore
        let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
            if index == 0 {
                let alertText = AlertTextView(title: "举报", placeHolder: "犀利的写下你的举报内容吧╮(╯▽╰)╭")
                alertText.showInView(self.navigationController!.view)
            }
            }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["举报"])
        sheet.setButtonTextColor(THEME_COLOR)
        sheet.showInView(navigationController!.view)
        
    }
}

extension PostVC:CommentHeaderViewDelegate {
    func didTapAvatarAtHeader(header: CommentHeaderView) {
        guard header.tag > 0 && header.tag <= comments.count else {
            return
        }
        
        showProfileFor(comments[header.tag-1].userID)
    }
}

extension PostVC:CommentFooterViewDelegate {
    func didTapCommentAtFooterView(footer: CommentFooterView) {
        guard footer.tag > 0 && footer.tag <= comments.count else {
            return
        }
        input.enablePhoto = false
        input.hidden = false
        input.textView.becomeFirstResponder()
        view.addGestureRecognizer(tapGesture)
 
        let id = self.comments[footer.tag-1].id
        input.setDidSendClicked { [weak self](text) -> Void in
            
            if let S = self, t = token {
                request(.POST, REPLY_COMMENT, parameters: ["token":t, "destcommentid":id, "body":text], encoding: .JSON).responseJSON(completionHandler: { (response) -> Void in
                    debugPrint(response)
                    if let d = response.result.value {
                        let json = JSON(d)
                        guard json != .null && json["state"].stringValue == "successful" else {
                            return
                        }
                        S.reloadComment(footer.tag)
                    }
                })
            }
            
            self?.hideInput()
        }

    }
    
    func didTapLikeAtFooterView(footer: CommentFooterView) {
        guard footer.tag > 0 && footer.tag <= comments.count else {
            return
        }
        let data = comments[footer.tag-1]
        if let t = token {
            request(.POST, LIKE_COMMENT, parameters: ["token":t, "commentid":data.id], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    guard json != .null && json["state"] == "successful" else {
                        return
                    }
                    S.reloadComment(footer.tag)
                }
            })
        }
    }
    
    func didTapMoreAtFooterView(footer: CommentFooterView) {
        //MARK: -tapMoreAtFooter
        let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
            if index == 0 {
                let alertText = AlertTextView(title: "举报", placeHolder: "犀利的写下你的举报内容吧╮(╯▽╰)╭")
                alertText.showInView(self.navigationController!.view)
            }

            }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["举报"])
        sheet.setButtonTextColor(THEME_COLOR)
        sheet.showInView(navigationController!.view)
    }
}


extension PostVC: PostCommentTableImageViewCellDelegate {
    func didTapImageCollectionViewAtCell(cell: PostCommentTableImageViewCell, atIndexPath index: NSIndexPath) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let urls = comments[indexPath.section-1].image
            var URLs = [NSURL]()
            for s in urls {
                URLs.append(NSURL(string:s)!)
            }
            let agrume = Agrume(imageURLs: URLs, startIndex: index.item, backgroundBlurStyle: .Dark)
            agrume.title = "查看照片"
            agrume.showFrom(self)
        }
    }
}


class PostImageManager:NSObject {
    static let SIZE = (SCREEN_WIDTH-20-40)/3
    weak var cell:PostArticleTableViewCell?
    private(set) var imageURLs = [String]() {
        didSet {
            cell?.imageCollectionView.reloadData()
            cell?.resizeImageCollectionHeight()
        }
    }

}

class DLCollectionViewFlowLayout:UICollectionViewFlowLayout {
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let arrayAttributes = super.layoutAttributesForElementsInRect(rect) {
            var newAttr = [UICollectionViewLayoutAttributes]()
            for attr in arrayAttributes {
                if attr.frame.origin.x + attr.frame.size.width <= self.collectionViewContentSize().width && attr.frame.origin.y + attr.frame.size.height <= self.collectionViewContentSize().height {
                    newAttr.append(attr)
                }
            }
            return newAttr
        }
        return nil
    }
}

extension PostImageManager:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(TopicImageCollectionViewCell), forIndexPath: indexPath) as! TopicImageCollectionViewCell
        cell.imgView.sd_setImageWithURL(NSURL(string:imageURLs[indexPath.item])!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: PostImageManager.SIZE , height: PostImageManager.SIZE)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cell?.delegate?.didTapImageCollectionAt(indexPath)
    }
    
}

class PostLikeImageManager:NSObject {
    //static let sharedManager = PostLikeImageManager()
   // private var images = [UIImage(named: "dev_liuli")!, UIImage(named: "dev_lilei")!, UIImage(named: "dev_yeqingshi")!, UIImage(named: "dev_songjiaji")!, UIImage(named: "dev_mashenbin")!, UIImage(named: "dev_liuli")!]
    //[UIImage]()
    
    private(set) var likeIDs = [String]() {
        didSet {
            cell?.likeCollectionView.reloadData()
        }
    }
    weak var cell:PostArticleTableViewCell?
    
    static let count = max(1, Int(SCREEN_WIDTH/40)-3)
}

extension PostLikeImageManager:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if likeIDs.count >= PostLikeImageManager.count {
            return PostLikeImageManager.count + 1
        }
        else {
            return likeIDs.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(PostLikeImageCollectionViewCell), forIndexPath: indexPath) as! PostLikeImageCollectionViewCell
        if likeIDs.count >= PostLikeImageManager.count && indexPath.item == PostLikeImageManager.count{
            cell.imgView.image = UIImage(named: "more")
            cell.tag = 1
        }
        else {
            cell.imgView.sd_setImageWithURL(thumbnailAvatarURLForID(likeIDs[indexPath.item]), placeholderImage: UIImage(named: "avatar"))
            cell.tag = 0
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 30 , height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let c = collectionView.cellForItemAtIndexPath(indexPath)!
        cell?.delegate?.didTapLikeImageAtIndex(indexPath.item, isMore:c.tag == 1)
    }
    
}

protocol PostArticleTableViewCellDelegate:class {
    func didTapLike()
    func didTapComment()
    func didTapAvatar()
    func didTapImageCollectionAt(startIndexPath:NSIndexPath)
    func didTapLikeImageAtIndex(index:Int, isMore:Bool)
    func didTapMore()
}

class PostArticleTableViewCell:UITableViewCell{
    var avatar:UIImageView!
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    var timeLabel:UILabel!
    var seperator:UIView!
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    var moreAction:UIImageView!
    
    weak var delegate:PostArticleTableViewCellDelegate?
    
    var imgController:PostImageManager? {
        didSet {
            imgController?.cell = self
            imageCollectionView.dataSource = imgController
            imageCollectionView.delegate = imgController
        }
    }
    
    var imageCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(TopicImageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(TopicImageCollectionViewCell))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        //collectionView.backgroundColor = SECONDAY_COLOR
        return collectionView
    }()
    
    func resizeImageCollectionHeight() {
        if let count = imgController?.imageURLs.count {
            let row = CGFloat((count + 2)/3)
            imageCollectionView.snp_updateConstraints { (make) -> Void in
                //print(row*PostImageManager.SIZE+10*(row+1))
                make.height.greaterThanOrEqualTo(row*PostImageManager.SIZE+5*(row+1))
            }
        }
    }
    
    var likeController:PostLikeImageManager? {
        didSet {
            likeController?.cell =  self
            likeCollectionView.dataSource = likeController
            likeCollectionView.delegate = likeController
        }
    }
    
    var likeCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(PostLikeImageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PostLikeImageCollectionViewCell))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var like:UIView!
    var comment:UIView!
    var likeImage:UIImageView!
    var commentImage:UIImageView!
    var commentLabel:UILabel!
    var likeLabel:UILabel!
    
    
    func initialize() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 16
        avatar.layer.masksToBounds = true
        avatar.userInteractionEnabled = true
        let tapAvatar = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        avatar.addGestureRecognizer(tapAvatar)
        contentView.addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        //nameLabel.backgroundColor = SECONDAY_COLOR
        //nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        nameLabel.font = UIFont.boldSystemFontOfSize(13)
        nameLabel.textColor =  UIColor.darkGrayColor()
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(infoLabel)
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        //infoLabel.backgroundColor = UIColor.yellowColor()
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(timeLabel)
        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        timeLabel.textAlignment = .Right
        //timeLabel.backgroundColor = SECONDAY_COLOR
        
//        seperator = UIView()
//        seperator.backgroundColor = BACK_COLOR
//        seperator.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(seperator)
//        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(bodyLabel)
        bodyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        bodyLabel.textColor = UIColor.darkGrayColor()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageCollectionView)
        
        like = UIView()
        like.translatesAutoresizingMaskIntoConstraints = false
        like.layer.cornerRadius = 2.0
        like.layer.masksToBounds = true
        like.backgroundColor = UIColor.clearColor()//BACK_COLOR//UIColor.colorFromRGB(0xF0F0F0)
        let likeTap = UITapGestureRecognizer(target: self, action: "tapLike:")
        like.addGestureRecognizer(likeTap)
        contentView.addSubview(like)
        
        likeImage = UIImageView()
        like.translatesAutoresizingMaskIntoConstraints = false
        likeImage.image = UIImage(named: "like")?.imageWithRenderingMode(.AlwaysTemplate)
        likeImage.tintColor = UIColor.colorFromRGB(0xFF69B4)
        likeImage.userInteractionEnabled = true
        likeTap.delegate = self
        like.addSubview(likeImage)
        
        likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        likeLabel.textColor = UIColor.lightGrayColor()
        like.addSubview(likeLabel)
        
        comment = UIView()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.layer.cornerRadius = 2.0
        comment.layer.masksToBounds = true
        comment.backgroundColor = UIColor.clearColor()//BACK_COLOR//UIColor.colorFromRGB(0xF0F0F0)
        let commentTap = UITapGestureRecognizer(target: self, action: "tapComment:")
        comment.addGestureRecognizer(commentTap)
        contentView.addSubview(comment)
        
        commentImage = UIImageView()
        commentImage.image = UIImage(named: "comment")?.imageWithRenderingMode(.AlwaysTemplate)
        commentImage.tintColor = UIColor.colorFromRGB(0x32CD32)
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        commentImage.userInteractionEnabled = true
        comment.addSubview(commentImage)
        
        commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        commentLabel.textColor = UIColor.lightGrayColor()
        comment.addSubview(commentLabel)
        
        likeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeCollectionView)
        
        
        moreAction = UIImageView(image: UIImage(named: "more"))
        moreAction.translatesAutoresizingMaskIntoConstraints = true
        moreAction.layer.cornerRadius = 15
        moreAction.userInteractionEnabled = true
        let tapMore = UITapGestureRecognizer(target: self, action: "tapMore:")
        moreAction.addGestureRecognizer(tapMore)
        contentView.addSubview(moreAction)
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_topMargin)
            make.left.equalTo(contentView.snp_leftMargin)
            make.width.height.equalTo(32)
        }
        
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_top)
            make.left.equalTo(avatar.snp_right).offset(5)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel.snp_left)
            make.bottom.equalTo(avatar.snp_bottom)
            make.right.equalTo(timeLabel.snp_left)
            //infoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        }
        
        
        
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(infoLabel.snp_centerY)
            //timeLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
            
        }
        
//        seperator.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(avatar.snp_bottom).offset(5)
//            make.left.equalTo(snp_leftMargin)
//            make.right.equalTo(snp_rightMargin)
//            make.height.equalTo(1)
//        }
//        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(avatar.snp_bottom).offset(10)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        bodyLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(10).priorityLow()
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        imageCollectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bodyLabel.snp_bottom).offset(5)
            make.height.greaterThanOrEqualTo(PostImageManager.SIZE+20)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        moreAction.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.left.equalTo(contentView.snp_leftMargin)
            make.centerY.equalTo(comment.snp_centerY)
        }
        
       comment.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imageCollectionView.snp_bottom).offset(5)
            make.right.equalTo(snp_rightMargin)
            make.bottom.equalTo(commentImage.snp_bottom)
        }
        
        commentLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(comment.snp_rightMargin)
            make.left.equalTo(commentImage.snp_right).offset(2)
            make.centerY.equalTo(commentImage.snp_centerY)
        }
        
        commentImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(comment.snp_leftMargin)
            make.width.equalTo(18)
            make.height.equalTo(17)
            make.centerY.equalTo(comment.snp_centerY)
        }
        
        like.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(comment.snp_top)
            make.right.equalTo(comment.snp_left).offset(-5)
            make.bottom.equalTo(likeImage.snp_bottom)
        }
        
        likeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(like.snp_rightMargin)
            make.left.equalTo(likeImage.snp_right).offset(2)
            make.centerY.equalTo(likeImage.snp_centerY)
        }
        
        likeImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(like.snp_leftMargin)
            make.width.equalTo(18)
            make.height.equalTo(17)
            make.centerY.equalTo(like.snp_centerY)
        }

        likeCollectionView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(comment.snp_bottom).offset(10)
            make.height.greaterThanOrEqualTo(40).priorityLow()
        }
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(likeCollectionView.snp_bottom).offset(0).priorityLow()
        }
    }
    
    func tapLike(sender:AnyObject) {
        delegate?.didTapLike()
    }
    
    func tapComment(sender:AnyObject) {
        delegate?.didTapComment()
    }
    
    func tapAvatar(sender:AnyObject) {
        delegate?.didTapAvatar()
    }
    
    func tapMore(sender:AnyObject) {
        delegate?.didTapMore()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    


}
class PostLikeImageCollectionViewCell: UICollectionViewCell {
    
    let imgView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        //imageView.clipsToBounds = true
        //imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        contentView.addSubview(imgView)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(contentView.snp_top)
            make.left.equalTo(contentView.snp_left)
            make.top.equalTo(contentView.snp_top)
            //            make.width.equalTo(40)
            //            make.height.equalTo(40)
            make.right.equalTo(contentView.snp_right)
            make.bottom.equalTo(contentView.snp_bottom)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
    }
    
    
}

class PostCommentImageCollectionViewCell:TopicImageCollectionViewCell {}


class PostCommentImageController:NSObject, UICollectionViewDataSource, UICollectionViewDelegate{
    private(set) var imageURLs = [String]() {
        didSet {
            cell?.imageCollectionView.reloadData()
        }
    }
    
    static let SIZE = (SCREEN_WIDTH-60)/5
    
    weak var cell:PostCommentTableImageViewCell?
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(PostCommentImageCollectionViewCell), forIndexPath: indexPath) as! PostCommentImageCollectionViewCell
        cell.imgView.sd_setImageWithURL(NSURL(string:imageURLs[indexPath.item]))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: PostCommentImageController.SIZE, height: PostCommentImageController.SIZE)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        cell?.delegate?.didTapImageCollectionViewAtCell(cell!, atIndexPath: indexPath)
    }
    
}

protocol PostCommentTableImageViewCellDelegate:class{
    func didTapImageCollectionViewAtCell(cell:PostCommentTableImageViewCell, atIndexPath: NSIndexPath)
}

class PostCommentTableImageViewCell:UITableViewCell {
    var commentLabel:UILabel!
    weak var delegate:PostCommentTableImageViewCellDelegate?
    
    private var imgController: PostCommentImageController! {
        didSet {
            imgController.cell = self
            imageCollectionView.dataSource = imgController
            imageCollectionView.delegate = imgController
        }
    }

    
    var imageCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(PostCommentImageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PostCommentImageCollectionViewCell.self))
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        commentLabel.textColor = UIColor.darkGrayColor()
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(commentLabel)
        
        contentView.backgroundColor = UIColor.colorFromRGB(0xFAFAFA)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
        commentLabel.snp_makeConstraints(closure: { (make) -> Void in
            //make.top.equalTo(contentView.snp_topMargin)
            make.left.equalTo(contentView.snp_leftMargin).offset(40)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(contentView.snp_topMargin)
        })
        
        imageCollectionView.backgroundColor = UIColor.colorFromRGB(0xFAFAFA)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageCollectionView)
        imageCollectionView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(commentLabel.snp_bottom).offset(5)
            make.height.greaterThanOrEqualTo(PostCommentImageController.SIZE+20).priorityLow()
            make.left.equalTo(contentView.snp_leftMargin).offset(40)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(imageCollectionView.snp_bottom).offset(5)
        }
    }
}

class PostCommmentTableViewCell:UITableViewCell {
    
    var commentLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        commentLabel = UILabel()
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        commentLabel.textColor = UIColor.darkGrayColor()
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(commentLabel)
        
        contentView.backgroundColor = UIColor.colorFromRGB(0xFAFAFA)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
            commentLabel.snp_makeConstraints(closure: { (make) -> Void in
                //make.top.equalTo(contentView.snp_topMargin)
                make.left.equalTo(contentView.snp_leftMargin).offset(40)
                make.right.equalTo(contentView.snp_rightMargin)
                make.centerY.equalTo(contentView.snp_centerY)
            })
            
            contentView.snp_makeConstraints(closure: { (make) -> Void in
                make.bottom.equalTo(commentLabel.snp_bottom).offset(2).priorityLow()
            })
        
    }
}


protocol CommentHeaderViewDelegate:class {
    func didTapAvatarAtHeader(header: CommentHeaderView)
}
class CommentHeaderView:UITableViewHeaderFooterView {
    var avatar:UIImageView!
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    var timeLabel:UILabel!
    weak var delegate:CommentHeaderViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 16
        avatar.layer.masksToBounds = true
        avatar.userInteractionEnabled = true
        let tapAvatar = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        avatar.addGestureRecognizer(tapAvatar)
        contentView.addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        //nameLabel.backgroundColor = SECONDAY_COLOR
        //nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        nameLabel.font = UIFont.boldSystemFontOfSize(13)
        nameLabel.textColor =  UIColor.darkGrayColor()
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(infoLabel)
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        //infoLabel.backgroundColor = UIColor.yellowColor()
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(timeLabel)
        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        timeLabel.textAlignment = .Right
        
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_topMargin)
            make.left.equalTo(contentView.snp_leftMargin)
            make.width.height.equalTo(32)
        }
        
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_top)
            make.left.equalTo(avatar.snp_right).offset(5)
            make.right.equalTo(contentView.snp_rightMargin).priorityLow()
        }
        
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel.snp_left)
            make.bottom.equalTo(avatar.snp_bottom)
            make.right.equalTo(timeLabel.snp_left).priorityLow()
            //infoLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Horizontal)
        }
        
        
        
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contentView.snp_rightMargin)
            make.centerY.equalTo(infoLabel.snp_centerY)
            //timeLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
            
        }
        

       contentView.backgroundColor = UIColor.colorFromRGB(0xFAFAFA)
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(avatar.snp_bottom).offset(5).priorityLow()
        }
        
       
    }
    
    func tapAvatar(sender:AnyObject) {
        delegate?.didTapAvatarAtHeader(self)
    }
}

protocol CommentFooterViewDelegate:class {
    func didTapCommentAtFooterView(footer:CommentFooterView)
    func didTapLikeAtFooterView(footer:CommentFooterView)
    func didTapMoreAtFooterView(footer:CommentFooterView)
}

class CommentFooterView:UITableViewHeaderFooterView {
    var like:UIView!
    var comment:UIView!
    var likeImage:UIImageView!
    var commentImage:UIImageView!
    var commentLabel:UILabel!
    var likeLabel:UILabel!
    var seperator:UIView!
    var moreAction:UIImageView!
    
    weak var delegate:CommentFooterViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        
        like = UIView()
        like.translatesAutoresizingMaskIntoConstraints = false
        like.backgroundColor = UIColor.clearColor()
        let likeTap = UITapGestureRecognizer(target: self, action: "tapLike:")
        like.addGestureRecognizer(likeTap)
        contentView.addSubview(like)
        
        likeImage = UIImageView()
        like.translatesAutoresizingMaskIntoConstraints = false
        likeImage.image = UIImage(named: "like")?.imageWithRenderingMode(.AlwaysTemplate)
        likeImage.tintColor = UIColor.colorFromRGB(0xFF69B4)
        like.addSubview(likeImage)
        
        likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        likeLabel.textColor = UIColor.lightGrayColor()
        like.addSubview(likeLabel)
        
        comment = UIView()
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.backgroundColor = UIColor.clearColor()
        let commentTap = UITapGestureRecognizer(target: self, action: "tapComment:")
        comment.addGestureRecognizer(commentTap)
        contentView.addSubview(comment)
        
        commentImage = UIImageView()
        commentImage.image = UIImage(named: "comment")?.imageWithRenderingMode(.AlwaysTemplate)
        commentImage.tintColor = UIColor.colorFromRGB(0x32CD32)
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        comment.addSubview(commentImage)
        
        commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        commentLabel.textColor = UIColor.lightGrayColor()
        comment.addSubview(commentLabel)
        
        seperator = UIView()
        seperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(seperator)
        seperator.backgroundColor = UIColor.colorFromRGB(0xF1F1F1)
        
        moreAction = UIImageView(image: UIImage(named: "more"))
        moreAction.translatesAutoresizingMaskIntoConstraints = true
        moreAction.layer.cornerRadius = 15
        moreAction.userInteractionEnabled = true
        let tapMore = UITapGestureRecognizer(target: self, action: "tapMore:")
        moreAction.addGestureRecognizer(tapMore)
        contentView.addSubview(moreAction)
        


        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        
        moreAction.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.left.equalTo(contentView.snp_leftMargin)
            make.centerY.equalTo(comment.snp_centerY)
        }

        
        comment.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(5)
            make.right.equalTo(snp_rightMargin)
            make.height.equalTo(20)
            
        }
        
        commentLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(comment.snp_right).offset(-2)
            make.left.equalTo(commentImage.snp_right).offset(2)
            make.centerY.equalTo(commentImage.snp_centerY)
        }
        
        commentImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(comment.snp_left).offset(2)
            
            //make.width.height.equalTo(15)
            make.width.equalTo(18)
            make.height.equalTo(17)
            //make.top.equalTo(comment.snp_top)
           // make.bottom.equalTo(comment.snp_bottom)
            make.centerY.equalTo(comment.snp_centerY)
        }
        
        like.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(comment.snp_top)
            make.right.equalTo(comment.snp_left).offset(-5)
            make.height.equalTo(20)
        }
        
        
        likeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(like.snp_right).offset(-2)
            make.left.equalTo(likeImage.snp_right).offset(2)
            make.centerY.equalTo(likeImage.snp_centerY)
        }
        
        likeImage.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(like.snp_left).offset(2)
            make.width.equalTo(18)
            make.height.equalTo(17)
            make.centerY.equalTo(like.snp_centerY)
           // make.top.equalTo(like.snp_top)
            //make.bottom.equalTo(like.snp_bottom)
        }
        
        seperator.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(comment.snp_bottom).offset(4)
            make.height.equalTo(1)
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
        }
        
       contentView.backgroundColor = UIColor.colorFromRGB(0xFAFAFA)
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(comment.snp_bottom).offset(1).priorityLow()
        }


    }
    
    func tapLike(sender:AnyObject) {
        delegate?.didTapLikeAtFooterView(self)
    }
    
    func tapComment(sender:AnyObject) {
        delegate?.didTapCommentAtFooterView(self)
    }
    
    func tapMore(sender:AnyObject) {
        delegate?.didTapMoreAtFooterView(self)
    }
}
