//
//  CardPeople.swift
//  WEME
//
//  Created by liewli on 2016-01-08.
//  Copyright © 2016 li liew. All rights reserved.
//

import UIKit

class CardPeopleVC:CardVC, CardPeopleContentViewDelegate, EZAudioPlayerDelegate {
    enum AudioState {
        case Play
        case Stop
    }
    var recommendPeople = [PersonModel]()
    var currentIndex = 0
    var audioPlot:EZAudioPlotGL!
    var player:EZAudioPlayer!
    var sheet:IBActionSheet?
    var infoLabel:UILabel!
    var currentAudioState:AudioState = .Play
    
    var currentPeople:PersonModel? {
        didSet {
            if currentPeople == nil {
                actionRight.enabled = false
            }
            else {
                actionRight.enabled = true
            }
        }
    }
    var currentCard:CardPeopleContentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPeople = nil
        fetchRecommendPeople()
        setupAudio()
    }
    
    func setupAudio() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }
        catch {
            print(error)
        }
        
        audioPlot = EZAudioPlotGL(frame: CGRectZero)
        audioPlot.backgroundColor = UIColor.clearColor()
        audioPlot.plotType = EZPlotType.Buffer
        audioPlot.shouldFill = true
        audioPlot.shouldMirror = true
        
        audioPlot.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(audioPlot)
        audioPlot.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(topView.snp_leftMargin)
            make.right.equalTo(topView.snp_rightMargin)
            make.top.equalTo(topView.snp_top)
            make.bottom.equalTo(topView.snp_bottom)
        }
        
        infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.textColor = UIColor.whiteColor()
        infoLabel.textAlignment = .Center
        infoLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        midView.addSubview(infoLabel)
        infoLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(midView.snp_left)
            make.right.equalTo(midView.snp_right)
            make.top.equalTo(midView.snp_top)
            make.bottom.equalTo(midView.snp_bottom)
        }
        player = EZAudioPlayer(delegate: self)
        
       

    }
    
    override func tapDeck(sender: AnyObject) {
        super.tapDeck(sender)
        infoLabel.text = ""
        player.pause()
        audioPlot.clear()
        currentAudioState = .Play
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.audioPlot.clear()
        }
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, playedAudio buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32, inAudioFile audioFile: EZAudioFile!) {
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            if let S = self {
                S.audioPlot.updateBuffer(buffer[0], withBufferSize: bufferSize)
            }
        }
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, inAudioFile audioFile: EZAudioFile!) {
        dispatch_async(dispatch_get_main_queue()) { [weak self]() -> Void in
            if let S = self {
                S.infoLabel.text = "\(audioPlayer.formattedCurrentTime)/\(audioPlayer.formattedDuration)"
            }
        }
    }
    
    func audioPlayer(audioPlayer: EZAudioPlayer!, reachedEndOfAudioFile audioFile: EZAudioFile!) {
            dispatch_async(dispatch_get_main_queue(), { [weak self]() -> Void in
                if let S = self {
                    S.audioPlot.clear()
                    S.player.pause()
                    S.infoLabel.text = ""
                    if let card = S.currentCard {
                        S.toggleState(card)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        S.audioPlot.clear()
                        S.infoLabel.text = ""
                    })
                    
                }
            })
        
    }
    


    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        sheet?.removeFromView()
    }
    
    func fetchRecommendPeople() {
        if let t = token {
            request(.POST, GET_RECOMMENDED_FRIENDS_URL, parameters: ["token":t], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                debugPrint(response)
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json["state"].stringValue == "successful" else {
                        return
                    }
                    
                    do {
                        let people = try MTLJSONAdapter.modelsOfClass(PersonModel.self, fromJSONArray: json["result"].arrayObject) as? [PersonModel]
                        if let t = people where t.count > 0 {
                            S.recommendPeople = t
                            S.currentIndex = 0
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            })
        }
    }
    
    override func nextCard() -> CardContentView {
        if recommendPeople.count > 0 {
            let card = CardPeopleContentView()
            let p = recommendPeople[currentIndex % recommendPeople.count]
            print(p)
            if p.voiceURL == nil {
                print("invalid url")
            }
            currentIndex = (++currentIndex) % recommendPeople.count
            if currentIndex == 0 {
                fetchRecommendPeople()
            }
            currentPeople = p
            card.imgView.sd_setImageWithURL(avatarURLForID(p.ID), placeholderImage: UIImage(named: "avatar"), completed: { [weak self](image, error, cacheType, url) -> Void in
                if image != nil && error == nil {
                    if let S = self {
                        S.refreshBackground(image)
                    }
                    
                }
                else {
                    if let S = self {
                        S.refreshBackground(UIImage(named: "avatar")!)
                    }
                }
            })
            
            card.nameLabel.text = p.name
            if p.gender == "男" {
                card.gender.image = UIImage(named: "male")
            }
            else if p.gender == "女" {
                card.gender.image = UIImage(named: "female")
            }
            card.birthdayLabel.text = p.birthday
            card.schoolLabel.text = p.school
            card.degreeLabel.text = p.degree
            card.locationLabel.text = p.hometown
            card.voiceButton.alpha = p.voiceURL == nil ? 0 : 1.0
           // card.likeLabel.text = "0"
            
            let placeholder = ["年龄(未知)", "学校(未知)", "学历(未知)", "家乡(未知)"]
            let arr = [card.birthdayLabel,  card.schoolLabel, card.degreeLabel, card.locationLabel]
            for (index, label) in arr.enumerate() {
                if let text = label.text{
                    let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
                    if text.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
                        label.text = placeholder[index]
                    }
                }
                else if label.text == nil {
                    label.text = placeholder[index]
                }

            }
            
            card.peopleCardDelegate = self
            currentCard = card
            return card
        }
        else {
            let card = CardDefaultView()
            card.imgView.image = UIImage(named: "avatar")
            fetchRecommendPeople()
            return card
        }
        
    }
    
    override func detailViewForCurrentCard() -> CardDetailView? {
        return nil
    }
    
    func didTapAvatarAtCard(card: CardPeopleContentView) {
        if let p = currentPeople {
            let vc = InfoVC()
            vc.id = p.ID
            navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    func toggleState(card:CardPeopleContentView) {
        let rotate = CAKeyframeAnimation(keyPath: "transform.rotation.y")
        rotate.values = [0.0, -M_PI / 2.0, -M_PI]
        rotate.duration = 0.6
        rotate.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        CATransaction.setCompletionBlock { [weak self]() -> Void in
            if let S = self, card = self?.currentCard{
                if case .Play = S.currentAudioState {
                    card.voiceButton.tintColor = TEXT_COLOR
                }
                else {
                    card.voiceButton.tintColor = UIColor.redColor()
                }
                
            }

        }
        card.voiceButton.layer.addAnimation(rotate, forKey: "rotation")
        CATransaction.commit()
        card.voiceButton.transform = CGAffineTransformIdentity
        switch currentAudioState {
        case .Play:
            //card.voiceButton.tintColor = UIColor.redColor()
            currentAudioState = .Stop
        case .Stop:
            player.pause()
            audioPlot.clear()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.audioPlot.clear()
            })
            infoLabel.text = ""
            //card.voiceButton.tintColor = TEXT_COLOR
            currentAudioState = .Play
        }
      
    }
    
    func didTapVoiceAtCard(card: CardPeopleContentView) {
        toggleState(card)
        if case .Stop = currentAudioState {
            infoLabel.text = "加载中..."
        }
        if let p = currentPeople where p.voiceURL != nil {
            download(.GET, p.voiceURL.absoluteString, destination: { (url, response) -> NSURL in
                debugPrint(response)
                let directory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
                return directory.URLByAppendingPathComponent("voice_\(p.ID)")
            }).response(completionHandler: { [weak self](_, _, data, error) -> Void in
                if let S = self {
                   S.infoLabel.text = ""
                }
                if let S = self where error == nil {
                    if let pp = S.currentPeople where pp.ID == p.ID {
                        let directory = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)[0]
                        let fileurl = directory.URLByAppendingPathComponent("voice_\(p.ID)")
                        if case .Stop = S.currentAudioState {
                            S.player.playAudioFile(EZAudioFile(URL: fileurl))
                        }
                    }
                }
                else {
                    print(error)
                }
            })
        }
    }
    
    func followUser(id:String) {
        if let t = token{
            request(.POST, FOLLOW_URL, parameters: ["token":t, "id":id], encoding: .JSON).responseJSON{ [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json["state"].stringValue == "successful" else {
                        S.messageAlert("关注失败")
                        return
                    }
                    
                    let hud = MBProgressHUD.showHUDAddedTo(S.view, animated: true)
                    hud.mode = .CustomView
                    hud.customView = UIImageView(image: UIImage(named: "checkmark"))
                    hud.labelText = "关注成功"
                    hud.hide(true, afterDelay: 1.0)
                }
                    
                else if let _ = response.result.error, S = self {
                    S.messageAlert("关注失败")
                }
                
            }
            
        }
    }
    
    override func tapRight(sender: AnyObject) {
        sheet = IBActionSheet(title: nil, callback: { (sheet, index) -> Void in
            if index == 0 {
                if let p = self.currentPeople {
                    self.followUser(p.ID)
                }
            }
            else if index == 1 {
                if let p = self.currentPeople {
                    let vc = ComposeMessageVC()
                    vc.recvID = p.ID
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            }, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitlesArray: ["关注", "私信"])
        sheet?.setButtonTextColor(THEME_COLOR)
        sheet?.showInView(navigationController!.view)
    }
}

protocol CardPeopleContentViewDelegate:class {
    func didTapAvatarAtCard(card:CardPeopleContentView)
    func didTapVoiceAtCard(card:CardPeopleContentView)
}

class CardPeopleContentView:CardContentView {
    
    var nameLabel:UILabel!
    var gender:UIImageView!
    var birthdayLabel:UILabel!
    var schoolLabel:UILabel!
    var degreeLabel:UILabel!
    var location:UIImageView!
    var locationLabel:UILabel!
    var gradientLayer:CAGradientLayer!
    var likeButton:UIButton!
    var likeLabel:UILabel!
    var voiceButton:UIButton!
    
    weak var peopleCardDelegate:CardPeopleContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    
    func tapAvatar(sender:AnyObject) {
        peopleCardDelegate?.didTapAvatarAtCard(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.bounds = imgView.bounds
        gradientLayer.position = CGPointMake(CGRectGetMidX(imgView.bounds), CGRectGetMidY(imgView.bounds))
        
    }

    
    func initialize() {
        backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapAvatar:")
        imgView.addGestureRecognizer(tap)
        addSubview(imgView)
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, 100, 100)
        gradientLayer.colors = [UIColor.blackColor().alpha(0.6).CGColor, UIColor.clearColor().CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:0.5, y:0.8)
        layer.addSublayer(gradientLayer)
        
//        likeButton = UIButton()
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        likeButton.setImage(UIImage(named: "like")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
//        likeButton.tintColor = UIColor.whiteColor()
//        addSubview(likeButton)
//        
//        likeLabel = UILabel()
//        likeLabel.translatesAutoresizingMaskIntoConstraints = false
//        likeLabel.textColor = UIColor.whiteColor()
//        likeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
//        addSubview(likeLabel)
//        
//        likeLabel.snp_makeConstraints { (make) -> Void in
//            make.bottom.equalTo(imgView.snp_bottom).offset(-5)
//            make.right.equalTo(imgView.snp_rightMargin)
//        }
//        
//        likeButton.snp_makeConstraints { (make) -> Void in
//            make.right.equalTo(likeLabel.snp_left).offset(-5)
//            make.centerY.equalTo(likeLabel.snp_centerY)
//            make.width.height.equalTo(14)
//        }
//
//        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = TEXT_COLOR
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        addSubview(nameLabel)
        
        gender = UIImageView()
        gender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gender)
        
        birthdayLabel = UILabel()
        birthdayLabel.translatesAutoresizingMaskIntoConstraints = false
        birthdayLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        birthdayLabel.textAlignment = .Right
        birthdayLabel.textColor = TEXT_COLOR
        addSubview(birthdayLabel)
        
        schoolLabel = UILabel()
        schoolLabel.translatesAutoresizingMaskIntoConstraints = false
        schoolLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        schoolLabel.textColor = TEXT_COLOR
        schoolLabel.textAlignment = .Left
        addSubview(schoolLabel)
        
        degreeLabel = UILabel()
        degreeLabel.translatesAutoresizingMaskIntoConstraints = false
        degreeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        degreeLabel.textColor = TEXT_COLOR
        degreeLabel.textAlignment = .Right
        addSubview(degreeLabel)
        
        location = UIImageView(image: UIImage(named: "location")?.imageWithRenderingMode(.AlwaysTemplate))
        location.translatesAutoresizingMaskIntoConstraints = false
        location.tintColor = THEME_COLOR_BACK
        addSubview(location)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        locationLabel.textColor = TEXT_COLOR
        locationLabel.textAlignment = .Right
        addSubview(locationLabel)

        voiceButton = UIButton()
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(voiceButton)
        voiceButton.setBackgroundImage(UIImage(named: "voice")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        voiceButton.tintColor = TEXT_COLOR
        voiceButton.addTarget(self, action: "voiceTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        voiceButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(snp_centerX)
            make.bottom.equalTo(snp_bottom).offset(-20)
            make.width.height.equalTo(30)
        }
        
        imgView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(snp_top)
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
            make.height.equalTo(imgView.snp_width)
        }
        
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(imgView.snp_bottom).offset(5)
            make.left.equalTo(snp_left)
            make.right.equalTo(snp_right)
        }
        gender.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom).offset(10)
            make.left.equalTo(snp_leftMargin)
            make.width.equalTo(16)
            make.height.equalTo(18)
        }
        birthdayLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(gender.snp_right)
            make.right.equalTo(snp_rightMargin)
            make.centerY.equalTo(gender.snp_centerY)
        }
        
        schoolLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(snp_leftMargin)
            make.top.equalTo(birthdayLabel.snp_bottom).offset(10)
            schoolLabel.setContentHuggingPriority(UILayoutPriorityDefaultLow, forAxis: .Horizontal)
        }
        
        degreeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(schoolLabel.snp_right)
            make.right.equalTo(snp_rightMargin)
            make.centerY.equalTo(schoolLabel.snp_centerY)
            degreeLabel.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Horizontal)
        }
        
        location.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(schoolLabel.snp_bottom).offset(10)
            make.left.equalTo(snp_leftMargin)
            make.width.height.equalTo(20)
        }
        
        locationLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(location.snp_right)
            make.right.equalTo(snp_rightMargin)
            make.centerY.equalTo(location.snp_centerY)
        }
        
        
    }
    
    func voiceTap(sender:AnyObject) {
        peopleCardDelegate?.didTapVoiceAtCard(self)
    }

}



