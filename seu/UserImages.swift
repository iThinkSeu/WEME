//
//  UserImages.swift
//  WE
//
//  Created by liewli on 12/18/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class UserImageCollectionCell:UICollectionViewCell {
    
    private var imgView:UIImageView!
    
    func initialize() {
        imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imgView)
        imgView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView.snp_left)
            make.right.equalTo(contentView.snp_right)
            make.top.equalTo(contentView.snp_top)
            make.bottom.equalTo(contentView.snp_bottom)
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

class UserImageVC:UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    private lazy var imageCollectionView:UICollectionView = {
        let imgCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        imgCollectionView.registerClass(UserImageCollectionCell.self, forCellWithReuseIdentifier: NSStringFromClass(UserImageCollectionCell))
        return imgCollectionView
    }()
    
    private var images = [UserImageModel]()
    private var currentPage = 1
    var userid:String!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        view.addSubview(imageCollectionView)
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
        fetchImages()
    }
    
    static let IMAGE_SIZE = (SCREEN_WIDTH-3*10-40) / 3
    
    func setupUI() {
        imageCollectionView.backgroundColor = UIColor.whiteColor()
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        imageCollectionView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(10)
            make.right.equalTo(view.snp_right).offset(-10)
            make.top.equalTo(view.snp_top)
            make.bottom.equalTo(view.snp_bottom)
        }
    }
    
    func fetchImages() {
        if let t = token {
            print("called")
            request(.POST, GET_USER_TIMELINE_IMAGES, parameters: ["token":t, "userid":userid, "page":"\(currentPage)"], encoding: .JSON).responseJSON(completionHandler: { [weak self](response) -> Void in
                if let d = response.result.value, S = self {
                    let json = JSON(d)
                    guard json != .null && json["state"].stringValue == "successful" else {
                        return
                    }
                    
                    do {
                        let imgs = try MTLJSONAdapter.modelsOfClass(UserImageModel.self, fromJSONArray: json["result"].arrayObject) as! [UserImageModel]
                        if imgs.count > 0 {
//                            S.currentPage++
//                            var k = S.images.count
//                            var indexPaths = [NSIndexPath]()
//                            for _ in imgs {
//                                let indexPath = NSIndexPath(forItem: k, inSection: 0)
//                                indexPaths.append(indexPath)
//                                k++
//                            }
                            S.images.appendContentsOf(imgs)
                            S.imageCollectionView.reloadData()
                            //S.imageCollectionView.insertItemsAtIndexPaths(indexPaths)

                        }
                    }
                    catch let e as NSError {
                        print(e)
                    }
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(UserImageCollectionCell), forIndexPath: indexPath) as! UserImageCollectionCell
        let data = images[indexPath.item]
        cell.imgView.sd_setImageWithURL(data.thumbnail, placeholderImage: nil)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UserImageVC.IMAGE_SIZE, UserImageVC.IMAGE_SIZE)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == images.count - 1 {
           // fetchImages()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let browser = MWPhotoBrowser(delegate: self)
        browser.setCurrentPhotoIndex(UInt(indexPath.item))
        browser.displayActionButton = false
        navigationController?.pushViewController(browser, animated: true)
    }
    
}

extension UserImageVC:MWPhotoBrowserDelegate {
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
        print("called")
        let data = images[Int(index)]
        let vc = PostVC()
        vc.postID = data.postid
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


