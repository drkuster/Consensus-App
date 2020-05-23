//
//  SearchViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/21/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController
{

    @IBOutlet weak var topicSearchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = .clear
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        
        topicSearchBar.backgroundImage = UIImage()
//        topicSearchBar.tintColor = .black
        topicSearchBar.backgroundColor = .clear
        
        if #available(iOS 13.0, *)
        {
            topicSearchBar.searchTextField.backgroundColor = .white
            topicSearchBar.searchTextField.textColor = .black
        }
    }

}
