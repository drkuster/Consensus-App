//
//  WelcomeViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/17/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController
{
    
    @IBOutlet weak var welcomeLabel: UILabel!
    var welcomeName : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateWelcomeName()
    }
    
    func updateWelcomeName()
    {
        if let name = welcomeName
        {
            welcomeLabel.text = "Welcome, \(name)!\n😄"
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false)
        { (timer) in
            self.performSegue(withIdentifier: K.homeSegue, sender: self)
        }
    }

}
