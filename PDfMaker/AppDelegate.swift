//
//  AppDelegate.swift
//  PDfMaker
//
//  Created by JOJO on 2023/4/27.
//

import UIKit
import SwiftyStoreKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //    Picture Scan
    //    com.xx.888888
    //    com.superegg.okeydokey
    //    com.convert.files.PDF
/*
 产品名    Picture Scan
 包名    com.convert.picture.PDF
 App ID    6449591727
 Contact 邮箱    dham_huang_dad390@outlook.com
                     
 内购IAP ID    com.convert.picture.PDF.month        内购IAP ID    com.convert.picture.PDF.week
 内购IAP 价格    $7.99         内购IAP 价格    $4.99
 内购IAP ID    com.convert.picture.PDF.6months
 内购IAP 价格    $29.99
 内购IAP ID    com.convert.picture.PDF.year
 内购IAP 价格    $49.99
 Secret Key    47c401e554a1474eab7bf2670537c6ba
                     
 使用条款    https://sites.google.com/view/picture-scan-terms-of-use/homepage
 隐私条款    https://sites.google.com/view/picture-scan-privacy-policy/homepage

 
 */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        
        PDfSubscribeStoreManager.default.completeTransactions()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
         
    }


}

