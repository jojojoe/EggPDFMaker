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

