//
//  Me.swift
//  牵手东大
//
//  Created by liewli on 11/5/15.
//  Copyright © 2015 li liew. All rights reserved.
//

import UIKit

class PersonalInfoVC:UIViewController {
    
    
    private var pageMenu:CAPSPageMenu!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我"
        setNeedsStatusBarAppearanceUpdate()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.blackColor()
        loadUI()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func loadUI() {
        let meVC = MeVC()
        meVC.title = "个人信息"
        //let msgVC = MessageVC()
        let settingVC = SettingVC()
        settingVC.title = "设置"
        let controllers = [meVC, settingVC]
        let parameters: [CAPSPageMenuOption] = [
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .UnselectedMenuItemLabelColor(UIColor(red: 218/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor(red: 218/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1.0)),
            .MenuHeight(44),
            .MenuItemFont(UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)),
            .MenuItemSeparatorWidth(5),
            .ScrollMenuBackgroundColor(THEME_COLOR)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllers, frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), pageMenuOptions: parameters)
        pageMenu.delegate = self
        view.backgroundColor = THEME_COLOR
        view.addSubview(pageMenu.view)
        
        addChildViewController(pageMenu)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       pageMenu.view.frame = CGRectMake(0, topLayoutGuide.length, view.frame.size.width, view.frame.height - topLayoutGuide.length)
    }
    
}

extension PersonalInfoVC: CAPSPageMenuDelegate {
    func didMoveToPage(controller: UIViewController, index: Int) {
        if index > 0 {
            tabBarController?.tabBar.hidden = true
        }
        else {
            tabBarController?.tabBar.hidden = false
        }
    }
}


