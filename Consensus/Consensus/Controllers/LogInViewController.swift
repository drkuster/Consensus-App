//
//  LogInViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/17/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import TwitterKit
import SDWebImage
import SwifteriOS

class LogInViewController: UIViewController
{
    
    @IBOutlet weak var loginButton: UIButton!
    
    private var loggedInUser : String?
    private var userIsLoggedIn = false
    
    override func viewDidAppear(_ animated: Bool)
    {
        if userIsLoggedIn { performSegue(withIdentifier: K.homeLoggedInSegue, sender: self) }
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.titleLabel?.minimumScaleFactor = 0.5
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: UIButton)
    {
        TWTRTwitter.sharedInstance().logIn
        { (session, error) in
            if session != nil
            {
                if let userId = session?.userID
                {
                    let client = TWTRAPIClient(userID: userId)
                    client.loadUser(withID: userId)
                    { (user, error) in
                        if let currentUser = user
                        {
                            self.encodeOath(token : session!.authToken, secret : session!.authTokenSecret, name : currentUser.name)
                            self.loggedInUser = currentUser.name
                            self.performSegue(withIdentifier: K.welcomeSegue, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func encodeOath(token : String, secret : String, name : String)
    {
        K.oathToken = token
        K.oathSecretToken = secret
        let auth = UserDefaults.standard
        auth.set(token, forKey: "Oath Token")
        auth.set(secret, forKey: "Oath Secret Token")
        auth.set(name, forKey: "Name")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == K.welcomeSegue
        {
            let destinationVC = segue.destination as! WelcomeViewController
            destinationVC.welcomeName = loggedInUser
        }
    }
    
}
