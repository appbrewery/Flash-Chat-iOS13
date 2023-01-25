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

	@IBOutlet weak var messageBodyLabel: UILabel?

	@IBOutlet weak var senderLabel: UILabel?

	@IBOutlet weak var dateTimeLabel: UILabel?

	@IBOutlet weak var leftImageView: UIImageView?
	
	@IBOutlet weak var rightImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		// Don't update cell contents here
		messageBubble?.layer.cornerRadius = (messageBubble?.frame.size.height)! / 5
    }
    
}
