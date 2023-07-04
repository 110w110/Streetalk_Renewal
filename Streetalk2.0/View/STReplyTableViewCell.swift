//
//  STReplyTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/04.
//

import UIKit

class STReplyTableViewCell: UITableViewCell {

    @IBOutlet var cellBackground: UIView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.setRoundedBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
