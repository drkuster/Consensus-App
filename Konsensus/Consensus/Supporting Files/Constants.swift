//
//  Constants.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/17/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import Foundation

struct K
{
    static let apiKey = "O1ugaJgvt97js9bcq3XfZNaiT"
    static let sercretKey = "k7BoQ3n0QrWqT4xZ25BfBGtvbAfvlhRnteb9n6Utz75YcrG2UK"
    static var oathToken : String?
    static var oathSecretToken : String?
    static let welcomeSegue = "goToWelcome"
    static let homeSegue = "goToHome"
    static let homeLoggedInSegue = "goToHomeLOGGEDIN"
    static let trendSegue = "showTrend"
    static let favoriteCellID = "reusableCell"
    static let favoriteCellNibName = "TrendTableViewCell"
    static let trendCellID = "trendCell"
    static let trendCellNibName = "TweetTableViewCell"
    static let searchTopicSegue = "goToSearchResult"
}
