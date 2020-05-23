//
//  TrendViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/20/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import SDWebImage

class TrendViewController: UIViewController
{

    @IBOutlet weak var trendTable: UITableView!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var analysisDescription: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    var tweetText : [String]?
    var screenNameCollection : [String]?
    var userNameCollection : [String]?
    var profileImageCollection : [String]?
    var topicText : String?
    var emoji : String?
    var topicDescription : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let topic = topicText { topicLabel.text = topic }
        if let emojiToPut = emoji { emojiLabel.text = emojiToPut}
        if let anylDescription = topicDescription { analysisDescription.text = anylDescription}
        self.tabBarController?.tabBar.backgroundColor = .clear
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        trendTable.rowHeight = 130
        self.trendTable.backgroundColor = UIColor(red: 0.22, green: 0.63, blue: 0.95, alpha: 1.00)
        trendTable.separatorStyle = .none
        trendTable.register(UINib(nibName: K.trendCellNibName, bundle: nil), forCellReuseIdentifier: K.trendCellID)
        trendTable.rowHeight = UITableView.automaticDimension
        trendTable.estimatedRowHeight = 150
        trendTable.layer.cornerRadius = 15
    }

}

extension TrendViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweetText?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.trendCellID, for: indexPath) as! TweetTableViewCell
        
        if let tweets = tweetText, let images = profileImageCollection, let userNames = userNameCollection, let screenNames = screenNameCollection
        {
            cell.tweetText.text = tweets[indexPath.row]
            cell.username.text = userNames[indexPath.row]
            cell.screenname.text = "@\(screenNames[indexPath.row])"
            
            if let url = URL(string: images[indexPath.row])
            {
                cell.profilepic.sd_setImage(with: url)
            }
        }
        
        return cell
    }
    
    
}
