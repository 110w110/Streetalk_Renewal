//
//  STPostContentsCollectionViewCell.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/26.
//

import UIKit

class STPostContentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var contentsViewBackground: UIStackView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var postContentsLabel: UILabel!
    @IBOutlet var commentImageView: UIImageView!
    @IBOutlet var commentCountLabel: UILabel!
    @IBOutlet var likeIamgeView: UIImageView!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var scrapImageView: UIImageView!
    @IBOutlet var scrapCountLabel: UILabel!
    @IBOutlet var bottomStackView: UIStackView!
    
    override func setNeedsLayout() {
        bottomStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
