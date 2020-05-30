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
    @IBOutlet weak var positivityScale: UILabel!
    
    var tweetText : [String]?
    var screenNameCollection : [String]?
    var userNameCollection : [String]?
    var profileImageCollection : [String]?
    // var attachedImages : [String]?
    var topicText : String?
    var emoji : String?
    var topicDescription : String?
    var majority : String?
    var percentage : Float?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        analysisDescription.numberOfLines = 0
        analysisDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        analysisDescription.sizeToFit()
        if let topic = topicText { topicLabel.text = topic }
        if let emojiToPut = emoji { emojiLabel.text = emojiToPut}
        if let anylDescription = topicDescription { analysisDescription.text = anylDescription}
        if let maj = majority, let per = percentage
        {
            let editedPercentage = String(format : "%.0f", per * 100)
            if let topic = topicText
            {
                switch maj
                {
                    case "Pos" :
                        positivityScale.text = "\(editedPercentage)% of \(topic) tweets are positive"
                    case "Neg" :
                        positivityScale.text = "\(editedPercentage)% of \(topic) tweets are negative"
                    default:
                        positivityScale.text = "\(topicText!) tweets are pretty evenly split"
                }
            }
        }
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
            cell.username.text = userNames[indexPath.row]
            cell.screenname.text = "@\(screenNames[indexPath.row])"
            
            if let url = URL(string: images[indexPath.row])
            {
                cell.profilepic.sd_setImage(with: url)
            }
            
            if let input = String(htmlEncodedString: tweets[indexPath.row])
            {
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
                var parsed : String = ""
                if !matches.isEmpty
                {
                    for match in matches
                    {
                        guard let range = Range(match.range, in: input) else { continue }
                        let url = input[range]
                        parsed = input.replacingOccurrences(of: url, with: "")
                    }
                    cell.tweetText.text = parsed
                }
                
                else
                {
                    cell.tweetText.text = input
                }
            }
            
            else
            {
                cell.tweetText.text = tweets[indexPath.row]
            }
        }
        
        return cell
    }
    
    
}

extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)

    }

}
