//
//  Card.swift
//  WE
//
//  Created by liewli on 12/21/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

enum CardState {
    case Empty
    case NoneEmpty
    case Animating
    case Flipped
}

class CardVC:UIViewController {
    private var actionLeft:UIButton!
    private var actionMid:UIButton!
    private var actionRight:UIButton!
    
    private var cardView:UIView!
    
    private var backView:UIImageView!
    
    private var deckView:UIImageView!
    
    private var visualView:UIVisualEffectView!
    
    private var hostView:UIView!
    
    private var drawCardLabel:UILabel!
    
    private var state:CardState = .Empty
    
    private var currentCard:CardContentView? {
        didSet {
            currentCard?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        configUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
          UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
    }
    
    func setupUI() {
        backView = UIImageView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backView)
        backView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
        }
        
        let blurEffect = UIBlurEffect(style: .Light)
        visualView = UIVisualEffectView(effect: blurEffect)
        visualView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(visualView)
        visualView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left)
            make.right.equalTo(view.snp_right)
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
        }
        
//        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffect)
//        let vibrancyView = UIVisualEffectView(effect: vibrancy)
//        vibrancyView.translatesAutoresizingMaskIntoConstraints  = false
//        visualView.contentView.addSubview(vibrancyView)
//        vibrancyView.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(visualView.contentView.snp_left)
//            make.right.equalTo(visualView.contentView.snp_right)
//            make.top.equalTo(visualView.contentView.snp_top)
//            make.bottom.equalTo(visualView.contentView.snp_bottom)
//        }
//        
        hostView = UIView()
        hostView.translatesAutoresizingMaskIntoConstraints = false
        hostView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        visualView.contentView.addSubview(hostView)
        hostView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(visualView.contentView.snp_left)
            make.right.equalTo(visualView.contentView.snp_right)
            make.top.equalTo(visualView.contentView.snp_top)
            make.bottom.equalTo(visualView.contentView.snp_bottom)
        }
        
        
        actionMid = UIButton(type:.System)
        actionMid.translatesAutoresizingMaskIntoConstraints = false
        hostView.addSubview(actionMid)
        actionMid.setImage(UIImage(named: "food_search")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        actionMid.tintColor = UIColor.whiteColor()
        actionMid.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(hostView.snp_centerX)
            make.height.width.equalTo(24)
            make.top.equalTo(hostView.snp_topMargin).offset(10)
        }
        
        actionLeft = UIButton(type: .System)
        actionLeft.translatesAutoresizingMaskIntoConstraints = false
        hostView.addSubview(actionLeft)
        actionLeft.setImage(UIImage(named: "food_reply")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        actionLeft.tintColor = UIColor.whiteColor()
        actionLeft.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(actionMid.snp_centerY)
            make.centerX.equalTo(hostView.snp_centerX).multipliedBy(0.3)
            make.height.width.equalTo(24)
        }
        
        actionRight = UIButton(type: .System)
        actionRight.translatesAutoresizingMaskIntoConstraints = false
        hostView.addSubview(actionRight)
        actionRight.setImage(UIImage(named: "food_share")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        actionRight.tintColor = UIColor.whiteColor()
        actionRight.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(actionMid.snp_centerY)
            make.centerX.equalTo(hostView.snp_centerX).multipliedBy(1.7)
            make.height.width.equalTo(24)
        }
        
        deckView = UIImageView()
        deckView.translatesAutoresizingMaskIntoConstraints  = false
        deckView.backgroundColor = UIColor.whiteColor()
        deckView.userInteractionEnabled = true
        deckView.layer.borderWidth = 10
        deckView.layer.borderColor = UIColor.whiteColor().CGColor
        //deckView.contentMode = .ScaleToFill
       // deckView.image = UIImage(named: "spade")
        let tap = UITapGestureRecognizer(target: self, action: "tapDeck:")
        deckView.addGestureRecognizer(tap)
        hostView.addSubview(deckView)
        
        cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = UIColor.clearColor()
        hostView.addSubview(cardView)
       // cardView.layer.cornerRadius = 5.0
       // cardView.layer.masksToBounds = true
        cardView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(hostView.snp_centerX)
            make.centerY.equalTo(hostView.snp_centerY)
            make.width.equalTo(hostView.snp_width).multipliedBy(0.7)
            make.height.equalTo(cardView.snp_width).multipliedBy(1.5)
        }
        
    
        deckView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(hostView.snp_centerX)
            make.width.equalTo(cardView.snp_width)
            make.height.equalTo(hostView.snp_height).multipliedBy(0.1)
            make.bottom.equalTo(hostView.snp_bottom).offset(10)
        }
        
        drawCardLabel = UILabel()
        drawCardLabel.translatesAutoresizingMaskIntoConstraints = false
        deckView.addSubview(drawCardLabel)
        drawCardLabel.textColor = THEME_COLOR_BACK
        drawCardLabel.backgroundColor = UIColor.whiteColor()//UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        drawCardLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        drawCardLabel.textAlignment = .Center
        drawCardLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(deckView.snp_left)
            make.right.equalTo(deckView.snp_right)
            make.top.equalTo(deckView.snp_top).offset(10)
        }
        let text = "点击此处 抽取扑克"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes([NSForegroundColorAttributeName:UIColor.colorFromRGB(0x3c404a), NSFontAttributeName:UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)], range: NSMakeRange(2, 5))
        drawCardLabel.attributedText = attributedText
        
    }
    
    func tapDeck(sender:AnyObject) {
        switch state {
        case .Empty:
            state = .Animating
             let rect = CGRectMake(self.deckView.frame.origin.x, self.deckView.frame.origin.y, self.cardView.frame.size.width, self.cardView.frame.size.height)
             let rect1 = hostView.convertRect(rect, toView: cardView)
            let cardDefault1 = CardDefaultView(frame:rect1)
            cardDefault1.imgView.image = UIImage(named: "spade")
            self.cardView.addSubview(cardDefault1)
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
                cardDefault1.frame = CGRectMake(0, 0, self.cardView.frame.size
                    .width, self.cardView.frame.size.height)
                }, completion: { (finished) -> Void in
                    self.refreshBackView(cardDefault1)
                    let card1 = CardContentView(frame: self.cardView.bounds)
                    card1.imgView.image = UIImage(named: "food")
                    card1.avatar.image = UIImage(named: "dj")
                    card1.infoLabel.text = "wanwan 推荐"
                    card1.titleLabel.text = "蒜泥蒸大虾"
                    card1.detailIcon.image = UIImage(named: "location")
                    card1.detailLabel.text = "550 M"
                    self.currentCard = card1
                    UIView.transitionFromView(cardDefault1, toView: card1, duration: 0.8, options: .TransitionFlipFromBottom, completion: { (finished) -> Void in
                        self.refreshBackView(card1)
                        self.state = .NoneEmpty
                    })

            })
            
//            let card1 = CardContentView(frame: self.cardView.bounds)
//            card1.imgView.image = UIImage(named: "food")
//            card1.avatar.image = UIImage(named: "dev_liuli")
//            card1.infoLabel.text = "wanwan 推荐"
//            card1.titleLabel.text = "蒜泥蒸大虾"
//            card1.detailIcon.image = UIImage(named: "location")
//            card1.detailLabel.text = "550 M"
//            self.currentCard = card1
//
//            UIView.transitionWithView(cardView, duration: 1.0, options: [.AllowAnimatedContent, .TransitionFlipFromBottom], animations: { () -> Void in
//                cardDefault1.frame = CGRectMake(0, 0, self.cardView.frame.size
//                    .width, self.cardView.frame.size.height)
//                cardDefault1.removeFromSuperview()
//                self.cardView.addSubview(card1)
//
//                }, completion: { (finished) -> Void in
//                    self.state = .NoneEmpty
//            })
            

        case .NoneEmpty:
            state  = .Animating
            let cardDefault = CardDefaultView(frame: cardView.bounds)
            cardDefault.imgView.image = UIImage(named: "spade")
            let card = cardView.subviews[0]
            UIView.transitionFromView(card, toView: cardDefault, duration: 0.8, options: [.TransitionFlipFromTop, .CurveEaseInOut]) { (finished) -> Void in
                self.refreshBackView(cardDefault)
                let rect = CGRectMake(self.deckView.frame.origin.x, self.deckView.frame.origin.y, self.cardView.frame.size.width, self.cardView.frame.size.height)
                let rect1 = self.hostView.convertRect(rect, toView: self.cardView)
                let cardDefault1 = CardDefaultView(frame:rect1)
                cardDefault1.imgView.image = UIImage(named: "spade")
                self.cardView.addSubview(cardDefault1)
//
//                UIView.animateWithDuration(0.5, animations: { () -> Void in
//                    cardDefault1.frame = CGRectMake(0, 0, self.cardView.frame.size
//                        .width, self.cardView.frame.size.height)
//                    
//                    }, completion: { (finished) -> Void in
//
//                        cardDefault.removeFromSuperview()
//                        let card1 = CardContentView(frame: self.cardView.bounds)
//                        card1.imgView.image = UIImage(named: "food")
//                        card1.avatar.image = UIImage(named: "dev_liuli")
//                        card1.infoLabel.text = "wanwan 推荐"
//                        card1.titleLabel.text = "蒜泥蒸大虾"
//                        card1.detailIcon.image = UIImage(named: "location")
//                        card1.detailLabel.text = "550 M"
//                        self.currentCard = card1
//                        UIView.transitionFromView(cardDefault1, toView: card1, duration: 0.8, options: .TransitionFlipFromBottom, completion: { (finished) -> Void in
//                            self.refreshBackView(card1)
//                            self.state = .NoneEmpty
//                        })
//                })
                
                
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .CurveEaseIn, animations: { () -> Void in
                    cardDefault1.frame = CGRectMake(0, 0, self.cardView.frame.size
                        .width, self.cardView.frame.size.height)
                    }, completion: { (finished) -> Void in
                        cardDefault.removeFromSuperview()
                        let card1 = CardContentView(frame: self.cardView.bounds)
                        card1.imgView.image = UIImage(named: "food")
                        card1.avatar.image = UIImage(named: "dj")
                        card1.infoLabel.text = "wanwan 推荐"
                        card1.titleLabel.text = "蒜泥蒸大虾"
                        card1.detailIcon.image = UIImage(named: "location")
                        card1.detailLabel.text = "550 M"
                        self.currentCard = card1
                        UIView.transitionFromView(cardDefault1, toView: card1, duration: 0.8, options: [.TransitionFlipFromBottom, .CurveEaseInOut], completion: { (finished) -> Void in
                            self.refreshBackView(card1)
                            self.state = .NoneEmpty
                        })
                        
                })

            }
        case .Animating, .Flipped:
            break

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let path = UIBezierPath(roundedRect:deckView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(10.0, 10.0))
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        deckView.layer.mask = shape
        deckView.layer.masksToBounds = true
        
    }
    
    func refreshBackView(card:CardView) {
        let backImg = Utility.imageWithImage(card.imgView.image, scaledToSize: backView.bounds.size)
        backView.image = backImg
    }
    
    func maskPath() {
        let width = drawCardLabel.bounds.size.width
        let height = drawCardLabel.bounds.size.height
        let points = [CGPointMake(0.1*width, 0), CGPointMake(0.2*width, height), CGPointMake(width-0.2*width, height), CGPointMake(width-0.1*width, 0)]
        let sp = points[0]
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, sp.x, sp.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, p.x, p.y)
        }
        CGPathCloseSubpath(path)
        
        let shape = CAShapeLayer()
        shape.path = path
        drawCardLabel.layer.mask = shape
        drawCardLabel.layer.masksToBounds = true
    }
    
    func configUI() {
        let backImg = Utility.imageWithImage(UIImage(named:"spade"), scaledToSize: backView.bounds.size)
        backView.image = backImg
        
        deckView.image = UIImage(named: "spade")?.crop(CGRectMake(0, 0, deckView.bounds.size.width, deckView.bounds.size.height))
        maskPath()
    }
}

extension CardVC:CardContentViewDelegate, CardDetailViewDelegate {
    func didTapNext() {
        state = .Flipped
        let cardDetail = CardFoodDetailView(frame: self.cardView.bounds)
        cardDetail.imgView.image = UIImage(named: "food")
        cardDetail.locationLabel.text = "晋家门・艾尚天地店"
        cardDetail.infoLabel.text = "人均 70 RMB"
        let text = "“艾尚天地店，环境好，适合聚会。虾很新鲜，味道也比较清淡...”"
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(0, 1))
        attributedText.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(20), NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(text.characters.count-1, 1))
        cardDetail.commentLabel.attributedText = attributedText
        cardDetail.authorLabel.text = "By wanwan"
        cardDetail.delegate = self
        UIView.transitionFromView(currentCard!, toView: cardDetail, duration: 0.8, options: [.TransitionFlipFromRight, .CurveEaseInOut]) { (finished) -> Void in
            
        }
    }
   
    func didTapBackInCardDetailView(card: CardDetailView) {
        UIView.transitionFromView(card, toView: self.currentCard!, duration: 0.8, options: [.TransitionFlipFromLeft, .CurveEaseInOut]) { (finished) -> Void in
            self.state = .NoneEmpty
        }
    }
}

protocol CardView {
    var imgView:UIImageView! {get}
}

class CardDefaultView:UIView, CardView {
    
    var imgView:UIImageView!
    
    func initialize() {
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 6
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.whiteColor().CGColor
        imgView.layer.borderWidth = 10
        addSubview(imgView)
        imgView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.top.equalTo(snp_top)
            make.bottom.equalTo(snp_bottom)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }

}


protocol CardContentViewDelegate:class {
    func didTapNext()
}

class CardContentView:UIView, CardView {
    var imgView:UIImageView!
    private var avatar:UIImageView!
    private var infoLabel:UILabel!
    private var titleLabel:UILabel!
    private var detailIcon:UIImageView!
    private var detailLabel:UILabel!
    private var nextIcon:UIButton!
    
    weak var delegate:CardContentViewDelegate?
    
    func initialize() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        backgroundColor = UIColor.whiteColor()
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imgView)
        
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
            make.bottom.equalTo(snp_bottom).offset(-10)
            make.centerX.equalTo(snp_centerX).offset(5)
        }
        
        nextIcon.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(snp_rightMargin)
            make.height.width.equalTo(26)
            make.centerY.equalTo(detailLabel.snp_centerY)
        }
        
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

protocol CardDetailViewDelegate:class {
    func didTapBackInCardDetailView(card:CardDetailView)
}

class CardDetailView:UIView{

}
class CardFoodDetailView:CardDetailView {
    
    var imgView:UIImageView!
    var locationLabel:UILabel!
    var infoLabel:UILabel!
    var commentLabel:UILabel!
    var authorLabel:UILabel!
    weak var delegate:CardDetailViewDelegate?
    
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
            make.width.height.equalTo(snp_width).multipliedBy(0.6)
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
            make.left.equalTo(locationIcon.snp_right).offset(20)
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
            make.width.height.equalTo(20)
        }
        
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(infoIcon.snp_right).offset(20)
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
            make.height.width.equalTo(26)
            make.centerY.equalTo(authorLabel.snp_centerY)
        }
        
        authorLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(snp_rightMargin)
            make.left.equalTo(backIcon.snp_right)
            //make.top.equalTo(commentLabel.snp_bottom).offset(20)
            make.bottom.equalTo(snp_bottom).offset(-10)
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
