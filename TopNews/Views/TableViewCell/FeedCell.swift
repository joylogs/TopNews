//
//  FeedCell.swift
//  TopNews
//
//  Created by Joy Banerjee on 09/01/19.
//  Copyright © 2019 Joy Banerjee. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet var feedImage: UIImageView!
    @IBOutlet var feedTitle: UILabel!
    @IBOutlet var feedDescription: UILabel!
    @IBOutlet var timeLapsed: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
