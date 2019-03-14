//
//  AppDelegate.swift
//  AliyunOSSUploadImage
//
//  Created by git burning on 2019/3/13.
//  Copyright © 2019年 git burning. All rights reserved.
//

import UIKit

//let OSS_STSTOKEN_URL: String = "http://10.13.50.10:8082/doctor/image/getOssSignForApp?businessCode=555-55"
let OSS_STSTOKEN_URL: String = "http://10.13.50.3:8182/hospital/image/getOssSignForApp?businessCode=555-55"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    struct Student: Decodable {
//        var name: String?
//        var age: Int?
//        var weight: Float?
//    }
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        BRAliyunOSSUploadParameterConfig.default.mSTSTokenUrl = OSS_STSTOKEN_URL
        
        BRAliyunOSSUploadParameterConfig.default.mConfigHttpHeaderBlock =  {(info) in
            return ["accessToken":"79d00042-22e4-46ba-bf65-3d694576a8c4","userHospitalId":"32"]
        }
        
 
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

