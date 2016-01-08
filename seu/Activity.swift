//
//  Hand.swift
//  牵手东大
//
//  Created by liewli on 12/2/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class ActivityCell:UITableViewCell {
    var titleLabel:UILabel!
    var timeLabel:UILabel!
    var locationLabel:UILabel!
    var infoLabel:UILabel!
    var hostIcon:UIImageView!
    var locationIcon:UIImageView!
    var timeIcon:UIImageView!
    var statusLabel:UILabel!
//    var remarkIcon:UIImageView!
//    var remarkLabel:UILabel!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    func initialize() {
        backgroundColor = BACK_COLOR
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left).offset(10)
            make.right.equalTo(snp_right).offset(-10)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.textColor = UIColor(red: 81/255.0, green: 87/255.0, blue: 113/255.0, alpha: 1.0)//UIColor.colorFromRGB(0x6A5ACD)
        
        statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusLabel)
        statusLabel.textColor = THEME_COLOR
        statusLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints  = false
        infoLabel.backgroundColor = THEME_COLOR_BACK//UIColor(red: 197/255.0, green: 197/255.0, blue: 218/255.0, alpha: 1.0)
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.layer.cornerRadius = 4
        infoLabel.layer.masksToBounds = true
        infoLabel.textAlignment = .Center
        contentView.addSubview(infoLabel)
        //infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        contentView.addSubview(timeLabel)
        //timeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.textColor = UIColor.lightGrayColor()
        locationLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        contentView.addSubview(locationLabel)
        //locationLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        
        hostIcon = UIImageView()
        hostIcon.translatesAutoresizingMaskIntoConstraints = false
        hostIcon.layer.cornerRadius = 20
        hostIcon.layer.masksToBounds = true
        contentView.addSubview(hostIcon)
        
        timeIcon = UIImageView(image: UIImage(named: "time")?.imageWithRenderingMode(.AlwaysTemplate))
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        timeIcon.tintColor = THEME_COLOR_BACK
        contentView.addSubview(timeIcon)
        
        locationIcon = UIImageView(image: UIImage(named: "location")?.imageWithRenderingMode(.AlwaysTemplate))
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.tintColor = THEME_COLOR_BACK
        contentView.addSubview(locationIcon)
        
//        remarkIcon = UIImageView(image: UIImage(named: "remark")?.imageWithRenderingMode(.AlwaysTemplate))
//        remarkIcon.translatesAutoresizingMaskIntoConstraints = false
//        remarkIcon.tintColor = THEME_COLOR_BACK
//        contentView.addSubview(remarkIcon)

        
//        remarkLabel = UILabel()
//        remarkLabel.translatesAutoresizingMaskIntoConstraints = false
//        remarkLabel.textColor = UIColor.lightGrayColor()
//        remarkLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
//        contentView.addSubview(remarkLabel)
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(hostIcon.snp_right).offset(10)
            make.top.equalTo(contentView.snp_topMargin)
            titleLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: UILayoutConstraintAxis.Horizontal)
            titleLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        }
        
        statusLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(contentView.snp_right).offset(-5)
            make.left.equalTo(titleLabel.snp_right)
            make.centerY.equalTo(titleLabel.snp_centerY)
            statusLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
            statusLabel.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        }
        
        timeIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(hostIcon.snp_right).offset(10)
            make.centerY.equalTo(timeLabel.snp_centerY)
            make.width.height.equalTo(20)
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
        }
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(timeIcon.snp_right).offset(10)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        locationIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(hostIcon.snp_right).offset(10)
            make.centerY.equalTo(locationLabel.snp_centerY)
            make.width.height.equalTo(20)
            make.top.equalTo(timeIcon.snp_bottom).offset(10)
        }

        locationLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(locationIcon.snp_right).offset(10)
            make.right.equalTo(contentView.snp_rightMargin)
            
        }
        
//        remarkIcon.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(hostIcon.snp_right).offset(10)
//            make.centerY.equalTo(remarkLabel.snp_centerY)
//            make.width.height.equalTo(20)
//        }
//        
//        remarkLabel.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(remarkIcon.snp_right).offset(10)
//            make.right.equalTo(contentView.snp_rightMargin)
//            make.top.equalTo(locationLabel.snp_bottom).offset(10)
//        }

        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(hostIcon.snp_centerX)
            make.top.equalTo(hostIcon.snp_bottom).offset(10)
            make.width.greaterThanOrEqualTo(30)
            
        }
        
        hostIcon.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp_top)
            //make.top.equalTo(titleLabel.snp_top)
            //make.left.equalTo(infoLabel.snp_right)
            make.left.equalTo(contentView.snp_left).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
    }
}

class ActivityVC:UIViewController, UITableViewDataSource, UITableViewDelegate, ActivitySearchVCDelegate{
    static let BOARD_SCROLLVIEW_HEIGHT:CGFloat = (SCREEN_WIDTH)/2
    
    var tableView:UITableView!
    
    var boardScrollView:UIScrollView!
    let pageControl = UIPageControl()
    
    var boardBackView:UIView!
    
    var refreshControl:UIRefreshControl!
    let refreshCustomizeImageView = UIImageView()
    var refreshImgs = [UIImage]()
    var animateTimer:NSTimer!
    var currentIndex = 0
    
    var moreButton:UIBarButtonItem!


    var page = 1
    var activities = [ActivityModel]()
    
    var timer:NSTimer?
    
    var scrolling = false
    
    func moveToNext(sender:AnyObject?) {
        if !scrolling  && pageControl.numberOfPages > 0{
            if pageControl.currentPage == pageControl.numberOfPages - 1 {
                pageControl.currentPage = 0
                let offset_x = CGFloat(pageControl.numberOfPages+1) * boardScrollView.frame.size.width
                self.boardScrollView.scrollRectToVisible(CGRectMake(offset_x, 0, boardScrollView.frame.size.width, boardScrollView.frame.size.height), animated: true)
                pageControl.currentPage = 0
            }
            else {
                pageControl.currentPage = (pageControl.currentPage + 1) % pageControl.numberOfPages
                let offset_x = CGFloat(pageControl.currentPage+1) * boardScrollView.frame.size.width
                boardScrollView.setContentOffset(CGPointMake(offset_x, 0), animated: true)
            }
        }
        
        
        
    }
    
    func fetchActivityInfo() {
        if let t = token {
        request(.POST, GET_ACTIVITY_INFO_URL, parameters: ["token":t, "page":"\(page)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
            debugPrint(response)
            if let S = self, d = response.result.value {
                let json = JSON(d)
                guard json != .null && json["state"] == "successful" && json["result"] != .null else {
                    return
                }
                    
                do {
                   let ac = try MTLJSONAdapter.modelsOfClass(ActivityModel.self, fromJSONArray: json["result"].arrayObject) as? [ActivityModel]
                    if let a = ac where a.count > 0 {
                        var k = S.activities.count
                        let indexSets = NSMutableIndexSet()
                        for _ in a {
                            indexSets.addIndex(k++)
                        }
                        S.activities.appendContentsOf(a)
                        S.tableView.insertSections(indexSets, withRowAnimation: .Fade)
                        S.refreshControl.endRefreshing()
                        S.page++
                    }
                }
                catch let error as NSError {
                    print(error.localizedDescription)
                }

                
            }
        })
        }
    }
    
   
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = false
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "moveToNext:", userInfo: nil, repeats: true)
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = activities[indexPath.section]
        let vc = ActivityInfoVC()//ActivityDetailVC()//ActivityRegisterVC()
        //vc.id = data.activityID
        vc.activityID = data.activityID
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    var boardViewModel:ActivityBoardViewModel? {
        didSet {
            boardViewModel?.boards.observe {
                [weak self] (board_arr) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if board_arr.count > 0 {
                        self?.view.layoutIfNeeded()
                        self?.boardScrollView.contentSize = CGSizeMake((self?.view.frame.width)! * CGFloat(board_arr.count+2), ActivityVC.BOARD_SCROLLVIEW_HEIGHT)
                        
                        var imgView = UIImageView()
                        imgView.sd_setImageWithURL(NSURL(string:board_arr[board_arr.count-1].image)!, placeholderImage: UIImage(named: "profile_background"))
                        imgView.frame = CGRectMake(0, 0, (self?.boardScrollView.frame.width)!, ActivityVC.BOARD_SCROLLVIEW_HEIGHT)
                        self?.boardScrollView.addSubview(imgView)
                        
                        for (index, board) in board_arr.enumerate() {
                            let imgView = UIImageView()
                            imgView.sd_setImageWithURL(NSURL(string:board.image)!, placeholderImage: UIImage(named: "profile_background"))
                            imgView.frame = CGRectMake((self?.boardScrollView.frame.width)! * CGFloat(index+1), 0, (self?.boardScrollView.frame.width)!, ActivityVC.BOARD_SCROLLVIEW_HEIGHT)
                            self?.boardScrollView.addSubview(imgView)
                        }
                    
                        imgView = UIImageView()
                        imgView.sd_setImageWithURL(NSURL(string:board_arr[0].image)!, placeholderImage: UIImage(named: "profile_background"))
                        imgView.frame = CGRectMake((self?.boardScrollView.frame.width)! * CGFloat(board_arr.count+1), 0, (self?.boardScrollView.frame.width)!, ActivityVC.BOARD_SCROLLVIEW_HEIGHT)
                        self?.boardScrollView.addSubview(imgView)
                        
                        
                        self?.boardScrollView.setContentOffset(CGPointMake((self?.boardScrollView.frame.size.width)!, 0), animated: false)
                        self?.pageControl.numberOfPages = board_arr.count
                        self?.pageControl.currentPage = 0
                    }
                    
                })
                
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        // navigationController?.navigationBar.setBackgroundImage(barBG, forBarMetrics: .Default)
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = THEME_COLOR//UIColor.colorFromRGB(0x104E8B)//UIColor.blackColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = .Black

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "活动"
        tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ActivityCell.self, forCellReuseIdentifier: NSStringFromClass(ActivityCell))
        tableView.backgroundColor = BACK_COLOR
        let edgeInsets = UIEdgeInsetsMake(0, 0, tabBarController?.tabBar.frame.size.height ?? 0 , 0)
        tableView.contentInset = edgeInsets
        tableView.scrollIndicatorInsets = edgeInsets
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        navigationController?.navigationBar.barStyle = .Black
        removeNavBorderLine()
        boardViewModel = ActivityBoardViewModel()

        setUI()
        configUI()
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = THEME_COLOR
        refreshControl.tintColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        configRefreshControl()
    }
    
    func removeNavBorderLine() {
        if let nav = navigationController {
            var flag = false
            for v in nav.navigationBar.subviews {
                if !flag {
                    for vv in v.subviews {
                        if vv is UIImageView && vv.frame.size.height < 2 {
                            vv.removeFromSuperview()
                            flag = true
                            break
                        }
                    }
                }
            }
        }
    }

    
    func configRefreshControl() {
        refreshCustomizeImageView.contentMode = .ScaleAspectFill
        refreshCustomizeImageView.backgroundColor = UIColor.clearColor()
        let rect = CGRectMake(refreshControl.center.x-80/2, refreshControl.center.y-80/2, 80, 80)
        refreshCustomizeImageView.frame = rect
        refreshControl.addSubview(refreshCustomizeImageView)
        
    }
    
    func refresh(sender:UIRefreshControl) {
        for k in 1..<110 {
            let imagePath = NSBundle.mainBundle().pathForResource("RefreshContents.bundle/loadding_\(k)", ofType: "png")
            refreshImgs.append(UIImage(contentsOfFile:imagePath!)!)
            
        }
        animateTimer = NSTimer.scheduledTimerWithTimeInterval(0.015, target: self, selector: "tick:", userInfo: nil, repeats: true)
        //animateRefresh()
        activities.removeAll()
        tableView.reloadData()
        page = 1
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.configUI()
        }

        let endTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC))
        dispatch_after(endTime, dispatch_get_main_queue()) { () -> Void in
            self.refreshControl.endRefreshing()
        }
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

    func tapBoard(sender:AnyObject) {
        guard pageControl.currentPage < boardViewModel?.boards.value.count else {
            return
        }
        if let id = boardViewModel?.boards.value[pageControl.currentPage].activityID {
            let vc = ActivityInfoVC()
            vc.activityID = id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    


    
    func setUI() {
        boardScrollView = UIScrollView(frame: CGRectMake(0, 0, SCREEN_WIDTH, ActivityVC.BOARD_SCROLLVIEW_HEIGHT))
        let TapGesture = UITapGestureRecognizer(target: self, action: "tapBoard:")
        boardScrollView.addGestureRecognizer(TapGesture)
        boardScrollView.pagingEnabled = true
        boardScrollView.translatesAutoresizingMaskIntoConstraints = false
        boardScrollView.bounces = false
        boardScrollView.showsHorizontalScrollIndicator = false
        boardScrollView.showsVerticalScrollIndicator = false
        boardScrollView.delegate = self
        boardScrollView.backgroundColor = BACK_COLOR
        //boardScrollView.backgroundColor = UIColor.yellowColor()
       
        boardBackView = UIView(frame: CGRectMake(0, 0, SCREEN_WIDTH, ActivityVC.BOARD_SCROLLVIEW_HEIGHT))
        boardBackView.addSubview(boardScrollView)
        tableView.tableHeaderView?.frame = boardBackView.frame
        tableView.tableHeaderView = boardBackView
    
        
        boardBackView.addSubview(pageControl)
        pageControl.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(boardBackView.snp_width)
            make.height.equalTo(20)
            make.bottom.equalTo(boardBackView.snp_bottom)
            make.centerX.equalTo(boardBackView.snp_centerX)
        }
        
        
        moreButton = UIBarButtonItem(image: UIImage(named: "more"), style: .Plain, target: self, action: "more:")
        navigationItem.rightBarButtonItem = moreButton
        
        navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    func more(sender:AnyObject) {
        let search = UIImage(named: "search")?.imageWithRenderingMode(.AlwaysTemplate)
        let searchItem = KxMenuItem("搜索活动",image: search, target:self, action:"search:")
        searchItem.foreColor = UIColor.whiteColor()
        let more = UIImage(named: "publish")?.imageWithRenderingMode(.AlwaysTemplate)
        let publishItem = KxMenuItem("发布活动",image: more, target:self, action:"editActivity:")
        publishItem.foreColor = UIColor.whiteColor()
        let v = moreButton.valueForKey("view") as! UIView
        let vv = navigationController!.view
        let rect = (navigationController?.navigationBar.convertRect(v.frame, toView: vv))!
        KxMenu.setTintColor(THEME_COLOR)
        KxMenu.setMenuIconTintColor(UIColor.whiteColor())
        KxMenu.showMenuInView(vv, fromRect: rect , menuItems: [searchItem, publishItem])
        
    }
    
    func search(sender:AnyObject) {
        
        let vc = ActivitySearchVC()
        vc.delegate  = self
        navigationController?.pushViewController(vc, animated: false)

    }
    
    func editActivity(sender:AnyObject) {
        let vc = UINavigationController(rootViewController: ActivityEditVC())
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func didSearchText(text: String) {
        print("called")
        let vc = ActivitySearchResultVC()
        vc.searchText = text
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchTopActivity() {
        if let t = token {
            request(.POST, GET_TOP_ACTIVITY_URL, parameters: ["token":t], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    let json  = JSON(d)
                    guard json != .null  && json["state"].stringValue == "successful" && json["result"].array != nil else {
                        return
                    }
                    
                    var top = [ActivityBoard]()
                    for t in json["result"].array! {
                        top.append(ActivityBoard(image: t["imageurl"].stringValue, activityID: t["activityid"].stringValue))
                    }
                    if top.count > 0 {
                        S.boardViewModel?.boards.value = top
                    }
                }
            })
        }
        
    }
    
    func configUI() {
            fetchTopActivity()
            fetchActivityInfo()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activities.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ActivityCell), forIndexPath: indexPath) as! ActivityCell
        let data = activities[indexPath.section]
        cell.titleLabel.text = data.title
        cell.timeLabel.text = data.time
        cell.locationLabel.text = data.location
        cell.infoLabel.text = " \(data.signnumber)/\(data.capacity) "
    
        
        
        cell.hostIcon.sd_setImageWithURL(thumbnailAvatarURLForID(data.authorID), placeholderImage: UIImage(named: "avatar"))
        
       // cell.remarkLabel.text = data.remark.characters.count == 0 ? "(无备注信息)" : data.remark
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        v.backgroundColor = BACK_COLOR
        return v
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: section == 0 ? 10 : 5))
        v.backgroundColor = BACK_COLOR
        return v
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == activities.count - 1 {
            fetchActivityInfo()
        }
    }
    
    
}

extension ActivityVC:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = lroundf(Float(boardScrollView.contentOffset.x / (boardScrollView.frame.size.width)))
        
        if page == 0 {
            self.boardScrollView.scrollRectToVisible(CGRectMake(boardScrollView.frame.size.width * CGFloat(pageControl.numberOfPages), 0, boardScrollView.frame.size.width, boardScrollView.frame.size.height), animated: false)
            pageControl.currentPage = pageControl.numberOfPages-1
        }
        else if page == pageControl.numberOfPages + 1 {
            self.boardScrollView.scrollRectToVisible(CGRectMake(boardScrollView.frame.size.width , 0, boardScrollView.frame.size.width, boardScrollView.frame.size.height), animated: false)
            pageControl.currentPage = 0
        }
        else {
            self.boardScrollView.scrollRectToVisible(CGRectMake(boardScrollView.frame.size.width*CGFloat(page) , 0, boardScrollView.frame.size.width, boardScrollView.frame.size.height), animated: true)
            pageControl.currentPage = page - 1
        }
        
        scrolling = false
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "moveToNext:", userInfo: nil, repeats: true)
        }
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrolling = true
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if boardScrollView.contentOffset.x == boardScrollView.frame.width * CGFloat(pageControl.numberOfPages+1) {
            self.boardScrollView.scrollRectToVisible(CGRectMake(boardScrollView.frame.size.width , 0, boardScrollView.frame.size.width, boardScrollView.frame.size.height), animated: false)
        }
    }
    
}

struct ActivityBoard {
    let image:String
    let activityID:String
}
class ActivityBoardViewModel {
    private var boards:Observable<[ActivityBoard]>  = Observable([])
    
}