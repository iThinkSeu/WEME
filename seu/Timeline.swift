//
//  Timeline.swift
//  WE
//
//  Created by liewli on 12/17/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class TimelineTableViewCell:UITableViewCell {
    var infoLabel:UILabel!
    var moreAction:UIImageView!
    var thumbnail:UIImageView!
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    
    func initialize() {
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        contentView.addSubview(infoLabel)
        
        moreAction = UIImageView(image: UIImage(named: "more"))
        moreAction.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moreAction)
        
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
        
        moreAction.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(24)
            make.right.equalTo(contentView.snp_rightMargin)
            make.left.equalTo(infoLabel.snp_right)
            make.centerY.equalTo(infoLabel.snp_centerY)
        }
        
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

class TimelineVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView:UITableView!
    
    private var events = [TimelineModel]()
    private var currentPage = 1
    var userid:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.frame)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(TimelineTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TimelineTableViewCell))
        fetchEvents()
    }
    
    func fetchEvents() {
        if let t = token{
            request(.POST, GET_USER_TIMELINE, parameters: ["token":t, "userid":userid, "page":"\(currentPage)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null  && json["state"].stringValue == "successful" else {
                        return
                    }
                    do {
                        let events = try MTLJSONAdapter.modelsOfClass(TimelineModel.self, fromJSONArray: json["result"].arrayObject) as! [TimelineModel]
                    
                        if events.count > 0 {
                            S.currentPage++
                            var k = S.events.count
                            let indexSets = NSMutableIndexSet()
                            for _ in events {
                                indexSets.addIndex(k++)
                            }
                            S.events.appendContentsOf(events)
                            S.tableView.insertSections(indexSets, withRowAnimation: .Fade)
                        }
                    }
                    catch let e as NSError {
                        print(e)
                    }
                }
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == events.count-1 {
            fetchEvents()
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        v.backgroundColor = BACK_COLOR
        return v
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = events[indexPath.section]
        let vc = PostVC()
        vc.postID = data.postid
        navigationController?.pushViewController(vc, animated: true)
    }
}
