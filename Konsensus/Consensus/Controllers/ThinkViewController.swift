//
//  ThinkViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/29/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class ThinkViewController: UIViewController
{

    var goTo : String?
    var withName : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        switch goTo
        {
            case "welcome":
                performSegue(withIdentifier: "thinkToWelcome", sender: self)
            case "login":
                performSegue(withIdentifier: "thinkToLogin", sender: self)
            default:
                return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "thinkToWelcome"
        {
            let destinationVC = segue.destination as! WelcomeViewController
            destinationVC.welcomeName = withName
        }
    }
    
}
