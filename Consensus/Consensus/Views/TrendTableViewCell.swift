//
//  TrendTableViewCell.swift
//  Consensus
//
//  Created by Dylan Kuster on 5/18/20.
//  Copyright © 2020 Dylan Kuster. All rights reserved.
//

import UIKit

class TrendTableViewCell: UITableViewCell
{

    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var trendLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        viewBubble.layer.cornerRadius = viewBubble.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
