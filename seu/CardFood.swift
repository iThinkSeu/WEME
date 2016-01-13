//
//  CardFood.swift
//  WEME
//
//  Created by liewli on 2016-01-08.
//  Copyright © 2016 li liew. All rights reserved.
//

import UIKit


class CardFoodVC:CardVC {
    override func nextCard() -> CardContentView {
        let card1 = CardFoodContentView(frame: CGRectZero)
        card1.imgView.image = UIImage(named: "food")
        card1.avatar.image = UIImage(named: "dj")
        card1.infoLabel.text = "wanwan 推荐"
        card1.titleLabel.text = "蒜泥蒸大虾"
        card1.detailIcon.image = UIImage(named: "location")
        card1.detailLabel.text = "550 M"
        card1.likeLabel.text = "1010"
        return card1
    }
    
    override func detailViewForCurrentCard() -> CardDetailView? {
        let cardDetail = CardFoodDetailView(frame: CGRectZero)
        cardDetail.imgView.image = UIImage(named: "food")
        cardDetail.locationLabel.text = "晋家门・艾尚天地店"
        cardDetail.infoLabel.text = "人均 70 RMB"
        let text = "“艾尚天地店，环境好，适合聚会。虾很新鲜，味道也比较清淡...”"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(0, 1))
        attributedText.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(text.characters.count-1, 1))
        cardDetail.commentLabel.attributedText = attributedText
        cardDetail.authorLabel.text = "By wanwan"
        return cardDetail
    }
    
    override func tapRight(sender: AnyObject) {
        let sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
            if index == 0 {
                let nav = UINavigationController(rootViewController: CardFoodEditVC())
                //self.navigationController?.pushViewController(nav, animated: true)
                self.presentViewController(nav, animated: true, completion: nil)
            }
         
            }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["编辑一张美食卡片，分享吧"])
        sheet.setButtonTextColor(THEME_COLOR)
        sheet.showInView(navigationController!.view)

    }
}

class CardFoodContentView:CardContentView {
    var avatar:UIImageView!
    var infoLabel:UILabel!
    var titleLabel:UILabel!
    var detailIcon:UIImageView!
    var detailLabel:UILabel!
    var nextIcon:UIButton!
    var gradientLayer:CAGradientLayer!
    var likeButton:UIButton!
    var likeLabel:UILabel!
    
    func initialize() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        backgroundColor = UIColor.whiteColor()
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgView)
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, 100, 100)
        gradientLayer.colors = [UIColor.blackColor().alpha(0.9).CGColor, UIColor.clearColor().CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:0.8)
        layer.addSublayer(gradientLayer)
        
        likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "like")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        likeButton.tintColor = UIColor.whiteColor()
        addSubview(likeButton)
        
        likeLabel = UILabel()
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.textColor = UIColor.whiteColor()
        likeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        addSubview(likeLabel)
        
        likeLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(imgView.snp_bottom).offset(-5)
            make.right.equalTo(imgView.snp_rightMargin)
        }
        
        likeButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(likeLabel.snp_left).offset(-5)
            make.centerY.equalTo(likeLabel.snp_centerY)
            make.width.height.equalTo(14)
        }
        
        avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.cornerRadius = 22
        avatar.layer.masksToBounds = true
        avatar.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5).CGColor
        avatar.layer.borderWidth = 3
        addSubview(avatar)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textAlignment = .Center
        infoLabel.textColor = THEME_COLOR_BACK
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        addSubview(infoLabel)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        titleLabel.textColor = UIColor.colorFromRGB(0x3c404a)
        addSubview(titleLabel)
        
        detailIcon = UIImageView()
        detailIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailIcon)
        
        detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        detailLabel.textColor = THEME_COLOR_BACK
        addSubview(detailLabel)
   
        
        nextIcon = UIButton(type: .System)
        nextIcon.translatesAutoresizingMaskIntoConstraints = false
        // nextIcon.image = UIImage(named: "forward")?.imageWithRenderingMode(.AlwaysTemplate)
        nextIcon.setImage(UIImage(named: "forward")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        nextIcon.tintColor = THEME_COLOR_BACK
        //        nextIcon.userInteractionEnabled = true
        //        let tap = UITapGestureRecognizer(target: self, action: "next:")
        //        nextIcon.addGestureRecognizer(tap)
        nextIcon.addTarget(self, action: "next:", forControlEvents: .TouchUpInside)
        addSubview(nextIcon)
        
        
        imgView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.height.equalTo(imgView.snp_width)
        }
        
        avatar.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(imgView.snp_bottom)
            make.centerX.equalTo(snp_centerX)
            make.width.height.equalTo(44)
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(snp_centerX)
            make.top.equalTo(avatar.snp_bottom)
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
        }
        
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.centerX.equalTo(snp_centerX)
            make.top.equalTo(infoLabel.snp_bottom).offset(5)
        }
        
        detailIcon.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(20)
            make.centerY.equalTo(detailLabel)
            make.right.equalTo(detailLabel.snp_left).offset(-5)
        }
        
        detailLabel.snp_makeConstraints { (make) -> Void in
            //make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.bottom.equalTo(snp_bottom).offset(-20)
            make.centerX.equalTo(snp_centerX).offset(5)
        }
        
        nextIcon.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(snp_rightMargin)
            make.height.width.equalTo(20)
            make.centerY.equalTo(detailLabel.snp_centerY)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.bounds = imgView.bounds
        gradientLayer.position = CGPointMake(CGRectGetMidX(imgView.bounds), CGRectGetMidY(imgView.bounds))
       
    }
    
    func next(sender:AnyObject) {
        delegate?.didTapNext()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
}



class CardFoodDetailView:CardDetailView {
    
    var imgView:UIImageView!
    var locationLabel:UILabel!
    var infoLabel:UILabel!
    var commentLabel:UILabel!
    var authorLabel:UILabel!
    
    func initialize() {
        backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgView)
        
        imgView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(snp_centerX)
            make.top.equalTo(snp_top).offset(10)
            make.width.height.equalTo(snp_width).multipliedBy(0.5)
        }
        
        let locationBack = UIView()
        locationBack.backgroundColor = UIColor.whiteColor()
        locationBack.translatesAutoresizingMaskIntoConstraints = false
        locationBack.layer.cornerRadius = 2.0
        locationBack.layer.masksToBounds = true
        addSubview(locationBack)
        
        locationBack.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_leftMargin)
            make.right.equalTo(snp_rightMargin)
            make.height.equalTo(40)
            make.top.equalTo(imgView.snp_bottom).offset(10)
        }
        
        let locationIcon = UIImageView()
        locationIcon.image = UIImage(named: "location")?.imageWithRenderingMode(.AlwaysTemplate)
        locationIcon.tintColor = UIColor.colorFromRGB(0x9fa0af)
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationBack.addSubview(locationIcon)
        locationIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(locationBack.snp_leftMargin)
            make.centerY.equalTo(locationBack.snp_centerY)
            make.width.height.equalTo(20)
        }
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        locationLabel.textColor = UIColor.colorFromRGB(0x3c404a)
        locationBack.addSubview(locationLabel)
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(locationIcon.snp_right).offset(5)
            make.right.equalTo(locationBack.snp_right)
            make.centerY.equalTo(locationBack.snp_centerY)
        }
        
        let infoBack = UIView()
        infoBack.translatesAutoresizingMaskIntoConstraints = false
        infoBack.backgroundColor = UIColor.whiteColor()
        infoBack.layer.cornerRadius = 2.0
        infoBack.layer.masksToBounds = true
        addSubview(infoBack)
        
        let infoIcon = UIImageView()
        infoIcon.translatesAutoresizingMaskIntoConstraints = false
        infoIcon.image = UIImage(named: "rmb")?.imageWithRenderingMode(.AlwaysTemplate)
        infoIcon.tintColor = UIColor.colorFromRGB(0x9fa0af)
        infoBack.addSubview(infoIcon)
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        infoLabel.textColor = UIColor.colorFromRGB(0x3c404a)
        infoBack.addSubview(infoLabel)
        
        infoBack.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_leftMargin)
            make.right.equalTo(snp_rightMargin)
            make.top.equalTo(locationBack.snp_bottom).offset(5)
            make.height.equalTo(locationBack.snp_height)
        }
        
        infoIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(infoBack.snp_leftMargin)
            make.centerY.equalTo(infoBack.snp_centerY)
            make.width.height.equalTo(16)
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(infoIcon.snp_right).offset(5)
            make.right.equalTo(infoBack.snp_right)
            make.centerY.equalTo(infoBack.snp_centerY)
        }
        
        commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.numberOfLines = 2
        commentLabel.lineBreakMode = .ByWordWrapping
        commentLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        commentLabel.textColor = UIColor.colorFromRGB(0x3c404a)
        commentLabel.textAlignment = .Center
        addSubview(commentLabel)
        commentLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_leftMargin)
            make.right.equalTo(snp_rightMargin)
            make.top.equalTo(infoBack.snp_bottom).offset(10)
        }
        
        //let backIcon = UIImageView(image: UIImage(named: "backward")?.imageWithRenderingMode(.AlwaysTemplate))
        let backIcon = UIButton(type: .System)
        backIcon.setImage( UIImage(named: "backward")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        backIcon.tintColor = THEME_COLOR_BACK
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        //        backIcon.userInteractionEnabled = true
        //        let tap = UITapGestureRecognizer(target: self, action: "back:")
        //        backIcon.addGestureRecognizer(tap)
        backIcon.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(backIcon)
        
        authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.textAlignment = .Right
        authorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        authorLabel.textColor = THEME_COLOR_BACK
        addSubview(authorLabel)
        
        backIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_leftMargin)
            make.height.width.equalTo(20)
            make.centerY.equalTo(authorLabel.snp_centerY)
        }
        
        authorLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(snp_rightMargin)
            make.left.equalTo(backIcon.snp_right)
            //make.top.equalTo(commentLabel.snp_bottom).offset(20)
            make.bottom.equalTo(snp_bottom).offset(-20)
        }
        
    }
    
    func back(sender:AnyObject) {
        delegate?.didTapBackInCardDetailView(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
}