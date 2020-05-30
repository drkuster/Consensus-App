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
import NVActivityIndicatorView

class FavoritesViewController: UIViewController
{
    
    @IBOutlet weak var trendTable: UITableView!
    @IBOutlet weak var trendingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textHeight: NSLayoutConstraint!
    @IBOutlet weak var trendingView: UIView!
    var trendingItems = [String]()
    var tweetCollection = [String]()
    var profileImageCollection = [String]()
    var usernameCollection = [String]()
    var screenNameCollection = [String]()
    var topicSelected : String?
    var majorityTweets : String?
    let tweetClassifier = TweetClassifier()
    var emoji : String?
    var percentage : Float?
    var topicDescription : String?
    var totalPos = 0
    var totalNeg = 0
    var total = 0
    var activityData : ActivityData?
    var refreshControl = UIRefreshControl()
    let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey, oauthToken: K.oathToken!, oauthTokenSecret: K.oathSecretToken!)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        trendingViewHeight.constant = UIScreen.main.bounds.height * 0.21
        textHeight.constant = trendingViewHeight.constant * 0.74
        trendingView.layer.shadowRadius = 4
        trendingView.layer.shadowOpacity = 1
        trendingView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        trendingView.layer.shadowOffset = CGSize(width: 0 , height: 3)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        trendTable.addSubview(refreshControl) // not required when using UITableViewController
        activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", type: .ballPulseSync)
        swifter.getTrendsPlace(with: "23424977", excludeHashtags: false, success:
        { (response) in
            let trends = response[0]["trends"]
            for i in 0..<25
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
        self.trendTable.backgroundColor = UIColor(red: 0.22, green: 0.63, blue: 0.95, alpha: 1.00)
        trendTable.separatorStyle = .none
        trendTable.register(UINib(nibName: K.favoriteCellNibName, bundle: nil), forCellReuseIdentifier: K.favoriteCellID)
    }

    @objc func refresh(_ sender: AnyObject)
    {
        trendingItems.removeAll()
        swifter.getTrendsPlace(with: "23424977", excludeHashtags: false, success:
        { (response) in
            let trends = response[0]["trends"]
            for i in 0..<25
            {
                if let trend = trends[i]["name"].string
                {
                    self.trendingItems.append(trend)
                }
            }
            self.trendTable.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750))
            {
                self.refreshControl.endRefreshing()
            }
        })
        { (error) in
            print(error)
        }
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        let destinationVC = segue.destination as! TrendViewController
        destinationVC.tweetText = tweetCollection
        destinationVC.topicText = topicSelected
        destinationVC.screenNameCollection = self.screenNameCollection
        destinationVC.userNameCollection = self.usernameCollection
        destinationVC.profileImageCollection = self.profileImageCollection
        destinationVC.emoji = self.emoji
        destinationVC.topicDescription = self.topicDescription
        destinationVC.majority = self.majorityTweets
        destinationVC.percentage = self.percentage
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
                    totalPos += 1
                }

                else if pred.label == "Neg"
                {
                    totalNeg += 1
                }
                total += 1
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
       var positivityPercent : Float = 0.0
        
       positivityPercent = Float(totalPos) / Float(total)
       let negativityPercent = Float(totalNeg) / Float(total)
        
       if (Double(positivityPercent - 0.50).magnitude <= 0.1)
       {
            majorityTweets = "Even"
            percentage = 0.50
            emoji = "😐"
            topicDescription = "\(topicSelected!) is controversial"
       }
        
       else if (positivityPercent > negativityPercent)
       {
            majorityTweets = "Pos"
            percentage = positivityPercent
            if positivityPercent > 0.85
            {
                emoji = "😍"
                topicDescription = "People love \(topicSelected!)"
            }
            
            else if positivityPercent > 0.7
            {
                emoji = "😄"
                topicDescription = "People are really happy with \(topicSelected!)"
            }
            
            else
            {
                emoji = "🙂"
                topicDescription = "People are happy with \(topicSelected!)"
            }
       }
        
       else
       {
            majorityTweets = "Neg"
            percentage = negativityPercent
            if negativityPercent > 0.85
            {
                 emoji = "🤮"
                 topicDescription = "People are disgusted with \(topicSelected!)"
            }
            
            else if negativityPercent > 0.7
            {
                emoji = "😡"
                topicDescription = "People are really unhappy with \(topicSelected!)"
            }
            
            else
            {
                emoji = "☹️"
                topicDescription = "People aren't happy about \(topicSelected!)"
            }
       }
    }

}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let data = activityData
        {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
        }
        tweetCollection.removeAll()
        usernameCollection.removeAll()
        profileImageCollection.removeAll()
        screenNameCollection.removeAll()
        emoji = ""
        totalPos = 0
        totalNeg = 0
        total = 0
        topicDescription = ""
        let cell = tableView.cellForRow(at: indexPath) as! TrendTableViewCell
        if let topicSelected = cell.trendLabel.text
        {
            self.topicSelected = topicSelected
            let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey)
            
            swifter.searchTweet(using: topicSelected, lang: "en", resultType: "mixed", count: 100,tweetMode: .extended, success:
            { (tweets, metadata) in
                var tweetsToAnalyze : [TweetClassifierInput] = []
                for i in 0..<100
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
            cell.trendLabel.baselineAdjustment = .alignCenters
            cell.rankLabel.baselineAdjustment = .alignCenters
            cell.trendLabel.text = trendingItems[indexPath.row]
            cell.rankLabel.text = "#\(indexPath.row + 1)"
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

