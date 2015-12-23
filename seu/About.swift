//
//  About.swift
//  WE
//
//  Created by liewli on 12/23/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class AboutUSVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var tableView:UITableView!
    private let name_arr = ["李磊", "叶庆仕", "刘历", "宋嘉冀", "刘继龙", "叶枝", "卢硕","王阳","马申斌","董嘉"]
    private let info_arr = ["产品经理", "后端开发工程师", "iOS开发工程师","Android开发工程师","Android开发工程师","UI设计师", "交互设计师","Web前端工程师","产品推广经理","产品运营经理"]
    private let img_arr = ["ll", "yqs", "liewli", "sjj", "ljl", "yz", "ls", "wy", "msb", "dj"]
    
    private let id_arr = ["140", "72", "37", "49", "877", "887", "889", "958", "156", "914"]
    
    private var initialTransform:CGAffineTransform!
    
    private var shownIndexPaths = Set<NSIndexPath>()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title = "关于\(APP)"
        automaticallyAdjustsScrollViewInsets = false
        let backView = UIImageView(image: UIImage(named: "food"))
        backView.frame = view.frame
        view.addSubview(backView)
        
//        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongVerticalAxis)
//        verticalMotionEffect.minimumRelativeValue = -50
//        verticalMotionEffect.maximumRelativeValue = 50
//        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongHorizontalAxis)
//        horizontalMotionEffect.minimumRelativeValue = -50
//        horizontalMotionEffect.maximumRelativeValue = 50
//        
//        let group = UIMotionEffectGroup()
//        group.motionEffects = [verticalMotionEffect, horizontalMotionEffect]
//        
//        backView.addMotionEffect(group)
        
        let blurEffect = UIBlurEffect(style: .Light)
        let visualView = UIVisualEffectView(effect: blurEffect)
        visualView.frame = view.frame
        view.addSubview(visualView)
        view.backgroundColor = UIColor.whiteColor()
        tableView = UITableView(frame: view.frame)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        tableView.registerClass(AboutUSTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(AboutUSTableViewCell))
        initialTransform = CGAffineTransformMakeScale(0, 0)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name_arr.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(AboutUSTableViewCell), forIndexPath: indexPath) as! AboutUSTableViewCell
        cell.avatar.image = UIImage(named: img_arr[indexPath.row])
        cell.nameLabel.text = name_arr[indexPath.row]
        cell.infoLabel.text = info_arr[indexPath.row]
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        //cell.backView.image = UIImage(named: "dev_liuli")?.crop(cell.bounds)
        cell.selectionStyle = .None
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let messageAction = UITableViewRowAction(style:.Default, title: "私信") { (action, indexPath) -> Void in
            let id = self.id_arr[indexPath.row]
            let vc = ComposeMessageVC()
            vc.recvID = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let infoAction = UITableViewRowAction(style: .Default, title: "了解更多") { (action, indexPath) -> Void in
            let id = self.id_arr[indexPath.row]
            let vc = MeInfoVC()
            vc.id = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        messageAction.backgroundColor = UIColor.clearColor()
        infoAction.backgroundColor = UIColor.clearColor()
        return [messageAction, infoAction]
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !shownIndexPaths.contains(indexPath) {
            shownIndexPaths.insert(indexPath)
            if let c = cell as? AboutUSTableViewCell {
                c.avatar.transform = initialTransform
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    c.avatar.transform = CGAffineTransformIdentity
                })
            }
        }
      
    }

}

extension AboutUSVC:AboutUSTableViewCellDelegate {
    func didTapAvatarAt(cell: AboutUSTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let avatar = img_arr[indexPath.row]
            let agrume = Agrume(image: UIImage(named: avatar)!)
            agrume.showFrom(self)
        }
    }
}


protocol AboutUSTableViewCellDelegate:class {
    func didTapAvatarAt(cell:AboutUSTableViewCell)
}

class AboutUSTableViewCell : UITableViewCell {
    
    private var avatar:UIImageView!
    private var nameLabel:UILabel!
    private var infoLabel:UILabel!
    weak var delegate:AboutUSTableViewCellDelegate?
    func initialize() {
        backgroundColor = UIColor.clearColor()

    
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 60
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor.whiteColor().CGColor
        avatar.layer.borderWidth = 2
        avatar.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        avatar.addGestureRecognizer(tap)
        contentView.addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        nameLabel.textAlignment = .Center
        contentView.addSubview(nameLabel)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        infoLabel.textAlignment = .Center
        contentView.addSubview(infoLabel)
        
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_leftMargin)
            make.centerY.equalTo(contentView.snp_centerY)
            make.width.height.equalTo(120)
        }
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.top.equalTo(avatar.snp_top).offset(20)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(avatar.snp_right).offset(10)
            make.bottom.equalTo(avatar.snp_bottom).offset(-20)
            make.right.equalTo(contentView.snp_rightMargin)
        }
        
    }
    
    func tap(sender:AnyObject) {
        delegate?.didTapAvatarAt(self)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}
