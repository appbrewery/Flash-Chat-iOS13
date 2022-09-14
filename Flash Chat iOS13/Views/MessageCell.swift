//
//  MessageCell.swift
//  Flash Chat
//
//  Created by TechWithTyler on 9/9/22.
//  Copyright © 2022 TechWithTyler. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

	@IBOutlet weak var messageBubble: UIView?

	@IBOutlet weak var label: UILabel?

	@IBOutlet weak var leftImageView: UIImageView?
	
	@IBOutlet weak var rightImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		messageBubble?.layer.cornerRadius = (messageBubble?.frame.size.height)! / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
