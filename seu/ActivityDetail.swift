//
//  ActivityDetail.swift
//  WE
//
//  Created by liewli on 12/27/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class ActivityDetailVC:UIViewController {
    
    private var poster:UIImageView!
    private var detailLabel:UILabel!
    private var numberLabel:UILabel!
    private var timeLabel:UILabel!
    private var locationLabel:UILabel!
    private var remarkLabel:UILabel!
    private var registerButton:UIButton!
    private var likeButton:UIButton!
    
    private var _view :UIScrollView!
    private var contentView :UIView!
    
    private var visualView:UIVisualEffectView!
    
    var activityID:String!
    private var activity:ActivityModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        automaticallyAdjustsScrollViewInsets = false
        setupUI()
        fetchActivityInfo()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    func setupUI() {
        setupScrollView()
        
        poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(poster)
        
        detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.numberOfLines = 0
        detailLabel.lineBreakMode = .ByWordWrapping
        detailLabel.textColor = UIColor.darkGrayColor()
        contentView.addSubview(detailLabel)
        
        numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = UIColor.darkGrayColor()
        contentView.addSubview(numberLabel)
        
        timeLabel = UILabel()
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.numberOfLines = 0
        timeLabel.lineBreakMode = .ByWordWrapping
        timeLabel.textColor = UIColor.darkGrayColor()
        contentView.addSubview(timeLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .ByWordWrapping
        locationLabel.textColor = UIColor.darkGrayColor()
        contentView.addSubview(locationLabel)
        
        remarkLabel = UILabel()
        remarkLabel.translatesAutoresizingMaskIntoConstraints = false
        remarkLabel.numberOfLines = 0
        remarkLabel.lineBreakMode = .ByWordWrapping
        remarkLabel.textColor = UIColor.darkGrayColor()
        contentView.addSubview(remarkLabel)
        
        registerButton = UIButton()
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("我要报名", forState: .Normal)
        registerButton.addTarget(self, action: "register:", forControlEvents: .TouchUpInside)
        registerButton.backgroundColor = THEME_COLOR
        registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton.layer.cornerRadius = 4.0
        registerButton.layer.masksToBounds = true
        contentView.addSubview(registerButton)
        
        likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitle("关注一下", forState: .Normal)
        likeButton.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        likeButton.setTitleColor(THEME_COLOR, forState: .Normal)
        likeButton.layer.borderColor = THEME_COLOR.CGColor
        likeButton.layer.borderWidth = 2.0
        likeButton.layer.cornerRadius = 4.0
        likeButton.layer.masksToBounds = true
        contentView.addSubview(likeButton)
        
        poster.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_top)
            make.height.equalTo(poster.snp_width).multipliedBy(0.5)
        }
        
        detailLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(poster.snp_bottom).offset(20)
        }
        
        numberLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(detailLabel.snp_bottom).offset(20)
        }
        
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(numberLabel.snp_bottom).offset(10)
        }
        
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(timeLabel.snp_bottom).offset(10)
        }
        
        remarkLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.right.equalTo(contentView.snp_rightMargin)
            make.top.equalTo(locationLabel.snp_bottom).offset(10)
        }
        
        registerButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.top.equalTo(remarkLabel.snp_bottom).offset(20)
        }
        
        likeButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(registerButton.snp_centerY)
            make.left.equalTo(registerButton.snp_right).offset(10)
            make.right.equalTo(contentView.snp_rightMargin)
            make.width.equalTo(registerButton.snp_width)
        }
        
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(likeButton.snp_bottom).offset(10).priorityLow()
        }
    }
    
    func register(sender:AnyObject) {
        if let t = token {
            request(.POST, SIGNUP_ACTIVITY_URL, parameters: ["token":t, "activity":activityID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    
                }
            })
        }
    }
    
    func like(sender:AnyObject) {
        if let t = token {
            request(.POST, LIKE_ACTIVITY_URL, parameters: ["token":t, "activityid":activityID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    
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
        
        _view.layoutIfNeeded()
        
    }

    
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
        contentView.backgroundColor = UIColor.whiteColor()
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
    func configUI() {
        if let a = activity {
            title = a.title
            poster.image = UIImage(named: "test")
            let attributedDetail = NSMutableAttributedString(string: "\(a.detail)")
            //attributedDetail.addAttributes([NSForegroundColorAttributeName:THEME_COLOR], range: NSMakeRange(0, 4))
            detailLabel.attributedText = attributedDetail
            let attributedCapacity = NSMutableAttributedString(string: "人数\t\(a.capacity)")
            attributedCapacity.addAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], range: NSMakeRange(0, 2))
            numberLabel.attributedText = attributedCapacity
            let attributedTime = NSMutableAttributedString(string: "时间\t\(a.time)")
            attributedTime.addAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], range: NSMakeRange(0, 2))
            timeLabel.attributedText = attributedTime
            let attributedLocation = NSMutableAttributedString(string: "地点\t\(a.location)")
            attributedLocation.addAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], range: NSMakeRange(0, 2))
            locationLabel.attributedText = attributedLocation
            let attributedRemark = NSMutableAttributedString(string: "备注\t\(a.remark)")
            attributedRemark.addAttributes([NSForegroundColorAttributeName:THEME_COLOR_BACK], range: NSMakeRange(0, 2))
            remarkLabel.attributedText = attributedRemark
            registerButton.setTitle("我要报名[\(a.signnumber)]", forState: .Normal)
            if a.state {
                registerButton.backgroundColor = THEME_COLOR_BACK
                registerButton.setTitle("已经报名[\(a.signnumber)]", forState: .Normal)
            }
            if a.likeFlag {
                likeButton.setTitle("已关注", forState: .Normal)
                likeButton.setTitleColor(THEME_COLOR_BACK, forState: .Normal)
                likeButton.layer.borderColor = THEME_COLOR_BACK.CGColor
            }
        }
    }
    
    func fetchActivityInfo() {
        if let t = token {
            request(.POST, GET_ACTIVITY_DETAIL_URL, parameters: ["token":t, "activityid":activityID], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self  {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" && json["result"] != .null else {
                        return
                    }
                    
                    do {
                        S.activity = try MTLJSONAdapter.modelOfClass(ActivityModel.self, fromJSONDictionary: json["result"].dictionaryObject) as? ActivityModel
                        S.configUI()
                    }
                    catch let error as NSError{
                        print(error.localizedDescription)
                    }
                }
            })
        }
    }
}
