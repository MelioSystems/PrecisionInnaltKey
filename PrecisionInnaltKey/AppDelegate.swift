//
//  AppDelegate.swift
//  PrecisionInnaltKey
//
//  Created by Srinivasan T on 25/08/22.
//

import UIKit
import InnaitPod

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let configM = ConfigurationManager()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let config = UserDefaults.standard.object(forKey: "config") as! NSDictionary
        if config.count > 0 {
            print("Already configuration setting up")
        }else {
        configM.setConfig(url: "https://ikmelio.innaitkey.com/api/fido/", projectId: "innait", rpId: "ikmelio.innaitkey.com")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

