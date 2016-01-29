//
//  AppDelegate.swift
//  seu
//
//  Created by liewli on 9/9/15.
//  Copyright (c) 2015 li liew. All rights reserved.
//

import UIKit

var token:String?
var myId:String?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window  = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.tintAdjustmentMode = .Normal
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        let defaults = NSUserDefaults.standardUserDefaults();
        if let t = defaults.stringForKey(TOKEN),
           let Id = defaults.stringForKey(ID){
            token = t
            myId = Id
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400, 0), forBarMetrics: UIBarMetrics.Default)
            let vc = HomeVC()
            window?.rootViewController = vc
            window?.makeKeyAndVisible();
            
        }
        else {
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400, 0), forBarMetrics: UIBarMetrics.Default)
            window?.rootViewController = LoginRegisterVC()
            window?.makeKeyAndVisible();
        }
        
     
        
        MobClick.startWithAppkey("566aacab67e58ec3410021a6", reportPolicy: ReportPolicy.init(1), channelId: "")
        let infoDict = (NSBundle.mainBundle().infoDictionary)!
        let currentVersion = infoDict["CFBundleShortVersionString"] as! String
        MobClick.setAppVersion(currentVersion)
        
        WXApi.registerApp("wx04e7630d122580c1", withDescription: "WeMe")
        
        AMapSearchServices.sharedServices().apiKey = "2b79be11eacfede90da2098bda7b5e04"
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
       return WXApi.handleOpenURL(url, delegate: WXApiManager.sharedManager())
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "weme.qrcode" {
            if let vc = window?.rootViewController as? HomeVC {
                vc.selectedIndex = 2
                let qr = MyQRCodeVC()
                (vc.viewControllers?[2] as? UINavigationController)?.pushViewController(qr, animated: true)
            }
        }
        else if shortcutItem.type == "weme.scan" {
            if let vc = window?.rootViewController as? HomeVC {
                vc.selectedIndex = 0
                let builder = QRCodeViewControllerBuilder { builder in
                    builder.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
                    builder.showTorchButton = true
                }
                
                let reader = QRCodeReaderViewController(builder: builder)
                let vc = (vc.viewControllers?[0] as? UINavigationController)?.viewControllers[0] as? ActivityVC
                reader.delegate = vc
                vc?.presentViewController(reader, animated: true, completion: nil)
    
            }
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

