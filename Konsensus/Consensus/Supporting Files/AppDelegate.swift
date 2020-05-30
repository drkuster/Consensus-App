//
//  AppDelegate.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/16/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import TwitterKit
import IQKeyboardManagerSwift
import SwifteriOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        TWTRTwitter.sharedInstance().start(withConsumerKey: K.apiKey, consumerSecret: K.sercretKey)
        let auth = UserDefaults.standard
        let oathToken = auth.string(forKey: "Oath Token")
        let oathSecretToken = auth.string(forKey: "Oath Secret Token")
        
        if let token = oathToken, let secret = oathSecretToken
        {
            K.oathToken = token
            K.oathSecretToken = secret
            
            let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey, oauthToken: K.oathToken!, oauthTokenSecret: K.oathSecretToken!)
            swifter.getAccountSettings(success: { (response) in
                if let screenName = response["screen_name"].string
                {
                    swifter.showUser(.screenName(screenName), includeEntities: false, success:
                    { (response) in
                        if let foundUserName = response["name"].string
                        {
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
                            initialViewController.goTo = "welcome"
                            initialViewController.withName = foundUserName
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                        
                        else
                        {
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
                            initialViewController.goTo = "welcome"
                            initialViewController.withName = "NULL"
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                        }
                    })
                    { (error) in
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
                        initialViewController.goTo = "welcome"
                        initialViewController.withName = "NULL"
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                }
                
                else
                {
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
                    initialViewController.goTo = "welcome"
                    initialViewController.withName = "NULL"
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                }
                
            })
            { (error) in
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
                initialViewController.goTo = "welcome"
                initialViewController.withName = "NULL"
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        else
        {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "think") as! ThinkViewController
            initialViewController.goTo = "login"
            initialViewController.withName = "NULL"
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }

}

