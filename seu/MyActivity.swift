//
//  MyActivity.swift
//  WE
//
//  Created by liewli on 12/27/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class MyActivityVC:UIViewController{
    
    private var pageMenuController:CAPSPageMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "活动"
        setupPageMenu()
    }
    
    func setupPageMenu() {
        let vc1 = UIViewController()
        vc1.title = "我报名的活动"
        vc1.view.backgroundColor = UIColor.whiteColor()
        let vc2 = UIViewController()
        vc2.title = "我搜藏的活动"
        vc2.view.backgroundColor = BACK_COLOR
        let vc3 = UIViewController()
        vc3.title = "我发布的活动"
        vc3.view.backgroundColor = BACK_COLOR
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(THEME_COLOR),
            .UnselectedMenuItemLabelColor(THEME_COLOR_BACK),
            .SelectionIndicatorColor(THEME_COLOR),
            .UseMenuLikeSegmentedControl(true),
            .SelectionIndicatorHeight(1),
        ]
        pageMenuController = CAPSPageMenu(viewControllers: [vc1, vc2, vc3], frame: CGRectMake(0, 0, view.frame.width, view.frame.height), pageMenuOptions: parameters)
//        pageMenuController.view.translatesAutoresizingMaskIntoConstraints = false
//        pageMenuController.view.snp_makeConstraints { (make) -> Void in
//            make.left.equalTo(view.snp_left)
//            make.right.equalTo(view.snp_right)
//            make.top.equalTo(view.snp_top)
//            make.bottom.equalTo(view.snp_bottom)
//        }
        view.addSubview(pageMenuController.view)
        addChildViewController(pageMenuController)

    }
}
