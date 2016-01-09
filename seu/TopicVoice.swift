//
//  Voice.swift
//  牵手东大
//
//  Created by liewli on 11/28/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit


class TopicVoiceVC:UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FloatingActionViewDelegate {
    static let TOPIC_IMAGE_WIDTH = SCREEN_WIDTH
    static let TOPIC_IMAGE_HEIGHT = SCREEN_WIDTH * 2/3
    let imgBG = UIImageView(frame: CGRectMake(0, -TopicVC.TOPIC_IMAGE_HEIGHT, TopicVC.TOPIC_IMAGE_WIDTH, TopicVC.TOPIC_IMAGE_HEIGHT))
    
    var initialTransform:CATransform3D!
    
    var visualView:UIVisualEffectView?
    
    var composeAction:FloatingActionView!
    
    var tableView:UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var shownIndexPaths = Set<NSIndexPath>()
    
    let transition = BubbleTransition()
    
    var refreshImgs = [UIImage]()
    
    let sloganLabel = DLLabel()
    
    var currentIndex = 0
    var animateTimer:NSTimer!
    
    var currentPage = 1
    
    var isLoading = false
    
    let refreshCustomizeImageView = UIImageView()
    
    let topicID:String
    
    private let name_arr = ["李磊", "叶庆仕", "刘历", "宋嘉冀", "刘继龙", "叶枝", "卢硕","王阳","马申斌","董嘉"]
    
    private let img_arr = ["ll", "yqs", "liewli", "sjj", "ljl", "yz", "ls", "wy", "msb", "dj"]

    
    var posts = [Post]()
    
    init(topic:String) {
        topicID = topic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
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
        
        let bounds = self.navigationController?.navigationBar.bounds as CGRect!
        let blurEffect = UIBlurEffect(style: .Light)
        visualView = UIVisualEffectView(effect: blurEffect)
        visualView?.frame = CGRectMake(0, bounds.height - 64, SCREEN_WIDTH, 64)
        visualView?.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        visualView?.userInteractionEnabled = false
        navigationController?.navigationBar.insertSubview(visualView!, atIndex: 0)
        //visualView?.hidden = true
        print(tableView.contentOffset.y)
        if tableView.contentOffset.y <= -TopicVC.TOPIC_IMAGE_HEIGHT {
            hiddenVisualView()
        }
        else {
            showVisualView()
        }
        
    }
    
    
   
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        visualView?.removeFromSuperview()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1//posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TopicVoiceTableViewCell), forIndexPath: indexPath) as! TopicVoiceTableViewCell
        cell.avatar.image = UIImage(named: img_arr[indexPath.section % img_arr.count])
        cell.bodyLabel.text = "说出你的故事..."
        cell.nameLabel.text = name_arr[indexPath.section % name_arr.count]
        cell.infoLabel.text = "东南大学"
        cell.timeLabel.text = "1分钟前"
        let attributedText = NSMutableAttributedString(string: "\(rand() % 10) 个点赞・\(rand() % 10) 条评论")
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromRGB(0xFF69B4) , range: NSMakeRange(0, 1))
        attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromRGB(0x32CD32), range: NSMakeRange(1+5, 1))
        cell.topicInfoLabel.attributedText = attributedText
        //cell.voiceMediaView.image = UIImage(named: "dev_liuli")
        let filePath = NSBundle.mainBundle().pathForResource("JSQMessagesAssets.bundle\\Sounds\\message_sent", ofType: "aiff")
        let voiceItem = JSQVoiceAudioMediaItem(image: UIImage(named: "voice_send_normal")!, withFilePath: filePath, isOutgoing: false)
        let mediaView = voiceItem.mediaView()
        mediaView.frame = CGRectMake(0, 0, voiceItem.mediaViewDisplaySize().width, voiceItem.mediaViewDisplaySize().height)
        cell.voiceMediaView.addSubview(mediaView)
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc = PostVC()
//        let data = posts[indexPath.row]
//        vc.postID = data.postid
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "话题"
        automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        
        
        //navigationController?.navigationBar.tintColor = UIColor.clearColor()
        tableView.backgroundColor = BACK_COLOR
        tableView.contentInset = UIEdgeInsetsMake(TopicVC.TOPIC_IMAGE_HEIGHT, 0, 0, 0)
        imgBG.image = UIImage(named: "test")
        tableView.addSubview(imgBG)
        
        tableView.registerClass(TopicVoiceTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TopicVoiceTableViewCell))
        //tableView.rowHeight = UITableViewAutomaticDimension
        // tableView.estimatedRowHeight = 260
        
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        sloganLabel.numberOfLines = 0
        sloganLabel.lineBreakMode = .ByWordWrapping
        sloganLabel.textColor = UIColor.whiteColor()
        sloganLabel.textAlignment = .Center
        sloganLabel.font = UIFont.systemFontOfSize(16)
        imgBG.addSubview(sloganLabel)
        
        sloganLabel.text = "大声说出你的心声"
        //sloganLabel.layer.appendShadow()
       
        sloganLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(imgBG.snp_left)
            make.right.equalTo(imgBG.snp_right)
            make.bottom.equalTo(imgBG.snp_bottom).offset(-20)
        }
        
        
        let rotationRadian = CGFloat((0)*(M_PI/180))
        let offset = CGPoint(x: -40, y: 140)
        initialTransform = CATransform3DIdentity
        initialTransform = CATransform3DConcat(initialTransform, CATransform3DMakeRotation(rotationRadian, 0, 0, 1))
        initialTransform = CATransform3DTranslate(initialTransform, offset.x, offset.y, 0)
        
        
        composeAction = FloatingActionView(center: CGPointMake(view.frame.size.width-40, view.frame.size.height-60), radius: 30, color: THEME_COLOR, icon: UIImage(named: "audio")!, scrollview:tableView)
        composeAction.hideWhileScrolling = true
        composeAction.delegate = self
        view.addSubview(composeAction)
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        loadRefreshContents()
        
       // configUI()
        
    }
    
   /* func fetchTopicInfo() {
        if let t = token {
            request(.POST, GET_TOPIC_SLOGAN, parameters: ["token":t, "topicid":topicID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, let d = response.result.value  {
                    let json = JSON(d)
                    if json["state"] == "successful" {
                        guard json != .null && json["result"] != .null && json["result"]["imageurl"] != .null  else {
                            return
                        }
                        S.imgBG.sd_setImageWithURL(NSURL(string:json["result"]["imageurl"].stringValue)!, placeholderImage: UIImage(named: "test"))
                        S.sloganLabel.text = json["result"]["slogan"].stringValue
                    }
                }
                
                })
        }
    }*/
    
    /*func fetchTopicPostsAtPage(page:Int) {
        if let t = token {
            isLoading = true
            request(.POST, GET_POST_LIST, parameters: ["token":t, "page":"\(page)", "topicid":topicID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let S = self, d = response.result.value {
                    let json = JSON(d)
                    if json["state"].stringValue == "successful" {
                        guard let arr = json["result"].array where arr.count > 0 else {
                            return
                        }
                        
                        var post_arr = [Post]()
                        var k = S.posts.count
                        var indexPaths = [NSIndexPath]()
                        for a in arr  {
                            guard a["postid"] != .null && a["userid"] != .null else {
                                continue
                            }
                            
                            post_arr.append(Post(postid: a["postid"].stringValue, userid: a["userid"].stringValue, name: a["name"].stringValue, school: a["school"].stringValue, gender: a["gender"].stringValue, timestamp: a["timestamp"].stringValue, title: a["title"].stringValue, body: a["body"].stringValue, likenumber: a["likenumber"].stringValue, commentnumber: a["commentnumber"].stringValue, imageurl: (a["imageurl"].arrayObject as! [String]),thumbnail:(a["thumbnail"].arrayObject as! [String])))
                            indexPaths.append(NSIndexPath(forRow: k++, inSection: 0))
                        }
                        
                        if post_arr.count > 0 && post_arr.count == indexPaths.count{
                            print("load \(post_arr.count) rows")
                            S.currentPage++
                            S.posts.appendContentsOf(post_arr)
                            S.tableView.beginUpdates()
                            //let offset = S.tableView.contentOffset
                            S.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                            //S.tableView.contentOffset = offset
                            S.tableView.endUpdates()
                        }
                        
                    }
                    S.isLoading = false
                }
                })
        }
    }*/
    
    /*func configUI() {
        fetchTopicInfo()
        fetchTopicPostsAtPage(currentPage)
    }*/
    
   /* func reload() {
        posts.removeAll()
        self.tableView.reloadData()
        self.currentPage = 1
        fetchTopicPostsAtPage(self.currentPage)
    }*/
    
    func refresh(sender:UIRefreshControl) {
        // print("called refresh")
       // reload()
        for k in 1..<110 {
            //refreshImgs.append(UIImage(named: "RefreshContents.bundle/loadding_\(k)")!)
            //refreshImgs.append(UIImage(contentsOfFile: "RefreshContents.bundle/loadding_\(k)")!)
            let imagePath = NSBundle.mainBundle().pathForResource("RefreshContents.bundle/loadding_\(k)", ofType: "png")
            refreshImgs.append(UIImage(contentsOfFile:imagePath!)!)
            
        }
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.015, target: self, selector: "tick:", userInfo: nil, repeats: true)
        //animateRefresh()
        let endTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC))
        dispatch_after(endTime, dispatch_get_main_queue()) { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadRefreshContents() {
        refreshCustomizeImageView.contentMode = .ScaleAspectFill
        let rect = CGRectMake(refreshControl.center.x-80/2, refreshControl.center.y-80/2-TopicVC.TOPIC_IMAGE_HEIGHT/2, 80, 80)
        refreshCustomizeImageView.frame = rect
        refreshControl.addSubview(refreshCustomizeImageView)
        
    }
    
    func tick(sender:AnyObject) {
        // print("called tick")
        self.refreshCustomizeImageView.image = self.refreshImgs[self.currentIndex]
        self.currentIndex++
        if self.refreshControl.refreshing {
            if self.currentIndex >= self.refreshImgs.count {
                self.currentIndex = 0
            }
        }
        else {
            resetAnimateRefresh()
        }
    }
    
    
    
    func resetAnimateRefresh() {
        self.currentIndex = 0
        refreshCustomizeImageView.image = nil
        animateTimer.invalidate()
        animateTimer = nil
        refreshImgs.removeAll()
    }
    
    func didTapFloatingAction(action: FloatingActionView) {
//        let composeVC = ComposePostVC()
//        composeVC.topicID = topicID
//        let vc = UINavigationController(rootViewController: composeVC)
//        vc.modalPresentationStyle = .Custom
//        vc.transitioningDelegate = self
//        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    deinit {
        //NSNotificationCenter.defaultCenter().removeObserver(self)
        composeAction.hideWhileScrolling  = false
        visualView?.removeFromSuperview()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !shownIndexPaths.contains(indexPath) {
            shownIndexPaths.insert(indexPath)
            
            cell.layer.transform = initialTransform
            
            UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            
        }
        
        if indexPath.row >= posts.count - 5 && !isLoading{
            //print("called load")
            //fetchTopicPostsAtPage(currentPage)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    
    func hiddenVisualView() {
        if let bounds = self.navigationController?.navigationBar.bounds {
            //UIView.animateWithDuration(0.5) { () -> Void in
            self.visualView?.frame = CGRectMake(0, (bounds.height - 64)-64, SCREEN_WIDTH, 64)
        }
        //}
        
    }
    
    func showVisualView() {
        if let bounds = self.navigationController?.navigationBar.bounds {
            //UIView.animateWithDuration(0.5) { () -> Void in
            self.visualView?.frame = CGRectMake(0, (bounds.height - 64), SCREEN_WIDTH, 64)
        }
        // }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        //if !self.showing && !self.hiding {
        //composeAction?.center = CGPointMake(tableView.frame.size.width-40, tableView.frame.size.height-60+yOffset)
        //}
        if yOffset <= -TopicVC.TOPIC_IMAGE_HEIGHT{
            //visualView?.hidden = true
            hiddenVisualView()
            let xOffset = (yOffset + TopicVC.TOPIC_IMAGE_HEIGHT)/2
            var rect = imgBG.frame
            rect.origin.y = yOffset
            rect.size.height = -yOffset
            rect.origin.x = xOffset
            rect.size.width = TopicVC.TOPIC_IMAGE_WIDTH + fabs(xOffset)*2
            imgBG.frame = rect
            let ratio = max(0, min((-yOffset-TopicVC.TOPIC_IMAGE_HEIGHT)/TopicVC.TOPIC_IMAGE_HEIGHT,1.0))
            //sloganLabel.font = UIFont.systemFontOfSize(16 + (24-16)*ratio)
            sloganLabel.transform = CGAffineTransformMakeScale( 1+ratio, 1+ratio)
            // composeAction?.center = CGPointMake(tableView.frame.size.width-40, tableView.frame.size.height-60+yOffset)
        }
            
        else if yOffset <= -64 {
            showVisualView()
            sloganLabel.transform = CGAffineTransformIdentity
            //visualView?.hidden = false
            imgBG.frame = CGRectMake(0, -TopicVC.TOPIC_IMAGE_HEIGHT, TopicVC.TOPIC_IMAGE_WIDTH, TopicVC.TOPIC_IMAGE_HEIGHT)
            // composeAction?.center = CGPointMake(tableView.frame.size.width-40, tableView.frame.size.height-60+yOffset)
            
            
        }
        else {
            showVisualView()
            sloganLabel.transform = CGAffineTransformIdentity
            imgBG.frame = CGRectMake(0, yOffset-(TopicVC.TOPIC_IMAGE_HEIGHT-64), TopicVC.TOPIC_IMAGE_WIDTH, TopicVC.TOPIC_IMAGE_HEIGHT)
            //visualView?.hidden = false
            
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset <= -TopicVC.TOPIC_IMAGE_HEIGHT+10{
            //visualView?.hidden = true
            hiddenVisualView()
        }
        else {
            //visualView?.hidden = false
            showVisualView()
        }
        
        
    }
}

class TopicVoiceTableViewCell:UITableViewCell {
    var avatar:UIImageView!
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    var timeLabel:UILabel!
    var seperator:UIView!
    //var titleLabel:UILabel!
    var voiceMediaView:UIView!
    var bodyLabel:UILabel!
    
    var topicInfoLabel:UILabel!
  
    
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
        //avatar.userInteractionEnabled = true
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
        
        seperator = UIView()
        seperator.backgroundColor = BACK_COLOR
        seperator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(seperator)
        
//        titleLabel = UILabel()
//        titleLabel.numberOfLines = 0
//        titleLabel.lineBreakMode = .ByWordWrapping
//        contentView.addSubview(titleLabel)
//        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 2
        bodyLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(bodyLabel)
        bodyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bodyLabel.textColor = UIColor.darkGrayColor()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        voiceMediaView = UIView()
        voiceMediaView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(voiceMediaView)
        
        topicInfoLabel = UILabel()
        topicInfoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        topicInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topicInfoLabel)
        
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
        
        seperator.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(avatar.snp_bottom).offset(5)
            make.left.equalTo(snp_leftMargin)
            make.right.equalTo(snp_rightMargin)
            make.height.equalTo(1)
        }
        
//        titleLabel.snp_makeConstraints { (make) -> Void in
//            make.top.greaterThanOrEqualTo(seperator.snp_bottom).offset(10)
//            make.left.equalTo(contentView.snp_leftMargin)
//            make.right.equalTo(contentView.snp_rightMargin)
//        }
        
        bodyLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(seperator.snp_bottom).offset(10)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        voiceMediaView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(bodyLabel.snp_bottom).offset(10)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.height.greaterThanOrEqualTo(44).priorityLow()
        }
        
        
        topicInfoLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(voiceMediaView.snp_bottom).offset(10)
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        
        
        //contentView.backgroundColor = BACK_COLOR
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(topicInfoLabel.snp_bottom).offset(20)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension TopicVoiceVC : UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //let bubbleTransition = BubbleTransition()
        transition.transitionMode = .Present
        transition.startingPoint = composeAction.center
        transition.bubbleColor = UIColor.clearColor()//composeAction.color
        return transition
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //let bubbleTransition = BubbleTransition()
        transition.transitionMode = .Dismiss
        transition.startingPoint = composeAction.center
        transition.bubbleColor = UIColor.clearColor()//composeAction.color
        return transition
        
    }
}

