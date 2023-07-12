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
    
    var targetViewController: UIViewController?
    var replyId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBackground.setRoundedBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func replyButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "reportViewController") as! STReportViewController
        viewController.target = .reply
        viewController.replyId = replyId
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        guard let targetViewController = targetViewController else { return }
        targetViewController.present(viewController, animated: true)
    }
    
}
