//
//  SearchViewController.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/21/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit
import SwifteriOS
import NVActivityIndicatorView

class SearchViewController: UIViewController
{

    @IBOutlet weak var topicSearchBar: UISearchBar!
    @IBOutlet weak var searchHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextHeight: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    
    var trendingItems = [String]()
    var tweetCollection = [String]()
    var profileImageCollection = [String]()
    var usernameCollection = [String]()
    var screenNameCollection = [String]()
    var topicSelected : String?
    let tweetClassifier = TweetClassifier()
    var emoji : String?
    var topicDescription : String?
    var majorityTweets : String?
    var percentage : Float?
    var totalPos = 0
    var totalNeg = 0
    var total = 0
    var activityData : ActivityData?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchHeight.constant = UIScreen.main.bounds.height * 0.21
        searchTextHeight.constant = searchHeight.constant * 0.74
        searchView.layer.shadowRadius = 4
        searchView.layer.shadowOpacity = 1
        searchView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        searchView.layer.shadowOffset = CGSize(width: 0 , height: 3)
        activityData = ActivityData(size: CGSize(width: 50, height: 50), message: "", type: .ballPulseSync)
        
        topicSearchBar.backgroundImage = UIImage()
        topicSearchBar.backgroundColor = .clear
        
        if #available(iOS 13.0, *)
        {
            topicSearchBar.searchTextField.backgroundColor = .white
            topicSearchBar.searchTextField.textColor = .black
        }
        topicSearchBar.delegate = self
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
            fatalError(error.localizedDescription)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        let destinationVC = segue.destination as! SearchResultViewController
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

}

extension SearchViewController : UISearchBarDelegate, NVActivityIndicatorViewable
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if let data = activityData
        {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(data)
        }
        tweetCollection.removeAll()
        usernameCollection.removeAll()
        profileImageCollection.removeAll()
        screenNameCollection.removeAll()
        totalPos = 0
        totalNeg = 0
        total = 0
        emoji = ""
        topicDescription = ""
        if let topicSelected = searchBar.text
        {
            self.topicSelected = topicSelected
            let swifter = Swifter(consumerKey: K.apiKey, consumerSecret: K.sercretKey)
            
            swifter.searchTweet(using: topicSelected, lang: "en", resultType: "mixed", count: 100, tweetMode: .extended, success:
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
                self.performSegue(withIdentifier: K.searchTopicSegue, sender: self)
            }) { (error) in
                fatalError(error.localizedDescription)
            }
        }
    }
}
