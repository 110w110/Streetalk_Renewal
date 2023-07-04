//
//  STPostTableViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/30.
//

import UIKit

class STPostTableViewCell: UITableViewCell {

    @IBOutlet var cellBackground: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var bottomStackView: UIStackView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.setRoundedBorder()
        bottomStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bottomStackView.isLayoutMarginsRelativeArrangement = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
