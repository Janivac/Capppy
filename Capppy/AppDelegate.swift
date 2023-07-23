//
//  AppDelegate.swift
//  Capppy
//  Created by Jana Vac on 02.10.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //--->zabranuje rotaci
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

//<-------------
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor(red: 93/255, green: 79/255, blue: 141/255, alpha: 1)
        let backImg = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backImg
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImg
        UINavigationBar.appearance().tintColor = .darkGray

        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        
        FirebaseApp.configure()
        configureInitialViewController()
        
        // Deaktivace Dark Mode
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

    
    func configureInitialViewController() {
        var initialVC: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)
        } else {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_WELCOME)
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        Api.User.isOnline(bool: false)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Api.User.isOnline(bool: false)

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Api.User.isOnline(bool: true)
 

        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

