//
//  AppDelegate.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/16/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        TWTRTwitter.sharedInstance().start(withConsumerKey: K.apiKey, consumerSecret: K.sercretKey)
        let auth = UserDefaults.standard
        let oathToken = auth.string(forKey: "Oath Token")
        let oathSecretToken = auth.string(forKey: "Oath Secret Token")
        let name = auth.string(forKey: "Name")
        
        if let token = oathToken, let secret = oathSecretToken, let userName = name
        {
            print(token)
            print(secret)
            K.oathToken = token
            K.oathSecretToken = secret
            
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let initialViewController = storyboard.instantiateViewController(withIdentifier: "welcomeVC") as! WelcomeViewController
            initialViewController.welcomeName = userName

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

