//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Ольга Егорова on 01.07.2022.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Nib - устаревшее название XIB, метод инициализирует появление ячейки
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height/5
        //установили радиус закругления как 1/5 высоты рамки сообщения
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
