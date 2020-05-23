//
//  ViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/16/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import TwitterKit
import SwifteriOS
import SwiftyJSON
import CoreML
import Vision

class FavoritesViewController: UIViewController
{
    
    @IBOutlet weak var trendTable: UITableView!
    var trendingItems = [String]()
    var tweetCollection = [String]()
    var profileImageCollection = [String]()
    var usernameCollection = [String]()
    var screenNameCollection = [String]()
    var topicSelected : String?
    let tweetClassifier = TweetClassifier()
    var emoji : String?
    var topicDescription : String?
    var score = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey, oauthToken: K.oathToken!, oauthTokenSecret: K.oathSecretToken!)
        swifter.getTrendsPlace(with: "23424977", excludeHashtags: false, success:
        { (response) in
            let trends = response[0]["trends"]
            for i in 0..<50
            {
                if let trend = trends[i]["name"].string
                {
                    self.trendingItems.append(trend)
                }
            }
            self.trendTable.reloadData()
        })
        { (error) in
            print(error)
        }
        self.tabBarController?.tabBar.backgroundColor = .clear
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        self.trendTable.backgroundColor = UIColor(red: 0.22, green: 0.63, blue: 0.95, alpha: 1.00)
        trendTable.separatorStyle = .none
        trendTable.register(UINib(nibName: K.favoriteCellNibName, bundle: nil), forCellReuseIdentifier: K.favoriteCellID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! TrendViewController
        destinationVC.tweetText = tweetCollection
        destinationVC.topicText = topicSelected
        destinationVC.screenNameCollection = self.screenNameCollection
        destinationVC.userNameCollection = self.usernameCollection
        destinationVC.profileImageCollection = self.profileImageCollection
        destinationVC.emoji = self.emoji
        destinationVC.topicDescription = self.topicDescription
    }
    
    func analyzeTweets(tweets : [TweetClassifierInput])
    {
        do
        {
            let predictions = try self.tweetClassifier.predictions(inputs: tweets)
            for pred in predictions
            {
                if pred.label == "Pos"
                {
                    score += 1
                }

                else if pred.label == "Neg"
                {
                    score -= 1
                }
            }
            updateUI()
        }

        catch let error
        {
            print(error)
        }
    }
    
    func updateUI()
    {
       if score > 20
       {
           emoji = "😍"
           topicDescription = "People love \(topicSelected!)"
       }
       
       else if score > 10
       {
           emoji = "😄"
           topicDescription = "People are really happy with \(topicSelected!)"
       }
       
       else if score > 0
       {
           emoji = "🙂"
           topicDescription = "People are happy with \(topicSelected!)"
       }
       
       else if score == 0
       {
           emoji = "😐"
           topicDescription = "People are indifferent about \(topicSelected!)"
       }
       
       else if score > -10
       {
           emoji = "☹️"
           topicDescription = "People aren't happy about \(topicSelected!)"
       }
       
       else if score > -20
       {
           emoji = "😡"
           topicDescription = "People are angry about \(topicSelected!)"
       }
       
       else
       {
           emoji = "🤮"
           topicDescription = "People are disgusted with \(topicSelected!)"
       }
    }

}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tweetCollection.removeAll()
        usernameCollection.removeAll()
        profileImageCollection.removeAll()
        screenNameCollection.removeAll()
        score = 0
        emoji = ""
        topicDescription = ""
        let cell = tableView.cellForRow(at: indexPath) as! TrendTableViewCell
        if let topicSelected = cell.trendLabel.text
        {
            self.topicSelected = topicSelected
            let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey)
            
            swifter.searchTweet(using: topicSelected, lang: "en", resultType: "mixed", count: 100,tweetMode: .extended, success:
            { (tweets, metadata) in
                var tweetsToAnalyze : [TweetClassifierInput] = []
                for i in 0..<50
                {
                    if let tweet = tweets[i]["full_text"].string
                    {
                        if tweet[0] != "R" && tweet[1] != "T"
                        {
                            self.tweetCollection.append(tweet)
                            tweetsToAnalyze.append(TweetClassifierInput(text: tweet))
                        }
                    }
                    
                    if let userImageURL = tweets[i]["user"]["profile_image_url_https"].string
                    {
                        self.profileImageCollection.append(userImageURL)
                    }
                    
                    if let username = tweets[i]["user"]["name"].string
                    {
                        self.usernameCollection.append(username)
                    }
                    
                    if let screenName = tweets[i]["user"]["screen_name"].string
                    {
                        self.screenNameCollection.append(screenName)
                    }
                }
                self.analyzeTweets(tweets: tweetsToAnalyze)
                self.performSegue(withIdentifier: K.trendSegue, sender: self)
            }) { (error) in
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.favoriteCellID, for: indexPath) as! TrendTableViewCell
        if !trendingItems.isEmpty
        {
            cell.trendLabel.text = trendingItems[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return trendingItems.count
    }
}

extension String {
    subscript (characterIndex: Int) -> Character {
        return self[index(startIndex, offsetBy: characterIndex)]
    }
}

