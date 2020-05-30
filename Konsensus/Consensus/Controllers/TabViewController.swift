//
//  TabViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/30/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tabGradientView = UIView(frame: self.tabBar.bounds)
        tabGradientView.backgroundColor = UIColor(named: "Brand Blue")
        tabGradientView.translatesAutoresizingMaskIntoConstraints = false;
        self.tabBar.addSubview(tabGradientView)
        self.tabBar.sendSubviewToBack(tabGradientView)
        tabGradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabGradientView.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabGradientView.layer.shadowRadius = 4.0
        tabGradientView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        tabGradientView.layer.shadowOpacity = 1
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }

}
