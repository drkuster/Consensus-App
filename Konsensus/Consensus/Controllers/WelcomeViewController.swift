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
            if name == "NULL"
            {
                welcomeLabel.text = "Welcome!\n😄"
            }
            
            else
            {
                welcomeLabel.text = "Welcome, \(name)!\n😄"
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false)
        { (timer) in
            self.performSegue(withIdentifier: K.homeSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationVC = segue.destination as? UITabBarController
        {
            let tabGradientView = UIView(frame: destinationVC.tabBar.bounds)
            tabGradientView.backgroundColor = UIColor(named: "Brand Blue")
            tabGradientView.translatesAutoresizingMaskIntoConstraints = false;


            destinationVC.tabBar.addSubview(tabGradientView)
            destinationVC.tabBar.sendSubviewToBack(tabGradientView)
            tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            tabGradientView.layer.shadowOffset = CGSize(width: 0, height: -3)
            tabGradientView.layer.shadowRadius = 4.0
            tabGradientView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            tabGradientView.layer.shadowOpacity = 1
            destinationVC.tabBar.clipsToBounds = false
            destinationVC.tabBar.backgroundImage = UIImage()
            destinationVC.tabBar.shadowImage = UIImage()
        }
    }

}
