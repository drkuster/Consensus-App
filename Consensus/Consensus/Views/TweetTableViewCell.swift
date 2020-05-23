//
//  TweetTableViewCell.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/20/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        viewBubble.layer.cornerRadius = viewBubble.frame.height / 20
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
